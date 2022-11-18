//
//  FUCombinationMakeupView.m
//  FUMakeupComponent
//
//  Created by 项林平 on 2021/11/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUCombinationMakeupView.h"
#import "FUCombinationMakeupViewModel.h"
#import "FUMakeupDefine.h"

#import <FUCommonUIComponent/FUCommonUIComponent.h>

static NSString * const kFUCombinationMakeupCellIdentifierKey = @"FUCombinationMakeupCell";

@interface FUCombinationMakeupView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) FUSlider *slider;
/// 自定义按钮
@property (nonatomic, strong) FUSquareButton *customizeButton;

@property (nonatomic, strong) FUCombinationMakeupViewModel *viewModel;

@end

@implementation FUCombinationMakeupView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUCombinationMakeupViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUCombinationMakeupViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        self.backgroundColor = [UIColor clearColor];
        [self configureUI];
        
        // 默认选中
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.viewModel selectCombinationMakeupAtIndex:self.viewModel.selectedIndex complectionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshSubviews];
                self.collectionView.userInteractionEnabled = YES;
                self.slider.userInteractionEnabled = YES;
                self.customizeButton.userInteractionEnabled = YES;
            });
        }];
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    // 毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:effectView];

    [self addSubview:self.customizeButton];
    NSLayoutConstraint *buttonBottom = [NSLayoutConstraint constraintWithItem:self.customizeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-FUMakeupHeightIncludeBottomSafeArea(18)];
    NSLayoutConstraint *buttonLeading = [NSLayoutConstraint constraintWithItem:self.customizeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:16];
    NSLayoutConstraint *buttonWidth = [NSLayoutConstraint constraintWithItem:self.customizeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:54];
    NSLayoutConstraint *buttonHeight = [NSLayoutConstraint constraintWithItem:self.customizeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:70];
    [self addConstraints:@[buttonBottom, buttonLeading]];
    [self.customizeButton addConstraints:@[buttonWidth, buttonHeight]];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.2];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:line];
    NSLayoutConstraint *lineBottom = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-FUMakeupHeightIncludeBottomSafeArea(33)];
    NSLayoutConstraint *lineLeading = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:85];
    NSLayoutConstraint *lineWidth = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1];
    NSLayoutConstraint *lineHeight = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    [self addConstraints:@[lineBottom, lineLeading]];
    [line addConstraints:@[lineWidth, lineHeight]];

    [self addSubview:self.collectionView];
    NSLayoutConstraint *collectionBottom = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-FUMakeupHeightIncludeBottomSafeArea(4)];
    NSLayoutConstraint *collectionLeading = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:line attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *collectionTrailing = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *collectionHeight = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:98];
    [self addConstraints:@[collectionBottom, collectionLeading, collectionTrailing]];
    [self.collectionView addConstraint:collectionHeight];

    [self addSubview:self.slider];
    NSLayoutConstraint *sliderLeading = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:34];
    NSLayoutConstraint *sliderTrailing = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-34];
    NSLayoutConstraint *sliderBottom = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeTop multiplier:1 constant:-6];
    [self addConstraints:@[sliderLeading, sliderTrailing, sliderBottom]];
}

#pragma mark - Instance methos

- (void)deselectCurrentCombinationMakeup {
    if (self.viewModel.selectedIndex < 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO];
        [self.viewModel selectCombinationMakeupAtIndex:-1 complectionHandler:^{
            [self refreshSubviews];
        }];
    });
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds));
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - Private methods

- (void)refreshSubviews {
    if (self.viewModel.selectedIndex <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 自定义按钮状态
            self.customizeButton.enabled = YES;
            // slider状态
            self.slider.hidden = YES;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 自定义按钮状态
            self.customizeButton.enabled = self.viewModel.isSelectedMakeupAllowedEdit;
            // slider状态
            self.slider.hidden = NO;
            self.slider.value = self.viewModel.selectedMakeupValue;
        });
    }
}

#pragma mark - Event response

- (void)customizeAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(combinationMakeupViewDidClickCustomize)]) {
        [self.delegate combinationMakeupViewDidClickCustomize];
    }
}

- (void)sliderValueChangedAction {
    self.viewModel.selectedMakeupValue = self.slider.value;
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.combinationMakeups.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUCombinationMakeupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCombinationMakeupCellIdentifierKey forIndexPath:indexPath];
    cell.fuImageView.image = [self.viewModel combinationMakeupIconAtIndex:indexPath.item];
    cell.fuTitleLabel.text = [self.viewModel combinationMakeupNameAtIndex:indexPath.item];
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionView.userInteractionEnabled = NO;
    self.slider.userInteractionEnabled = NO;
    self.customizeButton.userInteractionEnabled = NO;
    FUCombinationMakeupCell *selectedCell = (FUCombinationMakeupCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell.indicatorView startAnimating];
    [self.viewModel selectCombinationMakeupAtIndex:indexPath.item complectionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [selectedCell.indicatorView stopAnimating];
            [self refreshSubviews];
            collectionView.userInteractionEnabled = YES;
            self.slider.userInteractionEnabled = YES;
            self.customizeButton.userInteractionEnabled = YES;
        });
    }];
}

#pragma mark - Collection view delegate flow layout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return (UIEdgeInsets){0, 16, 0, 16};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){54, 70};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.userInteractionEnabled = NO;
        [_collectionView registerClass:[FUCombinationMakeupCell class] forCellWithReuseIdentifier:kFUCombinationMakeupCellIdentifierKey];
    }
    return _collectionView;
}

- (FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectZero];
        [_slider addTarget:self action:@selector(sliderValueChangedAction) forControlEvents:UIControlEventValueChanged];
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        _slider.hidden = YES;
    }
    return _slider;
}

- (FUSquareButton *)customizeButton {
    if (!_customizeButton) {
        _customizeButton = [[FUSquareButton alloc] initWithFrame:CGRectMake(0, 0, 54, 70) interval:6];
        _customizeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_customizeButton setImage:FUMakeupImageNamed(@"makeup_custom") forState:UIControlStateNormal];
        [_customizeButton setTitle:FUMakeupStringWithKey(@"自定义") forState:UIControlStateNormal];
        [_customizeButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateDisabled];
        [_customizeButton addTarget:self action:@selector(customizeAction) forControlEvents:UIControlEventTouchUpInside];
        _customizeButton.enabled = NO;
    }
    return _customizeButton;
}

@end

@interface FUCombinationMakeupCell ()

@property (nonatomic, strong) UIImageView *fuImageView;
@property (nonatomic, strong) UILabel *fuTitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation FUCombinationMakeupCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.fuImageView];
        [self.contentView addSubview:self.fuTitleLabel];
        [self.contentView addSubview:self.indicatorView];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.fuImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.contentView addConstraints:@[centerXConstraint, centerYConstraint]];
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

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidesWhenStopped = YES;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicatorView;
}

@end
