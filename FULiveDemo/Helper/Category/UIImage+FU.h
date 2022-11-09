//
//  UIImage+FU.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/6/21.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FU)

/// 压缩图片
/// @param ratio 宽高压缩倍率
- (UIImage *)fu_compress:(CGFloat)ratio;

/// 图片转正
- (UIImage *)fu_resetImageOrientationToUp;

/// 图片处理
- (UIImage *)fu_processedImage;

/// 获取纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
