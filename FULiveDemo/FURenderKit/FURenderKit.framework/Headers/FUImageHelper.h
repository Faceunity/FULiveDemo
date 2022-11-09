//
//  FUImageHelper.h
//  FULiveDemo
//
//  Created by L on 2018/8/3.
//  Copyright © 2018年 L. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface FUImageHelper : NSObject

+ (void)convertUIImageToBitmapRGBA8:(UIImage *)image completionHandler:(void (^)(int32_t size, unsigned char * bits))completionHandler;

+ (UIImage *)convertBitmapRGBA8ToUIImage:(unsigned char *)buffer
                                withWidth:(int)width
                               withHeight:(int)height;

/// 根据UIImage返回CVPixelBufferRef
/// @param image UIImage实例对象
/// 注意：CVPixelBufferRef需要手动release
+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image;

/// 根据CVPixelBufferRef返回UIImage
/// @param pixelBufferRef buffer
/// 注意：如果后续业务有使用到image.CGImage，则需要及时释放掉 image.CGImage
+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef;

+ (unsigned char *)getRGBAWithImage:(UIImage *)image;

+ (unsigned char *)getRGBAWithImageName:(NSString *)imageName width:(int *)width height:(int *)height;

/// 截屏处理取色
+ (UIColor*)getPixelColorScreenWindowAtLocation:(CGPoint)point;

/// 针对静态图片处理取色
+ (UIColor *)getPixelColorWithImage:(UIImage *)image point:(CGPoint)point DEPRECATED_MSG_ATTRIBUTE("use colorInPoint: in FUGLDisplayView instead");

/// 针对每一帧处理取色
+ (UIColor *)getPixelColorWithPixelBuff:(CVPixelBufferRef)pixelBuffer point:(CGPoint)point DEPRECATED_MSG_ATTRIBUTE("use colorInPoint: in FUGLDisplayView instead");

+ (UIImage *)rotateImageWithAngle:(UIImage*)vImg Angle:(NSInteger)vAngle IsExpand:(BOOL)vIsExpand;

/// 获取图像数据
/// @param pixelBuffer buffer
/// @param transform 图像方向(0: up  1: right  2: down  3: left)
/// @return Byte
+ (Byte *)getBytesFromPixelBuffer:(CVPixelBufferRef)pixelBuffer transform:(int)transform;

/// 获取视频第一帧图片
/// @param videoURL 视频URL
+ (UIImage *)getPreviewImageWithVideoURL:(NSURL *)videoURL;

@end
