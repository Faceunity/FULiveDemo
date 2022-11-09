//
//  FUHairBeautyView.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/5.
//

#import "FUHairBeautyView.h"

@interface FUHairBeautyView ()

@property (nonatomic, strong) FUSlider *slider;

@end

@implementation FUHairBeautyView

- (instancetype)initWithFrame:(CGRect)frame topSpacing:(CGFloat)topSpacing {
    self = [super initWithFrame:frame topSpacing:topSpacing];
    if (self) {
        [self addSubview:self.slider];
    }
    return self;
}

- (void)sliderValueChanged {
    if (self.hairDelegate && [self.hairDelegate respondsToSelector:@selector(hairBeautyViewChangedStrength:)]) {
        [self.hairDelegate hairBeautyViewChangedStrength:self.slider.value];
    }
}

- (FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectMake(52, 10, CGRectGetWidth(self.frame) - 104, 30)];
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

@end
