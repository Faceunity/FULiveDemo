//
//  UIImage+FURenderKit.h
//  FURenderKit
//
//  Created by liuyang on 2021/3/1.
//

#import <UIKit/UIKit.h>
#import "FURenderIO.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FURenderKit)

/// 从 UIImage 中获取 FUImageBuffer，格式为RGBA，需要手动释放 buffer0 或掉用 UIImage 的类方法：freeImageBuffer 释放 FUImageBuffer 内部内存。
- (FUImageBuffer)getImageBuffer;

/// 释放从 UIImage 获取到的 FUImageBuffer 内存，释放内存后 buffer0 会被设置为 null
/// @param imageBuffer  从 UIImage 获取到的 FUImageBuffer 的地址指针
+ (void)freeImageBuffer:(FUImageBuffer *)imageBuffer;

/// 将 FUImageBuffer 转换为图片，如果 FUImageBuffer 是从 UIImage 获取的，可以将 autoFreeBuffer  设置为 YES，内部会自动释放 FUImageBuffer 内存。
/// @param imageBuffer  FUImageBuffer 图像的地址指针
/// @param autoFreeBuffer 是否自动释放 FUImageBuffer
/// 默认alpha 为NO
+ (UIImage *)imageWithRGBAImageBuffer:(FUImageBuffer *)imageBuffer autoFreeBuffer:(BOOL)autoFreeBuffer;


/// 将 FUImageBuffer 转换为图片，如果 FUImageBuffer 是从 UIImage 获取的，可以将 autoFreeBuffer  设置为 YES，内部会自动释放 FUImageBuffer 内存。
/// @param imageBuffer  FUImageBuffer 图像的地址指针
/// @param autoFreeBuffer 是否自动释放 FUImageBuffer
/// @param alpha == YES 透明 NO 不透明
+ (UIImage *)imageWithRGBAImageBuffer:(FUImageBuffer *)imageBuffer autoFreeBuffer:(BOOL)autoFreeBuffer alpha:(BOOL)alpha;
@end

NS_ASSUME_NONNULL_END
