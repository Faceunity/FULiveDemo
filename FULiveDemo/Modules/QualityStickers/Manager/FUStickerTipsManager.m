//
//  FUStickerTipsManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/4/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStickerTipsManager.h"
#import "FUMetaManager.h"

#import <Masonry.h>

@implementation FUStickerTipsManager

+ (void)showErrorTips:(NSString *)tipsString {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    // 避免重复生成label
    NSArray<UIView *> *views = window.subviews;
    [views enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[FUInsertsLabel class]]) {
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
    
    __block FUInsertsLabel *tipLabel = [[FUInsertsLabel alloc] initWithFrame:CGRectZero insets:UIEdgeInsetsMake(8, 20, 8, 20)];
    tipLabel.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    tipLabel.text = tipsString;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.layer.masksToBounds = YES;
    tipLabel.layer.cornerRadius = 4;
    
    [window addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(window);
        make.top.equalTo(window.mas_top).mas_offset(iPhoneXStyle ? 156 : 132);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [tipLabel removeFromSuperview];
            tipLabel = nil;
        }];
    });
    
}


@end


@interface FUInsertsLabel ()

@property (nonatomic, assign) UIEdgeInsets insets;

@end

@implementation FUInsertsLabel

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if (self) {
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}


- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width  += self.insets.left + self.insets.right;
    size.height += self.insets.top + self.insets.bottom;
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [super sizeThatFits:size];
    fitSize.width  += self.insets.left + self.insets.right;
    fitSize.height += self.insets.top + self.insets.bottom;
    return fitSize;
}

@end
