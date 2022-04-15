//
//  FUCustomizedMakeupCell.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUCustomizedMakeupCell.h"

@implementation FUCustomizedMakeupCategoryCell

@synthesize tipView = _tipView, categoryNameLabel = _categoryNameLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.categoryNameLabel];
        [self.categoryNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.tipView];
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView.mas_trailing).mas_offset(-4);
            make.top.equalTo(self.contentView.mas_top).mas_offset(10);
            make.size.mas_offset(CGSizeMake(4, 4));
        }];
    }
    return self;
}

#pragma mark - Override methods

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.categoryNameLabel.textColor = selected ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1] : [UIColor whiteColor];
}

#pragma mark - Getters

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _tipView.backgroundColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1];
        _tipView.layer.masksToBounds = YES;
        _tipView.layer.cornerRadius = 2;
        _tipView.hidden = YES;
    }
    return _tipView;
}

- (UILabel *)categoryNameLabel {
    if (!_categoryNameLabel) {
        _categoryNameLabel = [[UILabel alloc] init];
        _categoryNameLabel.font = [UIFont systemFontOfSize:13];
        _categoryNameLabel.textColor = [UIColor whiteColor];
    }
    return _categoryNameLabel;
}

@end

@implementation FUCustomizedMakeupItemCell

@synthesize fuImageView = _fuImageView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.fuImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.fuImageView.layer.borderWidth = selected ? 3 : 0;
    self.fuImageView.layer.borderColor = selected ? [UIColor colorWithRed:94/255.f green:199/255.f blue:254/255.f alpha:1].CGColor : [UIColor clearColor].CGColor;
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

@end
