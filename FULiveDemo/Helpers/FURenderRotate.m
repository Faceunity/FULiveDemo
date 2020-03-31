//
//  FURenderRotate.m
//  FULiveDemo
//
//  Created by ly on 16/11/2.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "FURenderRotate.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#include <sys/mman.h>
#include <sys/stat.h>



#define documentPath   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define STRINGIZE(x)    #x
#define STRINGIZE2(x)    STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const kRotateYUVToRGBAFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
     mediump vec3 yuv;
     lowp vec3 rgb;
     
     yuv.x = texture2D(luminanceTexture, textureCoordinate).r;
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).rg - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;
     
     gl_FragColor = vec4(rgb, 1.0);
 }
);

NSString *const kRotateRGBAFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 
 uniform float h_threshold;
 uniform float h_scale0;
 uniform float x_delta0;
 uniform float h_scale1;
 uniform float type420;
 uniform float typeNv12;
 uniform float useSelfAlpha;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
{
    if(type420!=1.0){
        if(useSelfAlpha == 1.0){
            gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
        }else{
            gl_FragColor = vec4(texture2D(inputImageTexture, textureCoordinate).rgb, 1.0);
        }
    }else
    {
        highp vec2 st0;
        highp vec2 st1;
        highp vec2 st2;
        highp vec2 st3;
        highp vec4 m0;
        highp vec4 m1;
        float base;
        if(textureCoordinate.y<h_threshold){
            st0=textureCoordinate*vec2(1.0,h_scale0)+vec2((-1.5)*x_delta0,0.0);
            st1=st0+vec2(x_delta0,0.0);
            st2=st0+vec2(x_delta0*2.0,0.0);
            st3=st0+vec2(x_delta0*3.0,0.0);
            m0=vec4(0.299,0.587,0.114,0.0);
            m1=vec4(0.299,0.587,0.114,0.0);
            base=0.0;
        }else{
            st0=vec2(textureCoordinate.x,textureCoordinate.y-h_threshold)*vec2(1.0,h_scale1)+vec2((-1.0)*x_delta0,0.0);
            st1=st0;
            st2=st0+vec2(x_delta0*2.0,0.0);
            st3=st2;
            if(typeNv12==0.0){
                m0=vec4(0.499,-0.418,-0.0813,0.0);
                m1=vec4(-0.169,-0.331,0.499,0.0);
            }else{
                m0=vec4(-0.169,-0.331,0.499,0.0);
                m1=vec4(0.499,-0.418,-0.0813,0.0);
            }
            base=0.5;
        }
        gl_FragColor=vec4(
                          dot(texture2D(inputImageTexture,st0),m0)+base,
                          dot(texture2D(inputImageTexture,st1),m1)+base,
                          dot(texture2D(inputImageTexture,st2),m0)+base,
                          dot(texture2D(inputImageTexture,st3),m1)+base).bgra;
    }
}
 );

NSString *const kRotateVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
 }
);

NSString *const FURotatePointsFrgShaderString = SHADER_STRING
(
 precision mediump float;
 
 varying highp vec4 fragmentColor;
 
 void main()
{
    if (-smoothstep(0.48, 0.5, length(gl_PointCoord - vec2(0.5))) + 1.0 == 0.0) {
        discard;
    }
    gl_FragColor = fragmentColor;
}
 
 );

NSString *const FURotatePointsVtxShaderString = SHADER_STRING
(
 attribute vec4 position;
 
 attribute float point_size;
 
 attribute vec4 inputColor;
 
 varying vec4 fragmentColor;
 
 void main()
{
    gl_Position = position;
    
    gl_PointSize = point_size;
    
    fragmentColor = inputColor;
}
 );

enum
{
    rgbPositionAttribute,
    rgbTextureCoordinateAttribute
};

enum
{
    furgbaPositionAttribute,
    furgbaTextureCoordinateAttribute,
    fuPointSize,
    fuPointColor,
};

enum
{
    yuvConversionPositionAttribute,
    yuvConversionTextureCoordinateAttribute
};

@interface FURenderRotate ()
@property (nonatomic, strong) EAGLContext *mContext;

