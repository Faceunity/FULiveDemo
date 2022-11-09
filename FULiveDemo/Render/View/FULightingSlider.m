//
//  FULightingSlider.m
//  FULiveDemo
//
//  Created by L on 2018/9/20.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FULightingSlider.h"

@implementation FULightingSlider
{
    UIView *line;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setThumbImage:[UIImage imageNamed:@"render_lighting"] forState:UIControlStateNormal];
        [self setMaximumTrackTintColor:[UIColor whiteColor]];
        [self setMinimumTrackTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)awakeFromNib    {
    [super awakeFromNib];
    [self setThumbImage:[UIImage imageNamed:@"render_lighting"] forState:UIControlStateNormal];
    [self setMaximumTrackTintColor:[UIColor whiteColor]];
    [self setMinimumTrackTintColor:[UIColor whiteColor]];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if (!line) {
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor whiteColor];
        line.layer.masksToBounds = YES;
        line.layer.cornerRadius = 1.0;
        [self insertSubview:line atIndex: self.subviews.count - 1];
    }
    line.frame = CGRectMake(self.frame.size.width / 2.0 - 1.0, 4.0, 2.0, self.frame.size.height - 8.0);
    
    CGFloat value = self.value;
    [self setValue:value animated:NO];
}


- (void)setValue:(float)value animated:(BOOL)animated   {
    [super setValue:value animated:animated];
}

@end
