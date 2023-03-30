//
//  FUFaceFusionTipView.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/5.
//

#import "FUFaceFusionTipView.h"

@interface FUFaceFusionTipView ()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UIButton *tipButton;

@end

@implementation FUFaceFusionTipView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    [self addSubview:self.tipButton];
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_offset(45);
    }];
    
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipButton.mas_top).mas_offset(-30);
        make.leading.equalTo(self.mas_leading).mas_offset(10);
        make.trailing.equalTo(self.mas_trailing).mas_offset(-10);
    }];
    
    [self addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(40);
        make.centerX.equalTo(self);
    }];
}

- (void)tipAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceFusionTipViewDidClickComfirm)]) {
        [self.delegate faceFusionTipViewDidClickComfirm];
    }
}

#pragma mark - Getters

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_fusion_no_tracked"]];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _tipLabel.textColor = FUColorFromHex(0x31373E);
        _tipLabel.numberOfLines = 2;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipButton.frame = CGRectMake(0, 0, 245, 45);
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0, 0, 245, 45);
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:125/255.0 green:33/255.0 blue:158/255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:122/255.0 green:28/255.0 blue:142/255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:104/255.0 green:46/255.0 blue:184/255.0 alpha:1.0].CGColor
        ];
        gl.locations = @[@(0.0), @(0.0), @(0.0), @(1.0f)];
        [_tipButton.layer addSublayer:gl];
        [_tipButton setTitle:FULocalizedString(@"知道了") forState:UIControlStateNormal];
        [_tipButton addTarget:self action:@selector(tipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}

@end
