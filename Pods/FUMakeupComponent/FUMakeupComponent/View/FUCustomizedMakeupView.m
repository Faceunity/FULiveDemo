//
//  FUCustomizedMakeupView.m
//  FUMakeupComponent
//
//  Created by 项林平 on 2021/11/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUCustomizedMakeupView.h"

#import "FUMakeupDefine.h"

#import <FUCommonUIComponent/FUCommonUIComponent.h>

static NSString * const kFUCustomizedMakeupItemCellIdentifierKey = @"FUCustomizedMakeupItemCell";
static NSString * const kFUCustomizedMakeupCategoryCellIdentifierKey = @"FUCustomizedMakeupCategoryCell";

@interface FUCustomizedMakeupView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *categoriesCollectionView;
@property (nonatomic, strong) UICollectionView *itemsCollectionView;
@property (nonatomic, strong) FUSlider *slider;

@property (nonatomic, strong) FUCustomizedMakeupViewModel *viewModel;

@end

@implementation FUCustomizedMakeupView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUCustomizedMakeupViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUCustomizedMakeupViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        self.backgroundColor = [UIColor clearColor];
        [self configureUI];
        
        [self refreshCategoryCollectionView];
        [self refreshItemsCollectionView];
        [self refreshSubviews];
        
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    // 毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:effectView];
    
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - FUMakeupHeightIncludeBottomSafeArea(49), CGRectGetWidth(self.frame), FUMakeupHeightIncludeBottomSafeArea(49))];
    categoryView.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:1.0];
    [self addSubview:categoryView];
    
    [categoryView addSubview:self.categoriesCollectionView];
    self.categoriesCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(categoryView.frame), 49);
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(categoryView.frame) - 0.5, CGRectGetWidth(self.frame), 0.5)];
    horizontalLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self addSubview:horizontalLine];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16, CGRectGetMinY(horizontalLine.frame) - 76, 54, 54);
    [backButton setImage:[UIImage imageNamed:@"makeup_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(85, CGRectGetMinY(horizontalLine.frame) - 69, 1, 40)];
    line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.2];
    [self addSubview:line];
    
    [self addSubview:self.itemsCollectionView];
    self.itemsCollectionView.frame = CGRectMake(86, CGRectGetMinY(horizontalLine.frame) - 90, CGRectGetWidth(self.frame) - 86, 82);
    
    [self addSubview:self.slider];
    self.slider.frame = CGRectMake(34, CGRectGetMinY(self.itemsCollectionView.frame) - 30, CGRectGetWidth(self.frame) - 68, 30);
}

#pragma mark - Instance methods

- (void)show {
    // 先刷新界面
    [self refreshCategoryCollectionView];
    [self refreshItemsCollectionView];
    [self refreshSubviews];
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

- (void)refreshCategoryCollectionView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.categoriesCollectionView reloadData];
        [self.categoriesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedCategoryIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    });
}

- (void)refreshItemsCollectionView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.itemsCollectionView reloadData];
        // 当前类型选中的单个子妆
        [self.itemsCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedSubMakeupIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    });
}

- (void)refreshSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.slider.hidden = self.viewModel.selectedSubMakeupIndex == 0;
        self.slider.value = self.viewModel.selectedSubMakeupValue;
    });
}

#pragma mark - Event response

- (void)backAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customizedMakeupViewDidClickBack)]) {
        [self.delegate customizedMakeupViewDidClickBack];
    }
}

- (void)sliderValueChangedAction {
    self.viewModel.selectedSubMakeupValue = self.slider.value;
}

- (void)sliderChangeEnded {
    [self refreshCategoryCollectionView];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView == self.categoriesCollectionView ? self.viewModel.customizedMakeups.count : self.viewModel.selectedSubMakeups.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.categoriesCollectionView) {
        FUCustomizedMakeupCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCustomizedMakeupCategoryCellIdentifierKey forIndexPath:indexPath];
        cell.categoryNameLabel.text = [self.viewModel categoryNameAtIndex:indexPath.item];
        cell.tipView.hidden = ![self.viewModel hasValidValueAtCategoryIndex:indexPath.item];
        return cell;
    } else {
        FUCustomizedMakeupItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCustomizedMakeupItemCellIdentifierKey forIndexPath:indexPath];
        cell.fuImageView.backgroundColor = [self.viewModel subMakeupBackgroundColorAtIndex:indexPath.item];
        cell.fuImageView.image = [self.viewModel subMakeupImageAtIndex:indexPath.item];
        return cell;
    }
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.categoriesCollectionView) {
        if (self.viewModel.selectedCategoryIndex == indexPath.item) {
            return;
        }
        self.viewModel.selectedCategoryIndex = indexPath.item;
        if (self.delegate && [self.delegate respondsToSelector:@selector(customizedMakeupViewDidChangeSubMakeup:)]) {
            [self.delegate customizedMakeupViewDidChangeSubMakeup:self.viewModel.selectedSubMakeupTitle];
        }
        [self refreshItemsCollectionView];
        [self refreshSubviews];
    } else {
        if (indexPath.item == self.viewModel.selectedSubMakeupIndex) {
            return;
        }
        self.viewModel.selectedSubMakeupIndex = indexPath.item;
        if (self.delegate && [self.delegate respondsToSelector:@selector(customizedMakeupViewDidChangeSubMakeup:)]) {
            [self.delegate customizedMakeupViewDidChangeSubMakeup:self.viewModel.selectedSubMakeupTitle];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.categoriesCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.viewModel.selectedCategoryIndex inSection:0]]];
            [self.categoriesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedCategoryIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self refreshSubviews];
        });
    }
}

#pragma mark - Collection view delegate flow layout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return collectionView == self.itemsCollectionView ? (UIEdgeInsets){0, 16, 0, 16} : UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.itemsCollectionView) {
        return (CGSize){54, 54};
    } else {
        NSString *titleString = [self.viewModel categoryNameAtIndex:indexPath.item];
        CGFloat titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}].width;
        return CGSizeMake(titleWidth + 40, 49);
    }
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
        [_slider addTarget:self action:@selector(sliderChangeEnded) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _slider.hidden = YES;
    }
    return _slider;
}

@end

@interface FUCustomizedMakeupCategoryCell ()

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *categoryNameLabel;

@end

@implementation FUCustomizedMakeupCategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.categoryNameLabel];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.categoryNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.categoryNameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.contentView addConstraints:@[centerX, centerY]];

        [self.contentView addSubview:self.tipView];
        NSLayoutConstraint *tipTrailing = [NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-4];
        NSLayoutConstraint *tipTop = [NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
        NSLayoutConstraint *tipWidth = [NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:4];
        NSLayoutConstraint *tipHeight = [NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:4];
        [self.contentView addConstraints:@[tipTrailing, tipTop]];
        [self.tipView addConstraints:@[tipWidth, tipHeight]];
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
        _tipView.translatesAutoresizingMaskIntoConstraints = NO;
        _tipView.hidden = YES;
    }
    return _tipView;
}

- (UILabel *)categoryNameLabel {
    if (!_categoryNameLabel) {
        _categoryNameLabel = [[UILabel alloc] init];
        _categoryNameLabel.font = [UIFont systemFontOfSize:13];
        _categoryNameLabel.textColor = [UIColor whiteColor];
        _categoryNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _categoryNameLabel;
}

@end


@interface FUCustomizedMakeupItemCell ()

@property (nonatomic, strong) UIImageView *fuImageView;

@end

@implementation FUCustomizedMakeupItemCell

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
