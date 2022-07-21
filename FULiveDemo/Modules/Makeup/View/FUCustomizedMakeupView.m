//
//  FUCustomizedMakeupView.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUCustomizedMakeupView.h"
#import "FUCustomizedMakeupCell.h"

#import "FUMakeupModel.h"
#import "FUSingleMakeupModel.h"

#import "UIColor+FU.h"
#import "FUMakeupDefine.h"

static NSString * const kFUCustomizedMakeupItemCellIdentifierKey = @"FUCustomizedMakeupItemCell";
static NSString * const kFUCustomizedMakeupCategoryCellIdentifierKey = @"FUCustomizedMakeupCategoryCell";

@interface FUCustomizedMakeupView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *categoriesCollectionView;
@property (nonatomic, strong) UICollectionView *itemsCollectionView;
@property (nonatomic, strong) FUSlider *slider;

@property (nonatomic, copy) NSArray<FUMakeupModel *> *makeups;

/// 选中类型索引
@property (nonatomic, assign) NSInteger selectedCategoryIndex;

@end

@implementation FUCustomizedMakeupView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    
    UIView *categoryView = [[UIView alloc] init];
    categoryView.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:1.0];
    [self addSubview:categoryView];
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(49));
    }];
    
    [categoryView addSubview:self.categoriesCollectionView];
    [self.categoriesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(categoryView);
        make.height.mas_offset(49);
    }];
    
    UIView *horizontalLine = [[UIView alloc] init];
    horizontalLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self addSubview:horizontalLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(categoryView.mas_top);
        make.height.mas_offset(0.5);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"makeup_return_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(16);
        make.bottom.equalTo(horizontalLine.mas_top).mas_offset(-22);
        make.size.mas_offset(CGSizeMake(54, 54));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexColorString:@"E5E5E5" alpha:0.2];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(85);
        make.bottom.equalTo(horizontalLine.mas_top).mas_offset(-29);
        make.size.mas_offset(CGSizeMake(1, 40));
    }];
    
    [self addSubview:self.itemsCollectionView];
    [self.itemsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(line.mas_trailing);
        make.bottom.equalTo(horizontalLine.mas_top);
        make.trailing.equalTo(self.mas_trailing);
        make.height.mas_offset(98);
    }];
    
    [self addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(34);
        make.trailing.equalTo(self.mas_trailing).mas_offset(-34);
        make.bottom.equalTo(self.itemsCollectionView.mas_top).mas_offset(-6);
    }];
}

#pragma mark - Instance methods

- (void)reloadData:(NSArray<FUMakeupModel *> *)makeups {
    _makeups = makeups;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.categoriesCollectionView reloadData];
    });
}

- (void)selectMakeupAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.makeups.count) {
        return;
    }
    self.selectedCategoryIndex = index;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.categoriesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    });
    
    [self selectItemAtIndex:self.makeups[self.selectedCategoryIndex].selectedIndex];
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds));
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - Private methods

- (void)selectItemAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.itemsCollectionView reloadData];
        [self.itemsCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self updateSubviews];
    });
}

- (void)updateSubviews {
    FUMakeupModel *model = self.makeups[self.selectedCategoryIndex];
    if (model.selectedIndex == 0) {
        self.slider.hidden = YES;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(model.selectedIndex == 0 ? FUHeightIncludeBottomSafeArea(155) : FUHeightIncludeBottomSafeArea(190));
    }];
    [UIView animateWithDuration:0.15 animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (model.selectedIndex > 0) {
            self.slider.hidden = NO;
            self.slider.value = model.singleMakeups[model.selectedIndex].value;
        }
    }];
}

#pragma mark - Event response

- (void)backAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customizedMakeupViewDidClickBack)]) {
        [self.delegate customizedMakeupViewDidClickBack];
    }
}

