//
//  FUSlider.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUAvatarSlider.h"

@interface FUAvatarSlider()
/* 提示文字 */
@property (nonatomic,strong) UILabel *mIndicateLabel;
@property (nonatomic,strong) UIView *middleView;
@property (nonatomic,strong) UIView *line;
//刻度背景
@property (nonatomic,strong) UIImageView *bgImageView;
@end

@implementation FUAvatarSlider
#pragma  mark ----  懒加载  -----
-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(2, self.frame.size.height /2.0 - 2, 100, 4)];
        _middleView.backgroundColor = [UIColor colorWithRed:32/255.0 green:160/255.0 blue:255/255.0 alpha:1.0];
      
    }
    return _middleView;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor whiteColor];
        _line.layer.masksToBounds = YES ;
        _line.layer.cornerRadius = 1.0 ;
        _line.frame = CGRectMake(self.frame.size.width / 2.0 - 1.0, 8.0, 2.0, self.frame.size.height - 16) ;
    }
    return _line;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"airbubbles"]];
        _bgImageView.alpha = 0;
    }
    return _bgImageView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.maximumTrackTintColor = [UIColor whiteColor];
    self.minimumTrackTintColor = [UIColor redColor];
    [self setThumbImage:[UIImage imageNamed:@"figure-slider-dot"] forState:UIControlStateNormal];
//    [self setMaximumTrackImage:[UIImage imageNamed:@"control_Long_strip_nor"] forState:UIControlStateNormal];
//    [self setMinimumTrackImage:[UIImage imageNamed:@"control_Long_strip_sel"] forState:UIControlStateNormal];
    
     self.middleView.hidden = YES;
     self.line.hidden = YES;
    
    [self addSubview:self.bgImageView];
    
    _mIndicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,-self.frame.size.height + 2,50, 20)];
    _mIndicateLabel.textAlignment = NSTextAlignmentCenter;
    _mIndicateLabel.textColor = [UIColor whiteColor];
    _mIndicateLabel.font = [UIFont systemFontOfSize:11];
    _mIndicateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_mIndicateLabel];
    
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupSubView];
    }
    
    return self;
}


-(void)setupSubView{
    self.maximumTrackTintColor = [UIColor whiteColor];
    self.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [self setThumbImage:[UIImage imageNamed:@"figure-slider-dot"] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[UIImage imageNamed:@"control_Long_strip_nor"] forState:UIControlStateNormal];
    [self setMinimumTrackImage:[UIImage imageNamed:@"control_Long_strip_sel"] forState:UIControlStateNormal];
    
    self.middleView.hidden = YES;
    self.line.hidden = YES;
    
    [self addSubview:self.bgImageView];
    
    _mIndicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,-self.frame.size.height + 2,50, 20)];
    _mIndicateLabel.textAlignment = NSTextAlignmentCenter;
    _mIndicateLabel.textColor = [UIColor whiteColor];
    _mIndicateLabel.font = [UIFont systemFontOfSize:11];
    _mIndicateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_mIndicateLabel];
    
    
}

-(void)setType:(FUAvatarSliderType)type {
    _type = type ;
    if (_type == FUSliderCellType101) {
        self.line.hidden = NO ;
        self.middleView.hidden = NO ;
//        [self setMinimumTrackTintColor:[UIColor whiteColor]];
        [self setMinimumTrackImage:[UIImage imageNamed:@"control_Long_strip_nor"] forState:UIControlStateNormal];
    }else{
        self.line.hidden = YES ;
        self.middleView.hidden = YES ;
        [self setMinimumTrackImage:[UIImage imageNamed:@"control_Long_strip_sel"] forState:UIControlStateNormal];
        [self setMinimumTrackTintColor:[UIColor colorWithRed:32/255.0 green:160/255.0 blue:255/255.0 alpha:1.0]];
    }
}


// 后设置 value
- (void)setValue:(float)value animated:(BOOL)animated   {
    [super setValue:value animated:animated];
    
    if (_type == FUSliderCellType101) {
        CGFloat currentValue = value - 0.5;
        CGFloat width = currentValue * (self.frame.size.width - 4);
        if (width < 0 ) {
            width = -width ;
        }
        CGFloat X = currentValue > 0 ? self.frame.size.width / 2.0 : self.frame.size.width / 2.0 - width ;
        CGRect frame = _middleView.frame ;
        frame = CGRectMake(X, frame.origin.y, width, frame.size.height) ;
        _middleView.frame = frame ;
        
        _mIndicateLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100 * 2) - 100];
        CGFloat x = value * (self.frame.size.width - 20) - _mIndicateLabel.frame.size.width * 0.5 + 10;
        CGRect frame1 = _mIndicateLabel.frame;
        frame1.origin.x = x;
        frame1.origin.y  = -40;
     //   _mIndicateLabel.hidden = !self.tracking;
        
        
        CGRect frame2 = self.bgImageView.frame;
        frame2.origin.x = frame1.origin.x + 8;
        frame2.origin.y = frame1.origin.y - 8;
        self.bgImageView.frame = frame2;
        _mIndicateLabel.frame = frame1;
        if (self.tracking ) {
            if (self.mIndicateLabel.hidden) {
                 [self startAnimation];
            }
           
        }else{
            if (!self.mIndicateLabel.hidden) {
                [self stopAnimation];
            }
        }
    }else{
        _mIndicateLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
        CGFloat x = value * (self.frame.size.width - 20) - _mIndicateLabel.frame.size.width * 0.5 + 10;
        CGRect frame = _mIndicateLabel.frame;
        frame.origin.x = x;
        frame.origin.y  = -40;
    //    _mIndicateLabel.hidden = !self.tracking;
        _mIndicateLabel.frame = frame;
        
        CGRect frame2 = self.bgImageView.frame;
        frame2.origin.x = frame.origin.x + 8;
        frame2.origin.y = frame.origin.y - 8;
        self.bgImageView.frame = frame2;
        _mIndicateLabel.frame = frame;
        if (self.tracking) {
            if (self.mIndicateLabel.hidden) {
                [self startAnimation];
            }
            
        }else{
            if (!self.mIndicateLabel.hidden) {
                [self stopAnimation];
            }
        }
        
    }
    
}


-(void)startAnimation{

    self.bgImageView.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.bgImageView.layer.affineTransform = CGAffineTransformMakeScale(0.9, 0.9);
        self.bgImageView.alpha = 1;
        self.mIndicateLabel.hidden = NO;
    } completion:^(BOOL finished) {
    
    }];
    
}




-(void)stopAnimation{

    self.bgImageView.alpha = 0;
    self.mIndicateLabel.hidden = YES;

}


-(void)layoutSubviews {
    [super layoutSubviews];
    _line.frame = CGRectMake(self.frame.size.width / 2.0 - 1.0, 8.0, 2.0, self.frame.size.height - 16);
    [self insertSubview:_middleView atIndex: self.subviews.count - 2];
    [self insertSubview:_line atIndex:self.subviews.count - 2];
    CGFloat value = self.value ;
    [self setValue:value animated:NO];
}

@end
