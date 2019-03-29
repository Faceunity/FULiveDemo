//
//  FUMakeupSlider.m
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUMakeupSlider.h"

@implementation FUMakeupSlider
{
    UILabel *tipLabel;
    UIImageView *bgImgView;
}

- (void)awakeFromNib    {
    [super awakeFromNib];
    
    [self setThumbImage:[UIImage imageNamed:@"makeup_dot"] forState:UIControlStateNormal];
    
    UIImage *bgImage = [UIImage imageNamed:@"makeup_tipbg"];
    bgImgView = [[UIImageView alloc] initWithImage:bgImage];
    bgImgView.frame = CGRectMake(0, -bgImage.size.height, bgImage.size.width, bgImage.size.height);
    [self addSubview:bgImgView];
    
    tipLabel = [[UILabel alloc] initWithFrame:bgImgView.frame];
    tipLabel.text = @"";
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:tipLabel];
    
    bgImgView.hidden = YES;
    tipLabel.hidden = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setValue:self.value animated:YES];
}


// 后设置 value
- (void)setValue:(float)value animated:(BOOL)animated   {
    [super setValue:value animated:animated];
    
    tipLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
    
    CGFloat x = value * (self.frame.size.width - 20) - tipLabel.frame.size.width * 0.5 + 10;
    CGRect frame = tipLabel.frame;
    frame.origin.x = x;
    
    bgImgView.frame = frame;
    tipLabel.frame = frame;
    tipLabel.hidden = !self.tracking;
    bgImgView.hidden = !self.tracking;
    
}

@end
