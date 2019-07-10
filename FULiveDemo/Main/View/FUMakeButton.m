//
//  FUMakeButton.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/6/20.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUMakeButton.h"

@implementation FUMakeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置按钮颜色
        // self.selected = NO;
        //        [self setTitleColor:[FUDresserstyle colorForTitle] forState:UIControlStateNormal];
        //        // self.selected = YES;
        //        [self setTitleColor:[FUDresserstyle colorForTitle_sel] forState:UIControlStateSelected];
        //        [self setTitleColor:[FUDresserstyle colorForTitle_sel] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置按钮颜色
        // self.selected = NO;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        // self.selected = YES;
        //        [self setTitleColor:[FUDresserstyle colorForTitle_sel] forState:UIControlStateSelected];
        //        [self setTitleColor:FUColor_HEX(0x808182)  forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame =  self.imageView.bounds;
    CGRect frame1 =  self.titleLabel.frame;
    
    
    self.imageView.frame = frame;
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width  * 0.5;
    //  center.y = self.center.y - frame.size.height/2 - 5;
    self.imageView.center = center;
    
    
    frame1.origin.x = 0;
    frame1.origin.y = CGRectGetMaxY(self.imageView.frame) + 5;
    frame1.size.height = 11;
    frame1.size.width = self.bounds.size.width;;
    self.titleLabel.frame = frame1;
    
}

@end
