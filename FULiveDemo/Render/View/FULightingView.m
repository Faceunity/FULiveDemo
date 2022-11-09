//
//  FULightingView.m
//  FULiveDemo
//
//  Created by L on 2018/9/20.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FULightingView.h"

@interface FULightingView()
@property (strong, nonatomic) UIImageView *sunImage;
@property (strong, nonatomic) UIImageView *monImage;
@end

@implementation FULightingView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

-(void)setupSubView{
    self.monImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"render_lighting_mon"]];
    self.monImage.frame = CGRectMake(10, 0, 20, 20);
    [self addSubview:self.monImage];
    self.sunImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"render_lighting_sun"]];
    self.sunImage.frame = CGRectMake(self.frame.size.width - 30, 0, 20, 20);
    [self addSubview:self.sunImage];
    
    self.slider = [[FULightingSlider alloc] initWithFrame:CGRectMake(40, 0, self.frame.size.width - 80, 20)];
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.slider];
    
    self.monImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.sunImage.transform = CGAffineTransformMakeRotation(M_PI_2);
}


-(void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubView];

}

-(void)sliderValueChange:(FULightingSlider *)sender {
    float value = sender.value;
    if ([self.delegate respondsToSelector:@selector(lightingViewValueDidChange:)]) {
        [self.delegate lightingViewValueDidChange:value];
    }
}


@end
