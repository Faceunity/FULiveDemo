//
//  FUHomepageHeaderView.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUHomepageHeaderView.h"

@implementation FUHomepageHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        int h = frame.size.height;
        int y = (h - 13)/2;
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(20,y,4,13);

        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(20,y,4,13);
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:246/255.0 green:97/255.0 blue:255/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:119/255.0 green:85/255.0 blue:252/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        gl.cornerRadius = 2;
        [self.layer addSublayer:gl];
        view.layer.cornerRadius = 2;
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+4+8, (h -32)/2, 150, 32)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

@end
