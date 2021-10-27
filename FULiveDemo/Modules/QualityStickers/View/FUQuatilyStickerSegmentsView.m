//
//  FUQuatilyStickerSegmentsView.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/9/26.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUQuatilyStickerSegmentsView.h"

#import <Masonry.h>

@implementation FUQuatilyStickerSegmentsConfigurations

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认选中/未选中颜色
        self.selectedTitleColor = [UIColor colorWithRed:94/255.0f green:199/255.0f blue:254/255.0f alpha:1.0];
        self.normalTitleColor = [UIColor whiteColor];
    }
    return self;
}

@end

static NSString * const kFUQuatilyStickerSegmentsCellIdentifierKey = @"FUQuatilyStickerSegmentsCellIdentifier";

@interface FUQuatilyStickerSegmentsView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) FUQuatilyStickerSegmentsConfigurations *configuration;

/// cell宽度数组
@property (nonatomic, copy) NSArray *itemWidths;

@end

@implementation FUQuatilyStickerSegmentsView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles configuration:(FUQuatilyStickerSegmentsConfigurations *)configuration {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.titles = [titles copy];
        self.configuration = configuration;
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        // 计算宽度
        NSMutableArray *tempWidths = [NSMutableArray arrayWithCapacity:self.titles.count];
        if (self.titles.count < 6) {
            // 平均分配宽度
            CGFloat width = CGRectGetWidth(frame) / self.titles.count * 1.0;
            for (NSInteger i = 0; i < self.titles.count; i++) {
                [tempWidths addObject:@(width)];
            }
        } else {
            // 根据文字适配宽度
            for (NSString *title in self.titles) {
                NSString *resultString = [title copy];
                if ([title componentsSeparatedByString:@"/"].count > 1) {
                    NSArray *tempTitles = [title componentsSeparatedByString:@"/"];
                    NSString *languageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
                    resultString = [languageString isEqualToString:@"zh-Hans"] ? tempTitles[0] : tempTitles[1];
                }
                CGSize nameSize = [resultString sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
                [tempWidths addObject:@(nameSize.width + 20)];
            }
        }
        self.itemWidths = [tempWidths copy];
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[FUQuatilyStickerSegmentsCell class] forCellWithReuseIdentifier:kFUQuatilyStickerSegmentsCellIdentifierKey];
    }
    return self;
}

#pragma mark - Instance methods

- (void)selectSegmentItemAtIndex:(NSInteger)index {
    if (index >= self.titles.count) {
        return;
    }
    [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUQuatilyStickerSegmentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUQuatilyStickerSegmentsCellIdentifierKey forIndexPath:indexPath];
    NSString *titleString = self.titles[indexPath.item];
    if ([self.titles[indexPath.item] componentsSeparatedByString:@"/"].count > 1) {
        NSArray *titles = [self.titles[indexPath.item] componentsSeparatedByString:@"/"];
        NSString *languageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
        titleString = [languageString isEqualToString:@"zh-Hans"] ? titles[0] : titles[1];
    }
    cell.segmentTitleLabel.text = titleString;
    cell.segmentNormalTitleColor = self.configuration.normalTitleColor;
    cell.segmentSelectedTitleColor = self.configuration.selectedTitleColor;
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    if (self.quatilyStickerSegmentsDelegate && [self.quatilyStickerSegmentsDelegate respondsToSelector:@selector(qualityStickerSegmentsView:didSelectItemAtIndex:)]) {
        [self.quatilyStickerSegmentsDelegate qualityStickerSegmentsView:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.itemWidths[indexPath.item] floatValue], CGRectGetHeight(self.frame));
}

@end

@implementation FUQuatilyStickerSegmentsCell

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.segmentTitleLabel];
        [self.segmentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
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
    }
    return _segmentTitleLabel;
}

@end
