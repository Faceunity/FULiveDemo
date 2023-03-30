//
//  FUExportVideoView.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/10/21.
//

#import "FUExportVideoView.h"
#import "FUProgressHUD.h"

@interface FUExportVideoView ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) FUProgressHUD *progressHUD;

@end

@implementation FUExportVideoView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self configureUI];
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    UILabel *label = [[UILabel alloc] init];
    label.text = FULocalizedString(@"exporting_video_tips");
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(20);
        make.trailing.equalTo(self.mas_trailing).mas_offset(-20);
        make.centerY.equalTo(self.mas_centerY).mas_offset(-3);
    }];
    
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(label.mas_bottom).mas_offset(30);
        make.size.mas_offset(CGSizeMake(84, 28));
    }];
    
    [self addSubview:self.progressHUD];
    [self.progressHUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.mas_top).mas_offset(-26);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(66, 66));
    }];
}

#pragma mark - Instance methods

- (void)setExportProgress:(CGFloat)progress {
    [self.progressHUD setProgress:progress];
}

#pragma mark - Event response

- (void)cancelAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(exportVideoViewDidClickCancel)]) {
        [self.delegate exportVideoViewDidClickCancel];
    }
}

#pragma mark - Getters

- (FUProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[FUProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
    }
    return _progressHUD;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 84, 28);
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 14.f;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_cancelButton setTitle:FULocalizedString(@"取消") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
