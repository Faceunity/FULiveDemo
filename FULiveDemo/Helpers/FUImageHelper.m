//
//  FUImageHelper.m
//  FULiveDemo
//
//  Created by L on 2018/8/3.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUImageHelper.h"
//#import "libyuv.h"

@implementation FUImageHelper

+ (void) convertUIImageToBitmapRGBA8:(UIImage *) image completionHandler:(void (^)(int32_t size, unsigned char * bits))completionHandler {
    
    CGImageRef imageRef = image.CGImage;
    
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self newBitmapRGBA8ContextFromImage:imageRef];
    
    if(!context) {
        return ;
    }
    
    int32_t width = (int32_t)CGImageGetWidth(imageRef);
    int32_t height = (int32_t)CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    
    // Copy the data and release the memory (return memory allocated with new)
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    
    unsigned char *newBitmap = NULL;
    
    union i32c{
        int32_t i32v;
        unsigned char bytes[4];
    };
    
    union i32c cwidth;
    cwidth.i32v = width;
    union i32c cheight;
    cheight.i32v = height;
    if(bitmapData) {
        newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height + 8);
        newBitmap[0] =cwidth.bytes[0];
        newBitmap[1] =cwidth.bytes[1];
        newBitmap[2] =cwidth.bytes[2];
        newBitmap[3] =cwidth.bytes[3];
        newBitmap[4]=cheight.bytes[0];
        newBitmap[5] =cheight.bytes[1];
        newBitmap[6] =cheight.bytes[2];
        newBitmap[7] =cheight.bytes[3];
        
        if(newBitmap) {    // Copy the data
            for(int i = 8; i < bufferLength+8; ++i) {
                newBitmap[i] = bitmapData[i - 8];
            }
        }
        
        free(bitmapData);
        
    } else {
        NSLog(@"Error getting bitmap pixel data\n");
    }
    
    CGContextRelease(context);
    
    completionHandler((size_t)bufferLength +8,newBitmap);
}

+ (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast);    // RGBA
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}


+ (unsigned char *)getRGBAWithImage:(UIImage *)image
{
    int RGBA = 4;
    
    CGImageRef imageRef = [image CGImage];
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *) malloc(width * height * sizeof(unsigned char) * RGBA);
    NSUInteger bytesPerPixel = RGBA;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return rawData;
}


+ (unsigned char *)getRGBAWithImageName:(NSString *)imageName width:(int *)width height:(int *)height{
    //获取图片文件路径
    NSString * path = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    NSURL * url = [NSURL fileURLWithPath:path];
    CGImageRef imageRef = NULL;
    CGImageSourceRef myImageSource;
    //通过文件路径创建CGImageSource对象
    myImageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    //获取第一张图片
    imageRef = CGImageSourceCreateImageAtIndex(myImageSource,
                                              0,
                                              NULL);
    
    size_t width0 = CGImageGetWidth(imageRef);
    size_t height0 = CGImageGetHeight(imageRef);
    *width = (int)width0;
    *height = (int)height0;
    
    int RGBA = 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *) malloc(width0 * height0 * sizeof(unsigned char) * RGBA);
    memset(rawData, 0, width0 * height0 * sizeof(unsigned char) * RGBA);
    NSUInteger bytesPerPixel = RGBA;
    NSUInteger bytesPerRow = bytesPerPixel * width0;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width0, height0, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width0, height0), imageRef);
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CFRelease(myImageSource);
    return rawData;
    
}

