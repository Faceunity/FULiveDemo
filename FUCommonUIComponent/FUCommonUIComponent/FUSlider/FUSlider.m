//
//  FUSlider.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUSlider.h"
#import "FUCommonUIDefine.h"

@interface FUSlider ()

/// 当前值提示标签
@property (nonatomic, strong) UILabel *tipLabel;
/// 当前值提示标签背景
@property (nonatomic, strong) UIImageView *tipBackgroundImageView;
/// 零点在中间时自定义视图
@property (nonatomic, strong) UIView *trackView;
/// 零点在中间时的中间短线
@property (nonatomic, strong) UIView *middleLine;

@end

@implementation FUSlider

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    [self setThumbImage:FUCommonUIImageNamed(@"slider_dot") forState:UIControlStateNormal];
    [self setMaximumTrackTintColor:[UIColor whiteColor]];
    [self setMinimumTrackTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1]];
    [self addSubview:self.tipBackgroundImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.trackView];
    [self addSubview:self.middleLine];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.middleLine.frame = CGRectMake(CGRectGetWidth(self.bounds)/2.0 - 1, CGRectGetHeight(self.bounds)/2.0 - 4, 2, 8);
    [self setValue:self.value animated:NO];
}

- (void)setBidirection:(BOOL)bidirection {
    _bidirection = bidirection;
    if (bidirection) {
        self.middleLine.hidden = NO ;
        self.trackView.hidden = NO ;
        [self setMinimumTrackTintColor:[UIColor whiteColor]];
    } else {
        self.middleLine.hidden = YES ;
        self.trackView.hidden = YES ;
        [self setMinimumTrackTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1]];
    }
}

- (void)setValue:(float)value animated:(BOOL)animated   {
    [super setValue:value animated:animated];
    
    if (_bidirection) {
        self.tipLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100 - 50)];
        CGFloat currentValue = value - 0.5 ;
        CGFloat width = currentValue * CGRectGetWidth(self.bounds);
        if (width < 0 ) {
            width = -width ;
        }
        CGFloat originX = currentValue > 0 ? CGRectGetWidth(self.bounds) / 2.0 : CGRectGetWidth(self.bounds) / 2.0 - width ;
        self.trackView.frame = CGRectMake(originX, CGRectGetHeight(self.frame)/2.0 - 2, width, 4.0);
    } else {
        self.tipLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
    }
    
    CGFloat x = value * (self.frame.size.width - 20) - self.tipLabel.frame.size.width * 0.5 + 10;
    CGRect frame = self.tipLabel.frame;
    frame.origin.x = x;
    
    self.tipBackgroundImageView.frame = frame;
    self.tipLabel.frame = frame;
    self.tipLabel.hidden = !self.tracking;
    self.tipBackgroundImageView.hidden = !self.tracking;
}


#pragma mark - Getters

- (UIImageView *)tipBackgroundImageView {
    if (!_tipBackgroundImageView) {
        UIImage *bgImage = FUCommonUIImageNamed(@"slider_tip_background");
        _tipBackgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
        _tipBackgroundImageView.frame = CGRectMake(0, -bgImage.size.height, bgImage.size.width, bgImage.size.height);
        _tipBackgroundImageView.hidden = YES;
    }
    return _tipBackgroundImageView;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:self.tipBackgroundImageView.frame];
        _tipLabel.text = @"";
        _tipLabel.textColor = [UIColor darkGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (UIView *)trackView {
    if (!_trackView) {
        _trackView = [[UIView alloc] init];
        _trackView.backgroundColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1];
        _trackView.hidden = YES;
    }
    return _trackView;
}

- (UIView *)middleLine {
    if (!_middleLine) {
        _middleLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2.0 - 1, CGRectGetHeight(self.bounds)/2.0 - 4, 2, 8)];
        _middleLine.backgroundColor = [UIColor whiteColor];
        _middleLine.layer.masksToBounds = YES ;
        _middleLine.layer.cornerRadius = 1.0 ;
        _middleLine.hidden = YES;
    }
    return _middleLine;
}

@end
