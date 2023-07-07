//
//  FUSegmentBar.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/9/26.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUSegmentBar.h"

@interface FUSegmentBar ()

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation FUSegmentBarConfigurations

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认选中/未选中颜色
        self.selectedTitleColor = [UIColor colorWithRed:94/255.0f green:199/255.0f blue:254/255.0f alpha:1.0];
        self.normalTitleColor = [UIColor whiteColor];
        self.disabledTitleColor = [UIColor colorWithWhite:1 alpha:0.6];
        self.titleFont = [UIFont systemFontOfSize:13];
    }
    return self;
}

@end

static NSString * const kFUSegmentCellIdentifierKey = @"FUSegmentCellIdentifier";

@interface FUSegmentBar ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) FUSegmentBarConfigurations *configuration;
@property (nonatomic, copy) NSArray *titles;

/// cell宽度数组
@property (nonatomic, copy) NSArray *itemWidths;

@end

@implementation FUSegmentBar

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles configuration:(FUSegmentBarConfigurations *)configuration {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:1.0];
        self.titles = [titles copy];
        self.configuration = configuration;
        if (!self.configuration) {
            self.configuration = [[FUSegmentBarConfigurations alloc] init];
        }
        
        // 计算宽度
        NSMutableArray *tempWidths = [NSMutableArray arrayWithCapacity:self.titles.count];
        if (self.titles.count < 7) {
            // 平均分配宽度
            CGFloat width = CGRectGetWidth(frame) / self.titles.count * 1.0;
            for (NSInteger i = 0; i < self.titles.count; i++) {
                [tempWidths addObject:@(width)];
            }
        } else {
            // 根据文字适配宽度
            for (NSString *title in self.titles) {
                CGSize nameSize = [title sizeWithAttributes:@{NSFontAttributeName : self.configuration.titleFont}];
                [tempWidths addObject:@(nameSize.width + 20)];
            }
        }
        self.itemWidths = [tempWidths copy];
        
        _selectedIndex = -1;
        
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - Instance methods

- (void)selectItemAtIndex:(NSInteger)index {
    NSInteger count = self.titles.count;
    if (index >= count) {
        return;
    }
    if (self.selectedIndex == index) {
        // 目标索引和当前选中索引相同时，不需要处理界面逻辑，只要触发回调即可
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:didSelectItemAtIndex:)]) {
            [self.delegate segmentBar:self didSelectItemAtIndex:index];
        }
        return;
    }
    if (index == -1) {
        // 取消选中时只需要更新界面
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:NO];
        self.selectedIndex = -1;
    } else {
        // 正常选中需要处理界面逻辑并触发回调
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:didSelectItemAtIndex:)]) {
            [self.delegate segmentBar:self didSelectItemAtIndex:index];
        }
        self.selectedIndex = index;
    }
    
}

- (void)refresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        if (self.selectedIndex >= 0) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUSegmentsBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUSegmentCellIdentifierKey forIndexPath:indexPath];
    cell.segmentTitleLabel.text = self.titles[indexPath.item];
    cell.segmentTitleLabel.font = self.configuration.titleFont;
    cell.segmentNormalTitleColor = self.configuration.normalTitleColor;
    cell.segmentSelectedTitleColor = self.configuration.selectedTitleColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:shouldDisableItemAtIndex:)]) {
        if ([self.delegate segmentBar:self shouldDisableItemAtIndex:indexPath.item]) {
            cell.segmentTitleLabel.textColor = self.configuration.disabledTitleColor;
        }
    }
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.item;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:didSelectItemAtIndex:)]) {
        [self.delegate segmentBar:self didSelectItemAtIndex:indexPath.item];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentBar:shouldSelectItemAtIndex:)]) {
        return [self.delegate segmentBar:self shouldSelectItemAtIndex:indexPath.item];
    }
    return YES;
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.itemWidths[indexPath.item] floatValue], CGRectGetHeight(collectionView.frame));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 49.f) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[FUSegmentsBarCell class] forCellWithReuseIdentifier:kFUSegmentCellIdentifierKey];
    }
    return _collectionView;
}

@end

@implementation FUSegmentsBarCell

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.segmentTitleLabel];
        NSLayoutConstraint *titleLabelCenterX = [NSLayoutConstraint constraintWithItem:self.segmentTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *titleLabelCenterY = [NSLayoutConstraint constraintWithItem:self.segmentTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.contentView addConstraints:@[titleLabelCenterX, titleLabelCenterY]];
    }
    return self;
}

#pragma mark - Setters

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.segmentTitleLabel.textColor = self.segmentSelectedTitleColor ? self.segmentSelectedTitleColor : [UIColor colorWithRed:94/255.0f green:199/255.0f blue:254/255.0f alpha:1.0];
    } else {
        self.segmentTitleLabel.textColor = self.segmentNormalTitleColor ? self.segmentNormalTitleColor : [UIColor whiteColor];
    }
}

#pragma mark - Getters

- (UILabel *)segmentTitleLabel {
    if (!_segmentTitleLabel) {
        _segmentTitleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _segmentTitleLabel.textColor = [UIColor whiteColor];
        _segmentTitleLabel.font = [UIFont systemFontOfSize:13];
        _segmentTitleLabel.textAlignment = NSTextAlignmentCenter;
        _segmentTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _segmentTitleLabel;
}

@end