- (void)sliderValueChangedAction {
    FUMakeupModel *model = self.makeups[self.selectedCategoryIndex];
    FUSingleMakeupModel *singleModel = model.singleMakeups[model.selectedIndex];
    if ((singleModel.value == 0 && self.slider.value > 0) || (singleModel.value > 0 && self.slider.value == 0)) {
        // 需要刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.categoriesCollectionView reloadData];
            [self.categoriesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedCategoryIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        });
    }
    singleModel.value = self.slider.value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(customizedMakeupView:didChangeSingleMakeupValue:)]) {
        [self.delegate customizedMakeupView:self didChangeSingleMakeupValue:singleModel];
    }
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView == self.categoriesCollectionView ? self.makeups.count : self.makeups[self.selectedCategoryIndex].singleMakeups.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.categoriesCollectionView) {
        FUCustomizedMakeupCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCustomizedMakeupCategoryCellIdentifierKey forIndexPath:indexPath];
        FUMakeupModel *makeupModel = self.makeups[indexPath.item];
        cell.categoryNameLabel.text = FUNSLocalizedString(makeupModel.name, nil);
        cell.tipView.hidden = makeupModel.selectedIndex == 0 || makeupModel.singleMakeups[makeupModel.selectedIndex].value == 0;
        return cell;
    } else {
        FUCustomizedMakeupItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCustomizedMakeupItemCellIdentifierKey forIndexPath:indexPath];
        FUMakeupModel *makeupModel = self.makeups[self.selectedCategoryIndex];
        FUSingleMakeupModel *singleMakeupModel = makeupModel.singleMakeups[indexPath.item];
        if (singleMakeupModel.type == FUSingleMakeupTypeFoundation && indexPath.item > 0) {
            // 粉底只设置icon背景色
            NSArray *color = singleMakeupModel.colors[singleMakeupModel.defaultColorIndex];
            cell.fuImageView.backgroundColor = [UIColor colorWithRed:[color[0] floatValue] green:[color[1] floatValue] blue:[color[2] floatValue] alpha:[color[3] floatValue]];
            cell.fuImageView.image = nil;
        } else {
            // 设置icon图片
            cell.fuImageView.backgroundColor = [UIColor clearColor];
            cell.fuImageView.image = [UIImage imageNamed:singleMakeupModel.icon];
        }
        return cell;
    }
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.categoriesCollectionView) {
        if (self.selectedCategoryIndex == indexPath.item) {
            return;
        }
        self.selectedCategoryIndex = indexPath.item;
        [self selectItemAtIndex:self.makeups[self.selectedCategoryIndex].selectedIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(customizedMakeupView:didChangeMakeupCategoryWithSingleMakeup:)]) {
            [self.delegate customizedMakeupView:self didChangeMakeupCategoryWithSingleMakeup:self.makeups[self.selectedCategoryIndex].singleMakeups[self.makeups[self.selectedCategoryIndex].selectedIndex]];
        }
    } else {
        FUMakeupModel *currentModel = self.makeups[self.selectedCategoryIndex];
        if (currentModel.selectedIndex == indexPath.item) {
            return;
        }
        currentModel.selectedIndex = indexPath.item;
        if (self.delegate && [self.delegate respondsToSelector:@selector(customizedMakeupView:didSelectedSingleMakeup:)]) {
            [self.delegate customizedMakeupView:self didSelectedSingleMakeup:currentModel.singleMakeups[currentModel.selectedIndex]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.categoriesCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.selectedCategoryIndex inSection:0]]];
            [self.categoriesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedCategoryIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self updateSubviews];
        });
    }
}

#pragma mark - Collection view delegate flow layout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return collectionView == self.itemsCollectionView ? (UIEdgeInsets){0, 16, 0, 16} : UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView == self.itemsCollectionView ? (CGSize){54, 54} : (CGSize){70, 49};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return collectionView == self.itemsCollectionView ? 16 : 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return collectionView == self.itemsCollectionView ? 16 : 0;
}

#pragma mark - Getters

- (UICollectionView *)categoriesCollectionView {
    if (!_categoriesCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _categoriesCollectionView.backgroundColor = [UIColor clearColor];
        _categoriesCollectionView.showsHorizontalScrollIndicator = NO;
        _categoriesCollectionView.dataSource = self;
        _categoriesCollectionView.delegate = self;
        [_categoriesCollectionView registerClass:[FUCustomizedMakeupCategoryCell class] forCellWithReuseIdentifier:kFUCustomizedMakeupCategoryCellIdentifierKey];
    }
    return _categoriesCollectionView;
}

- (UICollectionView *)itemsCollectionView {
    if (!_itemsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _itemsCollectionView.backgroundColor = [UIColor clearColor];
        _itemsCollectionView.showsHorizontalScrollIndicator = NO;
        _itemsCollectionView.dataSource = self;
        _itemsCollectionView.delegate = self;
        [_itemsCollectionView registerClass:[FUCustomizedMakeupItemCell class] forCellWithReuseIdentifier:kFUCustomizedMakeupItemCellIdentifierKey];
    }
    return _itemsCollectionView;
}

- (FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectZero];
        [_slider addTarget:self action:@selector(sliderValueChangedAction) forControlEvents:UIControlEventValueChanged];
        _slider.hidden = YES;
    }
    return _slider;
}

@end