@property (nonatomic, strong) EAGLContext *tmpContext;

@property (nonatomic, assign) CVPixelBufferRef renderTarget;

@property (nonatomic, assign) CVPixelBufferRef resizeRenderTarget;

@property (nonatomic, assign) CVPixelBufferRef yuvRenderTarget;

@property (nonatomic, assign) int rotateType ;

@end

static FURenderRotate *_shareRenderer = nil;

@implementation FURenderRotate
{
    GLuint program;
    GLuint rgbToYuvProgram;
    GLuint pointProgram;
    CVOpenGLESTextureRef _texture;
    CVOpenGLESTextureCacheRef _videoTextureCache;
    GLuint _frameBufferHandle;
    CVOpenGLESTextureRef renderTexture;
    
    GLint yuvConversionLuminanceTextureUniform, yuvConversionChrominanceTextureUniform;
    GLint yuvConversionMatrixUniform;
    GLint displayInputTextureUniform;
    
    int frameWidth;
    int frameHeight;
    
    int resizeFrameWidth;
    int resizeFrameHeight;
    
    GLuint _resizeFrameBufferHandle;
    CVOpenGLESTextureRef resizeRenderTexture;
    
    GLuint h_threshold_yUniform;
    GLuint h_scale0_yUniform;
    GLuint x_delta0_yUniform;
    GLuint h_scale1_yUniform;
    GLuint type420_yUniform;
    GLuint typeNv12_yUniform;
    GLuint useSelfAlphaUniform;
}

- (void)setBackCurrentContext
{
    EAGLContext *tmp = [EAGLContext currentContext];
    
    if (self.tmpContext != tmp) {
        [EAGLContext setCurrentContext:self.tmpContext];
    }
    
    self.tmpContext = nil;
}

- (void)setUpCurrentContext
{
    self.tmpContext = [EAGLContext currentContext];
    
    if (self.mContext && self.tmpContext != self.mContext) {
        if (![EAGLContext setCurrentContext:self.mContext]) {
            NSLog(@"FURenderRotate setCurrentContext failed");
        }
    }
}

- (void)setMContext:(EAGLContext *)mContext
{
    if (!_mContext) {
        _mContext = mContext;
        [self setUpCurrentContext];
        [self setupGL];
        [self setBackCurrentContext];
    }else
    {
        NSLog(@"FURenderRotate setShareContext failed,because it has be setted");
    }
}

- (void)setup
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
////        fuSetup(data, ardata, package, size);
//
//            self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//
//    });
    
    self.mContext  = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
}

- (void)rotateBufferType:(int)aa{
    self.rotateType = aa;
}


- (void)setupGL
{
    [self loadShadersRGB];
    [self loadShadersYUV];
    
    // Create CVOpenGLESTextureCacheRef for optimal CVPixelBufferRef to GLES texture conversion.
    if (!_videoTextureCache) {
        EAGLContext *context = self.mContext;
        if (!context) {
            context =  [EAGLContext currentContext];
            NSAssert(context, @"Faceunity ERROR: EAGLContext currentContext is nil");
        }
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, context, NULL, &_videoTextureCache);
        if (err != noErr) {
            NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
            return;
        }
    }
}

- (void)setupBuffer
{
    
    [self setUpCurrentContext];
    
    if (_frameBufferHandle) {
        glDeleteFramebuffers(1, &_frameBufferHandle);
        _frameBufferHandle = 0;
    }
    
    if (_renderTarget) {
        CVPixelBufferRelease(_renderTarget);
        _renderTarget = nil;
    }
    
    if (renderTexture) {
        CFRelease(renderTexture);
        renderTexture = nil;
    }
    
    if (!_frameBufferHandle) {
        glGenFramebuffers(1, &_frameBufferHandle);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferHandle);
    }
    
    CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault,
                                                  _videoTextureCache, self.renderTarget,
                                                  NULL, // texture attributes
                                                  GL_TEXTURE_2D,
                                                  GL_RGBA, // opengl format
                                                  frameWidth,
                                                  frameHeight,
                                                  GL_BGRA, // native iOS format
                                                  GL_UNSIGNED_BYTE,
                                                  0,
                                                  &renderTexture);
    glBindTexture(CVOpenGLESTextureGetTarget(renderTexture), CVOpenGLESTextureGetName(renderTexture));
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    //    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 720, 1280, 0, GL_BGRA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(renderTexture), 0);
    glBindTexture(GL_TEXTURE_2D, 0);

    [self setBackCurrentContext];
}

