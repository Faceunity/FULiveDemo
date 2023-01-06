//
//  FUProgressHUD.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/10/21.
//

#import "FUProgressHUD.h"

@interface FUProgressHUD ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UILabel *progressLabel;

@end

@implementation FUProgressHUD

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.backgroundLayer];
        [self.layer addSublayer:self.progressLayer];
        
        [self addSubview:self.progressLabel];
        self.progressLabel.center = self.center;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    self.progressLayer.strokeEnd = progress;
    
    NSInteger temp = (NSInteger)(progress * 100);
    self.progressLabel.text = [NSString stringWithFormat:@"%ld%%", (long)temp];
}

- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:CGRectGetWidth(self.frame) / 2.f startAngle:-M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
        _backgroundLayer.strokeColor = FUColorFromHex(0x111226).CGColor;
        _backgroundLayer.lineWidth = 4.f;
        _backgroundLayer.strokeEnd = 1.f;
        _backgroundLayer.path = smoothedPath.CGPath;
    }
    return _backgroundLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:CGRectGetWidth(self.frame) / 2.f startAngle:-M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = FUColorFromHex(0x5EC7FE).CGColor;
        _progressLayer.lineWidth = 4.f;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineJoin = kCALineJoinBevel;
        _progressLayer.strokeEnd = 0.f;
        _progressLayer.path = smoothedPath.CGPath;
    }
    return _progressLayer;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.text = [NSString stringWithFormat:@"0%%"];
    }
    return _progressLabel;
}

@end
