//
//  FUTipHUD.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/4/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUTipHUD.h"
#import "FUInsetsLabel.h"

@implementation FUTipHUD

+ (void)showTips:(NSString *)tipsString {
    [self showTips:tipsString dismissWithDelay:3];
}

+ (void)showTips:(NSString *)tipsString dismissWithDelay:(NSTimeInterval)delay {
    [self showTips:tipsString dismissWithDelay:delay position:FUTipHUDPositionTop];
}

+ (void)showTips:(NSString *)tipsString dismissWithDelay:(NSTimeInterval)delay position:(FUTipHUDPosition)position {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }
    // 避免重复生成label
    NSArray<UIView *> *views = window.subviews;
    [views enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[FUInsetsLabel class]]) {
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
    
    __block FUInsetsLabel *tipLabel = [[FUInsetsLabel alloc] initWithFrame:CGRectZero insets:UIEdgeInsetsMake(8, 20, 8, 20)];
    tipLabel.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.numberOfLines = 0;
    tipLabel.layer.masksToBounds = YES;
    tipLabel.layer.cornerRadius = 4;
    tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tipLabel.text = tipsString;
    [window addSubview:tipLabel];
    
    if (position == FUTipHUDPositionTop) {
        CGFloat topConstant = 0;
        if (@available(iOS 11.0, *)) {
            topConstant = window.safeAreaInsets.top;
        }
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:tipLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeTop multiplier:1 constant:84 + topConstant];
        [window addConstraint:topConstraint];
    } else {
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:tipLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [window addConstraint:centerYConstraint];
    }
    CGFloat windowWidth = CGRectGetWidth(window.bounds);
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:tipLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:windowWidth - 40];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:tipLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [window addConstraint:centerXConstraint];
    [tipLabel addConstraint:widthConstraint];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [tipLabel removeFromSuperview];
            tipLabel = nil;
        }];
    });
}

@end