- (void)setupResizeBuffer
{
    [self setUpCurrentContext];
    
    if (_resizeFrameBufferHandle) {
        glDeleteFramebuffers(1, &_resizeFrameBufferHandle);
        _resizeFrameBufferHandle = 0;
    }
    
    if (_resizeRenderTarget) {
        CVPixelBufferRelease(_resizeRenderTarget);
        _resizeRenderTarget = nil;
    }
    
    if (resizeRenderTexture) {
        CFRelease(resizeRenderTexture);
        resizeRenderTexture = nil;
    }
    
    if (!_resizeFrameBufferHandle) {
        glGenFramebuffers(1, &_resizeFrameBufferHandle);
        glBindFramebuffer(GL_FRAMEBUFFER, _resizeFrameBufferHandle);
    }
    
    CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault,
                                                  _videoTextureCache, self.resizeRenderTarget,
                                                  NULL, // texture attributes
                                                  GL_TEXTURE_2D,
                                                  GL_RGBA, // opengl format
                                                  resizeFrameWidth,
                                                  resizeFrameHeight,
                                                  GL_BGRA, // native iOS format
                                                  GL_UNSIGNED_BYTE,
                                                  0,
                                                  &resizeRenderTexture);
    glBindTexture(CVOpenGLESTextureGetTarget(resizeRenderTexture), CVOpenGLESTextureGetName(resizeRenderTexture));
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    //    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 720, 1280, 0, GL_BGRA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(resizeRenderTexture), 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    [self setBackCurrentContext];
}

- (CVPixelBufferRef)renderTarget
{
    if (!_renderTarget && !(frameWidth == 0 || frameHeight == 0)) {
        CFDictionaryRef empty; // empty value for attr value.
        CFMutableDictionaryRef attrs;
        empty = CFDictionaryCreate(kCFAllocatorDefault, // our empty IOSurface properties dictionary
                                   NULL,
                                   NULL,
                                   0,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   &kCFTypeDictionaryValueCallBacks);
        attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                          1,
                                          &kCFTypeDictionaryKeyCallBacks,
                                          &kCFTypeDictionaryValueCallBacks);
        
        CFDictionarySetValue(attrs,
                             kCVPixelBufferIOSurfacePropertiesKey,
                             empty);
        
        CVReturn theError = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth, frameHeight, kCVPixelFormatType_32BGRA, attrs, &_renderTarget);
        
        if (theError)
        {
//            NSLog(@"FBO size");
        }
        
        CFRelease(attrs);
        CFRelease(empty);
    }
    
    return _renderTarget;
}

- (CVPixelBufferRef)resizeRenderTarget
{
    if (!_resizeRenderTarget && !(resizeFrameWidth == 0 || resizeFrameHeight == 0)) {
        CFDictionaryRef empty; // empty value for attr value.
        CFMutableDictionaryRef attrs;
        empty = CFDictionaryCreate(kCFAllocatorDefault, // our empty IOSurface properties dictionary
                                   NULL,
                                   NULL,
                                   0,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   &kCFTypeDictionaryValueCallBacks);
        attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                          1,
                                          &kCFTypeDictionaryKeyCallBacks,
                                          &kCFTypeDictionaryValueCallBacks);
        
        CFDictionarySetValue(attrs,
                             kCVPixelBufferIOSurfacePropertiesKey,
                             empty);
        
        CVReturn theError = CVPixelBufferCreate(kCFAllocatorDefault, resizeFrameWidth, resizeFrameHeight, kCVPixelFormatType_32BGRA, attrs, &_resizeRenderTarget);
        
        if (theError)
        {
            //            NSLog(@"FBO size");
        }
        
        CFRelease(attrs);
        CFRelease(empty);
    }
    
    return _resizeRenderTarget;
}

