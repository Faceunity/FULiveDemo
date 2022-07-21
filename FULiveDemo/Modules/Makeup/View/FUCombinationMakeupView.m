//
//  FUCombinationMakeupView.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUCombinationMakeupView.h"
#import "FUCombinationMakeupCell.h"
#import "FUSquareButton.h"

#import "FUCombinationMakeupModel.h"

#import "UIColor+FU.h"

static NSString * const kFUCombinationMakeupCellIdentifierKey = @"FUCombinationMakeupCell";

@interface FUCombinationMakeupView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) FUSlider *slider;
/// 自定义按钮
@property (nonatomic, strong) FUSquareButton *customizeButton;

/// 组合妆数据
@property (nonatomic, copy) NSArray<FUCombinationMakeupModel *> *combinationMakeupArray;
/// 当前选中索引
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation FUCombinationMakeupView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _selectedIndex = -1;
        
        [self configureUI];
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    // 毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [self addSubview:effectview];
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.customizeButton];
    [self.customizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(16);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_offset(-18);
        } else {
            make.bottom.equalTo(self.mas_bottom).mas_offset(-18);
        }
        make.size.mas_offset(CGSizeMake(54, 70));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexColorString:@"E5E5E5" alpha:0.2];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(85);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_offset(-33);
        } else {
            make.bottom.equalTo(self.mas_bottom).mas_offset(-33);
        }
        make.size.mas_offset(CGSizeMake(1, 40));
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(line.mas_trailing);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_offset(-4);
        } else {
            make.bottom.equalTo(self.mas_bottom).mas_offset(-4);
        }
        make.trailing.equalTo(self.mas_trailing);
        make.height.mas_offset(98);
    }];
    
    [self addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(34);
        make.trailing.equalTo(self.mas_trailing).mas_offset(-34);
        make.bottom.equalTo(self.collectionView.mas_top).mas_offset(-6);
    }];
}

#pragma mark - Instance methos

- (void)reloadData:(NSArray<FUCombinationMakeupModel *> *)combinationMakeups {
    _combinationMakeupArray = combinationMakeups;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)selectCombinationMakeupAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.combinationMakeupArray.count) {
        return;
    }
    self.selectedIndex = index;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    });
}

- (void)deselectCurrentCombinationMakeup {
    if (self.selectedIndex == -1) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:NO];
        _selectedIndex = -1;
        [self refreshSubviews];
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
    if (self.selectedIndex == -1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 自定义按钮状态
            self.customizeButton.enabled = YES;
            // slider状态
            self.slider.hidden = YES;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(FUHeightIncludeBottomSafeArea(114));
            }];
        });
    } else {
        FUCombinationMakeupModel *selectedModel = self.combinationMakeupArray[self.selectedIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 自定义按钮状态
            self.customizeButton.enabled = selectedModel.isAllowedEdit;
            // slider状态
            if (self.selectedIndex < 1) {
                self.slider.hidden = YES;
            }
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.selectedIndex < 1 ? FUHeightIncludeBottomSafeArea(114) : FUHeightIncludeBottomSafeArea(144));
            }];
            [UIView animateWithDuration:0.15 animations:^{
                [self.superview layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (self.selectedIndex >= 1) {
                    self.slider.hidden = NO;
                    self.slider.value = selectedModel.value;
                }
            }];
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
    FUCombinationMakeupModel *model = self.combinationMakeupArray[self.selectedIndex];
    model.value = self.slider.value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(combinationMakeupView:didChangeCombinationMakeupValue:)]) {
        [self.delegate combinationMakeupView:self didChangeCombinationMakeupValue:model];
    }
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.combinationMakeupArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUCombinationMakeupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCombinationMakeupCellIdentifierKey forIndexPath:indexPath];
    FUCombinationMakeupModel *model = self.combinationMakeupArray[indexPath.item];
    cell.fuImageView.image = [UIImage imageNamed:model.icon];
    cell.fuTitleLabel.text = FUNSLocalizedString(model.name, nil);
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.item;
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

#pragma mark - Setters

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex || selectedIndex < 0 || selectedIndex >= self.combinationMakeupArray.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    FUCombinationMakeupModel *selectedModel = self.combinationMakeupArray[selectedIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(combinationMakeupView:didSelectCombinationMakeup:)]) {
        [self.delegate combinationMakeupView:self didSelectCombinationMakeup:selectedModel];
    }
    [self refreshSubviews];
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
        [_collectionView registerClass:[FUCombinationMakeupCell class] forCellWithReuseIdentifier:kFUCombinationMakeupCellIdentifierKey];
    }
    return _collectionView;
}

- (FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectZero];
        [_slider addTarget:self action:@selector(sliderValueChangedAction) forControlEvents:UIControlEventValueChanged];
        _slider.hidden = YES;
    }
    return _slider;
}

- (FUSquareButton *)customizeButton {
    if (!_customizeButton) {
        _customizeButton = [[FUSquareButton alloc] initWithFrame:CGRectMake(0, 0, 54, 70) interval:6];
        [_customizeButton setImage:[UIImage imageNamed:@"makeup_custom_nor"] forState:UIControlStateNormal];
        [_customizeButton setTitle:FUNSLocalizedString(@"自定义", nil) forState:UIControlStateNormal];
        [_customizeButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateDisabled];
        [_customizeButton addTarget:self action:@selector(customizeAction) forControlEvents:UIControlEventTouchUpInside];
        _customizeButton.enabled = NO;
    }
    return _customizeButton;
}

@end
