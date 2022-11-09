//
//  UIButton+FU.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (FU)

/// 延迟点击方法
/// @param delay 延迟时间
/// @param handler 回调
- (void)addCommonActionWithDelay:(NSTimeInterval)delay actionHandler:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