- (CVPixelBufferRef)yuvRenderTarget
{
    if (!_yuvRenderTarget && !(frameWidth == 0 || frameHeight == 0)) {
        NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
        CVReturn theError = CVPixelBufferCreate(kCFAllocatorDefault,
                                              frameWidth,
                                              frameHeight,
                                              kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                              (__bridge CFDictionaryRef)(pixelAttributes),
                                              &_yuvRenderTarget);
        
        if (theError)
        {
//            NSLog(@"FBO size");
        }
    }
    
    return _yuvRenderTarget;
}


- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withLandmarks:(float *)landmarks count:(int)count MAX:(BOOL)max
{
    if (pixelBuffer == NULL) return pixelBuffer;
    
    [self setUpCurrentContext];
    
    if (!_videoTextureCache) {
        
        [self setupGL];
        
        NSLog(@"No video texture cache");
        
//        [self setBackCurrentContext];
        
//        return pixelBuffer;
    }
    
    
    OSType type = CVPixelBufferGetPixelFormatType(pixelBuffer);
    
    int renderframeWidth = (int)CVPixelBufferGetWidth(self.renderTarget);
    int renderframeHeight = (int)CVPixelBufferGetHeight(self.renderTarget);
    
    frameWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
    frameHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    if (frameWidth > frameHeight){
        float tepm = frameWidth ;
        frameWidth = frameHeight;
        frameHeight = tepm;
    }

    
    if (frameHeight != renderframeHeight || frameWidth != renderframeWidth) {
        [self setupBuffer];
//        return pixelBuffer;
    }
    
    
    if (type == kCVPixelFormatType_32BGRA)
    {
        [self cleanUpTextures];
        
        int width = (int)CVPixelBufferGetWidth(pixelBuffer);
        int height = (int)CVPixelBufferGetHeight(pixelBuffer);
        
        CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, _videoTextureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RGBA, width, height,GL_BGRA, GL_UNSIGNED_BYTE, 0, &_texture);
        
        if (!_texture || err) {
            NSLog(@"Camera CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);
            
            [self setBackCurrentContext];
            
            return pixelBuffer;
        }
        
        glBindTexture(GL_TEXTURE_2D, CVOpenGLESTextureGetName(_texture));
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        
        int stride = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
        
        GLuint textureHandle = CVOpenGLESTextureGetName(_texture);
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        glUseProgram(program);
        
        GLint preFBO;
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &preFBO);
        
        GLint port[4];
        glGetIntegerv(GL_VIEWPORT, port);

        glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferHandle);
        
        // Set the view port to the entire view.
        glViewport(0, 0, frameWidth, frameHeight);
        
        glClearColor(0.1f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        glActiveTexture(GL_TEXTURE4);
        glBindTexture(GL_TEXTURE_2D, textureHandle);
        glUniform1i(displayInputTextureUniform, 4);
        
        GLfloat vertices[] =  {
            -1.0f, -1.0f,
            1.0f, -1.0f,
            -1.0f,  1.0f,
            1.0f,  1.0f,
        };
//        if (!CGSizeEqualToSize(customSize, CGSizeZero)) {
//            const float dH      = (float)frameHeight / height;
//            const float dW      = (float)frameWidth      / width;
//            const float dd      = MAX(dH, dW);
//            const float h       = (height * dd / (float)frameHeight);
//            const float w       = (width  * dd / (float)frameWidth );
//            
//            vertices[0] = - w;
//            vertices[1] = - h;
//            vertices[2] =   w;
//            vertices[3] = - h;
//            vertices[4] = - w;
//            vertices[5] =   h;
//            vertices[6] =   w;
//            vertices[7] =   h;
//        }
        
        // 更新顶点数据
        glVertexAttribPointer(rgbPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
        glEnableVertexAttribArray(rgbPositionAttribute);
        
        GLfloat *quadTextureData;
        if (_rotateType == 0) {
            GLfloat quadTextureData0[] =  {
                0.0f, 0.0f,
                1.0f, 0.0f,
                0.0f, 1.0f,
                1.0f, 1.0f,
            };
            quadTextureData = quadTextureData0;

        }
        
        if (_rotateType == 1) {
            GLfloat quadTextureData0[] =  {
                0.0f, 0.0f,
                0.0f, 1.0f,
                1.0f, 0.0f,
                1.0f, 1.0f,
            };
            quadTextureData = quadTextureData0;
        }
        
        if (_rotateType == 2) {
            GLfloat quadTextureData0[] =  {
                1.0f, 0.0f,
                0.0f, 0.0f,
                1.0f, 1.0f,
                0.0f, 1.0f,
            };
            quadTextureData = quadTextureData0;
        }
        
        if (_rotateType == 3) {
            GLfloat quadTextureData0[] =  {
                1.0f, 0.0f,
                1.0f, 1.0f,
                0.0f, 0.0f,
                0.0f, 1.0f,
            };
            quadTextureData = quadTextureData0;
        }
 
        
        
        glVertexAttribPointer(rgbTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, quadTextureData);
        glEnableVertexAttribArray(rgbTextureCoordinateAttribute);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glFinish();
        
        if (count) {
            [self prepareToDrawLandmarks:landmarks count:count MAX:max];
        }

        
        glBindFramebuffer(GL_FRAMEBUFFER, preFBO);
        glViewport(port[0], port[1], port[2], port[3]);
        
//        if (!readBack) {
            [self setBackCurrentContext];
//            CVPixelBufferLockBaseAddress(self.renderTarget, 0);
            return self.renderTarget;
//        }
        

        size_t h1 = CVPixelBufferGetHeight(self.renderTarget);
        int stride1 = (int)CVPixelBufferGetBytesPerRow(self.renderTarget);
        uint8_t *newImg = CVPixelBufferGetBaseAddress(self.renderTarget);
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        uint8_t *oldImg = CVPixelBufferGetBaseAddress(pixelBuffer);
        memcpy(oldImg, newImg, stride1*h1);
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        CVPixelBufferUnlockBaseAddress(self.renderTarget, 0);

    }
    
    
    [self setBackCurrentContext];
    
    return pixelBuffer;
}

