//
//  FURenderInput.h
//  FURenderKit
//
//  Created by liuyang on 2021/1/4.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CNamaSDK.h"

typedef enum : NSUInteger {
    FUImageBufferFormatRGBA,
    FUImageBufferFormatBGRA,
    FUImageBufferFormatYUV420V,
    FUImageBufferFormatYUV420F,
    FUImageBufferFormatYUVI420,
} FUImageBufferFormat;

typedef enum : NSUInteger {
    FUImageOrientationUP,
    FUImageOrientationRight,
    FUImageOrientationDown,
    FUImageOrientationLeft
} FUImageOrientation;

/// CPU image 数据
struct FUImageBuffer {
    Byte *buffer0;                  // 格式与传入 buffer 类型对应关系：RGBA: rgba_buffer; BGRA: bgra_buffer; YUV420V/YUV420F/YUVI420: y_buffer
    size_t stride0;                 // 格式与传入 stride 类型对应关系：RGBA: rgba_stride; BGRA: bgra_stride; YUV420V/YUV420F/YUVI420: y_stride
    
    Byte *buffer1;                  // 格式与传入 buffer 类型对应关系：RGBA/BGRA: NULL; YUV420V/YUV420F: uv_buffer; YUVI420: u_buffer
    size_t stride1;                 // 格式与传入 stride 类型对应关系：RGBA/BGRA: 0; YUV420V/YUV420F: uv_stride; YUVI420: u_stride
    
    Byte *buffer2;                  // 格式与传入 buffer 类型对应关系：RGBA/BGRA: NULL; YUV420V/YUV420F: NULL; YUVI420: v_buffer
    size_t stride2;                 // 格式与传入 stride 类型对应关系：RGBA/BGRA: 0; YUV420V/YUV420F: 0; YUVI420: v_stride
    
    CGSize size;                    // 图像宽高
    FUImageBufferFormat format;     // 图像格式
    
};
typedef struct FUImageBuffer FUImageBuffer;

FUImageBuffer FUImageBufferMakeRGBA(Byte *buffer0, size_t width, size_t height, size_t stride0);
FUImageBuffer FUImageBufferMakeBGRA(Byte *buffer0, size_t width, size_t height, size_t stride0);
FUImageBuffer FUImageBufferMakeYUV420F(Byte *buffer0, Byte *buffer1, size_t width, size_t height, size_t stride0, size_t stride1);
FUImageBuffer FUImageBufferMakeYUV420V(Byte *buffer0, Byte *buffer1, size_t width, size_t height, size_t stride0, size_t stride1);
FUImageBuffer FUImageBufferMakeI420(Byte *buffer0, Byte *buffer1, Byte *buffer2, size_t width, size_t height, size_t stride0, size_t stride1, size_t stride2);
FUImageBuffer FUImageBufferMake(Byte *buffer0, Byte *buffer1, Byte *buffer2, size_t width, size_t height, size_t stride0, size_t stride1, size_t stride2, FUImageBufferFormat format);


/// 纹理数据
struct FUTexture {
    GLuint ID;                      // 纹理ID
    CGSize size;                    // 纹理宽高
};
typedef struct FUTexture FUTexture;

#pragma -mark FURenderConfig
@interface FURenderConfig : NSObject

/// 自定义输出结果的大小，当前只会对输出的纹理及pixelBuffer有效
@property (nonatomic, assign) CGSize customOutputSize;

/// 当前图片是否来源于前置摄像头，默认为 NO
@property (nonatomic, assign) BOOL isFromFrontCamera;

/// 当前图片是否来源于镜像摄像头，默认为 NO
@property (nonatomic, assign) BOOL isFromMirroredCamera;

/// 原始图像的朝向
@property (nonatomic, assign) FUImageOrientation imageOrientation;

/// 贴纸水平镜像
@property (nonatomic, assign) BOOL stickerFlipH;

/// 重力开关，开启此功能可以根据已设置的 imageRotation 自动适配AI检测的方向。
@property (nonatomic, assign) BOOL gravityEnable;

/// 设置为YES 只会生效美颜结果
@property (nonatomic, assign) BOOL onlyRenderBeauty;

/// 设置输入pixelBuffer/imageBuffer的旋转方向，以使buffer数据与textureTransform作用后纹理的方向一致，该参数仅用于AI算法检测，不会改变buffer的方向或镜像属性
@property (nonatomic, assign) TRANSFORM_MATRIX bufferTransform;

/// 设置输入纹理的旋转及镜像信息，设置该属性会影响输出纹理的方向。默认基于 CPU 图像创建的纹理与CPU 图像成上下镜像关系，此时 textureTransform 对应的值为 DEFAULT，以此类推，如果对默认生成的纹理做了其他变换，则将该参数设置为对应的变换即可。
@property (nonatomic, assign) TRANSFORM_MATRIX textureTransform;

/// 设置输入pixelBuffer/imageBuffer的旋转方向，以使buffer数据与textureTransform作用后纹理的方向一致，该参数仅用于AI算法检测，不会改变buffer的方向或镜像属性
@property (nonatomic, assign) TRANSFORM_MATRIX outputTransform;

/// 是否渲染到当前的FBO，设置为YES时，返回的 FURenderOutput 内的所有数据均为空值。
@property (nonatomic, assign) BOOL renderToCurrentFBO;

//是否读回到输入的buffer
@property (nonatomic, assign) BOOL readBackToPixelBuffer;

/// 设置为YES 且 renderToCurrentFBO 为 NO 时，只会输出纹理，不会输出CPU层的图像。
@property (nonatomic, assign) BOOL onlyOutputTexture;

/// 控制输出图像是否保留透明信息，默认值为NO，可能会输出不透明的图像，开启该参数可以保持图像中透明信息。
@property (nonatomic, assign) BOOL keepAlpha;

@end

#pragma -mark FURenderInput
@interface FURenderInput : NSObject

/// 输入的纹理
@property (nonatomic, assign) FUTexture texture;

/// 输入的 pixelBuffer
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

/// 输入的 imageBuffer，如果同时传入了 pixelBuffer，将优先使用 pixelBuffer
/// 输入 imageBuffer，在 renderConfig 的 onlyOutputTexture 为 NO 时，render 结果会直接读会输入的 imageBuffer，大小格式与输入均保持一致。
@property (nonatomic, assign) FUImageBuffer imageBuffer;

/// 设置render相关的输入输出配置，详细参数请查看 FURenderConfig 类的接口注释。
@property (nonatomic, strong, readonly) FURenderConfig *renderConfig;

@end


#pragma -mark FURenderOutput
@interface FURenderOutput : NSObject

/// 输出的纹理
@property (nonatomic, assign) FUTexture texture;

/// 输出的 pixelBuffer
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

/// 输出的 imageBuffer，内部数据与输入的 imageBuffer 一致。
@property (nonatomic, assign) FUImageBuffer imageBuffer;

@end