+ (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(buffer,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}


+(CVPixelBufferRef) pixelBufferFromImage:(UIImage *)image {
    
    NSDictionary *options = @{
                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
                              };
    
    CVPixelBufferRef pxbuffer = NULL;
    CGFloat frameWidth = CGImageGetWidth(image.CGImage);
    CGFloat frameHeight = CGImageGetHeight(image.CGImage);
    CVReturn status = CVPixelBufferCreate(
                                          kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(
                                                 pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
    NSParameterAssert(context);
    
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    
    CGContextDrawImage(context, CGRectMake(0, 0, frameWidth, frameHeight), image.CGImage);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    //    CFRelease(rgbColorSpace) ;
    
    return pxbuffer;
}

+(UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
    
    float width = CVPixelBufferGetWidth(pixelBufferRef);
    float height = CVPixelBufferGetHeight(pixelBufferRef);
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 width,
                                                 height)];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    
    return image;
}


+ (UIImage *)imageFromPixelBuffer2:(CVPixelBufferRef)pixelBufferRef {
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
     
    float width = CVPixelBufferGetWidth(pixelBufferRef);
    float height = CVPixelBufferGetHeight(pixelBufferRef);
     CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
     
     CIContext *temporaryContext = [CIContext contextWithOptions:nil];
     CGImageRef videoImage = [temporaryContext
                              createCGImage:ciImage
                              fromRect:CGRectMake(0, 0,
                                                  width,
                                                  height)];
     
     UIImage *image = [UIImage imageWithCGImage:videoImage];
     CGImageRelease(videoImage);
     CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
     
     return image;
}


/**
获取屏幕截图
@return 返回屏幕截图
*/
 
//+(UIImage *)fullScreenshots{
//    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
//    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
//    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    return viewImage;
//}

+ (UIImage *)fullScreenshots
{
    CGSize imageSize = CGSizeZero;

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
获取点击的颜色
@param point 点击的位置
@return 返回点击地方的颜色
*/
+(UIColor*)getPixelColorScreenWindowAtLocation:(CGPoint)point{
    UIColor* color = nil;
    UIImage *image = [self fullScreenshots];
    CGImageRef inImage = image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    CGFloat scale = [UIScreen mainScreen].scale;
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y * scale))+round(point.x * scale));
            int alpha =  (int)data[offset];
            int red = (int)data[offset+1];
            int green = (int)data[offset+2];
            int blue = (int)data[offset+3];
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
            
            free(data);
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
        

    }
    
    
    return color;
}
 
+(CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int            bitmapByteCount;
    int            bitmapBytesPerRow;
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow  = (pixelsWide * 4);
    bitmapByteCount    = (bitmapBytesPerRow * pixelsHigh);
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color spacen");
        return NULL;
    }
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,      // bits per component
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    return context;
}


+ (UIColor *)getPixelColorWithPixelBuff:(CVPixelBufferRef)pixelBuffer point:(CGPoint)point {
    UIColor *color = nil;
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    if (baseAddress) {
        int r, g, b, alpha;
        //判断数据格式
        OSType type = CVPixelBufferGetPixelFormatType(pixelBuffer);
        
        int scale = (int)[UIScreen mainScreen].scale;
        if (type == kCVPixelFormatType_32BGRA) {
            int offset = 4 * (width * round(point.y * scale) + round(point.x * scale));
            //bgra
            b =  (int)baseAddress[offset];
            g = (int)baseAddress[offset+1];
            r = (int)baseAddress[offset+2];
            alpha = (int)baseAddress[offset+3];
        } else {
            alpha = 0xff;
            [self NV12TransformToRGBWithBuffer:pixelBuffer offsetX:point.x * scale offsetY:point.y * scale r:&r g:&g b:&b];
        }
        color = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(alpha/255.0f)];

    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return color;
}


+ (void)NV12TransformToRGBWithBuffer:(CVPixelBufferRef)pixelBuffer offsetX:(int)offsetX offsetY:(int)offsetY r:(int *)r g:(int *)g b:(int *)b {
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    uint8_t *yBuffer = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    size_t yPitch = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0); //y分量步长
    uint8_t *cbCrBuffer = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t cbCrPitch = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);//uv分量步长
    
    
//    for(int y = 0; y < height; y++) {
        uint8_t *yBufferLine = &yBuffer[offsetY * yPitch];
        uint8_t *cbCrBufferLine = &cbCrBuffer[(offsetY >> 1) * cbCrPitch];
        
//        for(int x = 0; x < width; x++) {
        int16_t y = yBufferLine[offsetX];
        int16_t cb = cbCrBufferLine[offsetX & ~1] - 128;
        int16_t cr = cbCrBufferLine[offsetX | 1] - 128;
        
//        uint8_t *rgbOutput = &rgbBufferLine[x*bytesPerPixel];
        
        *r = (int16_t)roundf( y + cr *  1.4 );
        *g = (int16_t)roundf( y + cb * -0.343 + cr * -0.711 );
        *b = (int16_t)roundf( y + cb *  1.765);
        
//        rgbOutput[0] = clamp(b);
//        rgbOutput[1] = clamp(g);
//        rgbOutput[2] = clamp(r);
//        rgbOutput[3] = 0xff;
//        }
//    }
}