- (void)prepareToDrawLandmarks:(float *)landmarks count:(int)count MAX:(BOOL)max
{
    if (!pointProgram) {
        [self loadPointsShaders];
    }
    
    glUseProgram(pointProgram);
    
    count = count/2;
    
    float sizeData[count];
    
    float colorData[count * 4];
    
    for (int i = 0; i < count; i++)
    {
        //点的大小
        sizeData[i] = 10;
        
        //点的颜色
        colorData[4 * i] = 1.0;
        colorData[4 * i + 1] = .0;
        colorData[4 * i + 2] = .0;
        colorData[4 * i + 3] = .0;
        
        
        //转化坐标
        landmarks[2 * i] = (float)((2 * landmarks[2 * i] / frameWidth - 1));
        landmarks[2 * i + 1] = (float)(1 - 2 * landmarks[2 * i + 1] / frameHeight)*-1;
        
    }
    
    glEnableVertexAttribArray(fuPointSize);
    glVertexAttribPointer(fuPointSize, 1, GL_FLOAT, GL_FALSE, 0, sizeData);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (GLfloat *)landmarks);
    
    glEnableVertexAttribArray(fuPointColor);
    glVertexAttribPointer(fuPointColor, 4, GL_FLOAT, GL_FALSE, 0, colorData);
    
    glDrawArrays(GL_POINTS, 0, count);
    glFinish();
}


