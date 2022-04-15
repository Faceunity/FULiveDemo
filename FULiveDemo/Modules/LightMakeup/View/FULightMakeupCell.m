//
//  FULightMakeupCell.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/29.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FULightMakeupCell.h"

@interface FULightMakeupCell ()

@property (nonatomic, strong) UIImageView *fuImageView;
@property (nonatomic, strong) UILabel *fuTitleLabel;

@end

@implementation FULightMakeupCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.fuImageView];
        [self.contentView addSubview:self.fuTitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.fuImageView.layer.borderWidth = selected ? 3 : 0;
    self.fuImageView.layer.borderColor = selected ? [UIColor colorWithRed:94/255.f green:199/255.f blue:254/255.f alpha:1].CGColor : [UIColor clearColor].CGColor;
    self.fuTitleLabel.textColor = selected ? [UIColor colorWithRed:94/255.f green:199/255.f blue:254/255.f alpha:1] : [UIColor whiteColor];
}

#pragma mark - Getters

- (UIImageView *)fuImageView {
    if (!_fuImageView) {
        _fuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        _fuImageView.layer.masksToBounds = YES;
        _fuImageView.layer.cornerRadius = 3;
    }
    return _fuImageView;
}

- (UILabel *)fuTitleLabel {
    if (!_fuTitleLabel) {
        _fuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 11, CGRectGetWidth(self.frame), 11)];
        _fuTitleLabel.font = [UIFont systemFontOfSize:10];
        _fuTitleLabel.textColor = [UIColor whiteColor];
        _fuTitleLabel.textAlignment = NSTextAlignmentCenter;
        _fuTitleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fuTitleLabel;
}

@end
