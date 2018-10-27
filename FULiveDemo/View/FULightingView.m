//
//  FULightingView.m
//  FULiveDemo
//
//  Created by L on 2018/9/20.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FULightingView.h"


@implementation FULightingView
{
    UILabel *tipLabel ;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.monImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.sunImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.monImage.frame.origin.y + self.monImage.frame.size.height + 10, 30, 10)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter ;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:10];
    tipLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self addSubview:tipLabel];
    tipLabel.hidden = YES ;
}

- (IBAction)sliderValueChange:(FULightingSlider *)sender {
    float value = sender.value ;
    tipLabel.text = [NSString stringWithFormat:@"%.1f", value];
    CGFloat x = (value + 4) * (sender.frame.size.width - 20)/8.0 - tipLabel.frame.size.width * 0.5 + 10 + sender.frame.origin.x;
    CGRect frame = tipLabel.frame;
    frame.origin.x = x;
    tipLabel.frame = frame ;
    tipLabel.hidden = !sender.tracking ;
    
    if ([self.delegate respondsToSelector:@selector(lightingViewValueDidChange:)]) {
        [self.delegate lightingViewValueDidChange:value];
    }
}


@end