- (CVPixelBufferRef)getPixelBufferFromTexture:(int)texture textureSize:(CGSize)textureSize outputSize:(CGSize)outPutSize outputFormat:(int)outputFormat{
    
    
    
    return self.resizeRenderTarget;
}
- (CVPixelBufferRef)resizePixelBuffer:(CVPixelBufferRef)pixelBuffer resizeSize:(CGSize)resizeSize
{
    if (pixelBuffer == NULL) return pixelBuffer;
    
    [self setUpCurrentContext];
    
    if (!_videoTextureCache) {
        [self setupGL];
    }
    
    OSType type = CVPixelBufferGetPixelFormatType(pixelBuffer);
    
    int renderframeWidth = (int)CVPixelBufferGetWidth(self.resizeRenderTarget);
    int renderframeHeight = (int)CVPixelBufferGetHeight(self.resizeRenderTarget);
    
    resizeFrameWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
    resizeFrameHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    if (!CGSizeEqualToSize(resizeSize, CGSizeZero)) {
        if (type == kCVPixelFormatType_32BGRA)
        {
            resizeFrameWidth = resizeSize.width;
            resizeFrameHeight = resizeSize.height;
        }else
        {
            NSLog(@"该接口目前仅支持自定义BGRA格式的pixelBuffer的输出分辨率");
            return pixelBuffer;
        }
    }
    
    if (resizeFrameHeight != renderframeHeight || resizeFrameWidth != renderframeWidth) {
        [self setupResizeBuffer];
    }
    
    [self cleanUpTextures];
    
    int width = (int)CVPixelBufferGetWidth(pixelBuffer);
    int height = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, _videoTextureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RGBA, width, height,GL_BGRA, GL_UNSIGNED_BYTE, 0, &_texture);
    
    if (!_texture || err) {
        NSLog(@"Camera CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);
        
        [self setBackCurrentContext];
        
        return pixelBuffer;
    }
    
    glBindTexture(GL_TEXTURE_2D, CVOpenGLESTextureGetName(_texture));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    GLuint textureHandle = CVOpenGLESTextureGetName(_texture);
    
    glUseProgram(program);
    
    GLint preFBO;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &preFBO);
    
    GLint port[4];
    glGetIntegerv(GL_VIEWPORT, port);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _resizeFrameBufferHandle);
    
    // Set the view port to the entire view.
    glViewport(0, 0, resizeFrameWidth, resizeFrameHeight);
    
    glClearColor(0.1f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, textureHandle);
    glUniform1i(displayInputTextureUniform, 4);
    
    GLfloat vertices[] =  {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    if (!CGSizeEqualToSize(resizeSize, CGSizeZero)) {
        const float dH      = (float)resizeFrameHeight / height;
        const float dW      = (float)resizeFrameWidth      / width;
        const float dd      = MAX(dH, dW);
        const float h       = (height * dd / (float)resizeFrameHeight);
        const float w       = (width  * dd / (float)resizeFrameWidth);
        
        vertices[0] = - w;
        vertices[1] = - h;
        vertices[2] =   w;
        vertices[3] = - h;
        vertices[4] = - w;
        vertices[5] =   h;
        vertices[6] =   w;
        vertices[7] =   h;
    }
    
    // 更新顶点数据
    glVertexAttribPointer(rgbPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glEnableVertexAttribArray(rgbPositionAttribute);
    
    GLfloat quadTextureData[] =  {
        
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    glVertexAttribPointer(rgbTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, quadTextureData);
    glEnableVertexAttribArray(rgbTextureCoordinateAttribute);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glFinish();
    
    glBindFramebuffer(GL_FRAMEBUFFER, preFBO);
    glViewport(port[0], port[1], port[2], port[3]);
    
    [self setBackCurrentContext];
    
    return self.resizeRenderTarget;
}

- (void)dealloc
{
    [self cleanUpTextures];
    
    if(_videoTextureCache) {
        CFRelease(_videoTextureCache);
    }
}

- (void)cleanUpTextures
{
    if (_texture) {
        CFRelease(_texture);
        _texture = NULL;
    }
    
    // Periodic texture cache flush every frame
    CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShadersRGB
{
    GLuint vertShader, fragShader;
    
    if (!program) {
        program = glCreateProgram();
    }
    
    // Create and compile the vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER string:kRotateVertexShaderString]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER string:kRotateRGBAFragmentShaderString]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations. This needs to be done prior to linking.
    glBindAttribLocation(program, rgbPositionAttribute, "position");
    glBindAttribLocation(program, rgbTextureCoordinateAttribute, "inputTextureCoordinate");
    
    // Link the program.
    if (![self linkProgram:program]) {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    displayInputTextureUniform = glGetUniformLocation(program, "inputImageTexture");
    h_threshold_yUniform = glGetUniformLocation(program, "h_threshold");
    h_scale0_yUniform = glGetUniformLocation(program, "h_scale0");
    x_delta0_yUniform = glGetUniformLocation(program, "x_delta0");
    h_scale1_yUniform = glGetUniformLocation(program, "h_scale1");
    type420_yUniform = glGetUniformLocation(program, "type420");
    typeNv12_yUniform = glGetUniformLocation(program, "typeNv12");
    useSelfAlphaUniform = glGetUniformLocation(program, "useSelfAlpha");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)loadPointsShaders
{
    GLuint vertShader, fragShader;
    
    pointProgram = glCreateProgram();
    
    // Create and compile the vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER string:FURotatePointsVtxShaderString]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER string:FURotatePointsFrgShaderString]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(pointProgram, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(pointProgram, fragShader);
    
    // Bind attribute locations. This needs to be done prior to linking.
    glBindAttribLocation(pointProgram, fuPointSize, "point_size");
    glBindAttribLocation(pointProgram, fuPointColor, "inputColor");
    
    // Link the program.
    if (![self linkProgram:pointProgram]) {
        NSLog(@"Failed to link program: %d", pointProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (pointProgram) {
            glDeleteProgram(pointProgram);
            pointProgram = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(pointProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(pointProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)loadShadersYUV
{
    GLuint vertShader, fragShader;
    
    if (!rgbToYuvProgram) {
        rgbToYuvProgram = glCreateProgram();
    }
    
    // Create and compile the vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER string:kRotateVertexShaderString]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER string:kRotateYUVToRGBAFragmentShaderString]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to rgbToYuvProgram.
    glAttachShader(rgbToYuvProgram, vertShader);
    
    // Attach fragment shader to rgbToYuvProgram.
    glAttachShader(rgbToYuvProgram, fragShader);
    
    // Bind attribute locations. This needs to be done prior to linking.
    glBindAttribLocation(rgbToYuvProgram, yuvConversionPositionAttribute, "position");
    glBindAttribLocation(rgbToYuvProgram, yuvConversionTextureCoordinateAttribute, "inputTextureCoordinate");
    
    // Link the rgbToYuvProgram.
    if (![self linkProgram:rgbToYuvProgram]) {
        NSLog(@"Failed to link program: %d", rgbToYuvProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (rgbToYuvProgram) {
            glDeleteProgram(rgbToYuvProgram);
            rgbToYuvProgram = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    yuvConversionLuminanceTextureUniform = glGetUniformLocation(rgbToYuvProgram, "luminanceTexture");
    yuvConversionChrominanceTextureUniform = glGetUniformLocation(rgbToYuvProgram, "chrominanceTexture");
    yuvConversionMatrixUniform = glGetUniformLocation(rgbToYuvProgram, "colorConversionMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(rgbToYuvProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(rgbToYuvProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    glUseProgram(rgbToYuvProgram);
    
    return YES;
}


- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type string:(NSString *)shaderString
{
    GLint status;
    const GLchar *source;
    source = (GLchar *)[shaderString UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

+ (void)dealFrameTime:(void (^)(void))block
{
    glFinish();
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    block();
    
    static int numberOfFramesCaptured = 0;
    static CGFloat totalFrameTimeDuringCapture = 0;
    
    numberOfFramesCaptured++;
    if (numberOfFramesCaptured > 5)
    {
        glFinish();
        CFAbsoluteTime currentFrameTime = (CFAbsoluteTimeGetCurrent() - startTime);
        totalFrameTimeDuringCapture += currentFrameTime;
        
        CGFloat Average = (totalFrameTimeDuringCapture / (CGFloat)(numberOfFramesCaptured - 5)) * 1000.0;
        
        NSLog(@"Average frame time : %f ms", Average);
        NSLog(@"Current frame time : %f ms", 1000.0 * currentFrameTime);
    }
}

//+ (void)onCameraChange
//{
////    fuOnCameraChange();
//}
//
//+ (void)OnDeviceLost;
//{
//    [self setUpCurrentContext];
//
////    fuOnDeviceLost();
//
//    [self setBackCurrentContext];
//}



@end