//NV12 转 bgra
#define clamp(a) (a>255?255:(a<0?0:a))
+ (CVPixelBufferRef)NV12TransformRGBBuffer:(CVPixelBufferRef)pixelBuffer {
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    uint8_t *yBuffer = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    size_t yPitch = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0); //y分量步长
    uint8_t *cbCrBuffer = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t cbCrPitch = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);//uv分量步长
    
    int bytesPerPixel = 4;
    // 创建一个空的32BGRA格式的CVPixelBufferRef
    NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
    CVPixelBufferRef rgbBuffer = NULL;
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          width,height,kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)pixelAttributes,&rgbBuffer);
    if (result != kCVReturnSuccess) {
        NSLog(@"Unable to create cvpixelbuffer %d", result);
        return NULL;
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    result = CVPixelBufferLockBaseAddress(rgbBuffer, 0);
     if (result != kCVReturnSuccess) {
         CFRelease(rgbBuffer);
         NSLog(@"Failed to lock base address: %d", result);
         return NULL;
     }
     
    CVPixelBufferLockBaseAddress(rgbBuffer, 0);
     // 得到新创建的CVPixelBufferRef中 rgb数据的首地址
    uint8_t *rgbData = (uint8_t*)CVPixelBufferGetBaseAddress(rgbBuffer);

    for(int y = 0; y < height; y++) {
        uint8_t *rgbBufferLine = &rgbData[y * width * bytesPerPixel];
        uint8_t *yBufferLine = &yBuffer[y * yPitch];
        uint8_t *cbCrBufferLine = &cbCrBuffer[(y >> 1) * cbCrPitch];
        
        for(int x = 0; x < width; x++) {
            int16_t y = yBufferLine[x];
            int16_t cb = cbCrBufferLine[x & ~1] - 128;
            int16_t cr = cbCrBufferLine[x | 1] - 128;
            
            uint8_t *rgbOutput = &rgbBufferLine[x*bytesPerPixel];
            
            int16_t r = (int16_t)roundf( y + cr *  1.4 );
            int16_t g = (int16_t)roundf( y + cb * -0.343 + cr * -0.711 );
            int16_t b = (int16_t)roundf( y + cb *  1.765);
            
            rgbOutput[0] = clamp(b);
            rgbOutput[1] = clamp(g);
            rgbOutput[2] = clamp(r);
            rgbOutput[3] = 0xff;
        }
    }
    CVPixelBufferLockBaseAddress(rgbBuffer, 0);
    return rgbBuffer;
}


//+ (void)yuvLibWithPixelBuffer:(CVPixelBufferRef)pixelBuffer point:(CGPoint)point r:(int *)r g:(int *)g b:(int *)b alpha:(int *)alpha {
//    unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
//    size_t width = CVPixelBufferGetWidth(pixelBuffer);
//    size_t height = CVPixelBufferGetHeight(pixelBuffer);
//    int scale = (int)[UIScreen mainScreen].scale;
//
//   //图像宽度（像素）
//   size_t pixelWidth = CVPixelBufferGetWidth(pixelBuffer);
//   //图像高度（像素）
//   size_t pixelHeight = CVPixelBufferGetHeight(pixelBuffer);
//   //获取CVImageBufferRef中的y数据
//   uint8_t *y_frame = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//   //获取CMVImageBufferRef中的uv数据
//   uint8_t *uv_frame =(unsigned char *) CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
//   
//   
//   // 创建一个空的32BGRA格式的CVPixelBufferRef
//   NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
//   CVPixelBufferRef pixelBuffer1 = NULL;
//   CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
//                                         pixelWidth,pixelHeight,kCVPixelFormatType_32BGRA,
//                                         (__bridge CFDictionaryRef)pixelAttributes,&pixelBuffer1);
//   if (result != kCVReturnSuccess) {
//       NSLog(@"Unable to create cvpixelbuffer %d", result);
//       return ;
//   }
//   CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//
//   result = CVPixelBufferLockBaseAddress(pixelBuffer1, 0);
//    if (result != kCVReturnSuccess) {
//        CFRelease(pixelBuffer1);
//        NSLog(@"Failed to lock base address: %d", result);
//        return ;
//    }
//    
//    // 得到新创建的CVPixelBufferRef中 rgb数据的首地址
//    uint8_t *rgb_data = (uint8_t*)CVPixelBufferGetBaseAddress(pixelBuffer1);
//    
//    // 使用libyuv为rgb_data写入数据，将NV12转换为BGRA
//    int ret = NV12ToARGB(y_frame, (int)width, uv_frame, (int)width, rgb_data, (int)width * 4, (int)width, (int)height);
//    if (ret) {
//        NSLog(@"Error converting NV12 VideoFrame to BGRA: %d", result);
//        CFRelease(pixelBuffer1);
//        return ;
//    }
//    baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer1);
//
//    int offset = 4 * (width * round(point.y * scale) + round(point.x * scale));
//    //iOS小端，倒着取BGR
//    *b =  (int)baseAddress[offset];
//    *g = (int)baseAddress[offset+1];
//    *r = (int)baseAddress[offset+2];
//    *alpha = (int)baseAddress[offset+3];
//    CVPixelBufferUnlockBaseAddress(pixelBuffer1, 0);
//    CFRelease(pixelBuffer1);
//}

@end
