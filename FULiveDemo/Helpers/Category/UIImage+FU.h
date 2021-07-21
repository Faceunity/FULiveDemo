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
/// @param ratio 倍率
- (UIImage *)fu_compress:(CGFloat)ratio;

@end

NS_ASSUME_NONNULL_END
