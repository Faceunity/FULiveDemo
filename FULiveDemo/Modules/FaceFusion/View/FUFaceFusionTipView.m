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
        make.bottom.equalTo(self.tipButton.mas_top).mas_offset(-12);
        make.centerX.equalTo(self);
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
        _tipLabel.textColor = FUColorFromHex(0x495562);
    }
    return _tipLabel;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipButton.backgroundColor = FUColorFromHex(0x5E2EAA);
        [_tipButton setTitle:FULocalizedString(@"知道了") forState:UIControlStateNormal];
        [_tipButton addTarget:self action:@selector(tipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}

@end
