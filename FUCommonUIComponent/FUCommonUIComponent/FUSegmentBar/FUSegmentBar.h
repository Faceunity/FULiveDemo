//
//  FUSegmentBar.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/9/26.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUSegmentBar;

NS_ASSUME_NONNULL_BEGIN

@protocol FUSegmentBarDelegate <NSObject>

- (void)segmentBar:(FUSegmentBar *)segmentBar didSelectItemAtIndex:(NSUInteger)index;

@optional
- (BOOL)segmentBar:(FUSegmentBar *)segmentBar shouldSelectItemAtIndex:(NSInteger)index;

@end

@interface FUSegmentBarConfigurations : NSObject

@property (nonatomic, strong) UIColor *normalTitleColor;             // 普通颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;           // 选中颜色
@property (nonatomic, strong) UIFont *titleFont;                     // 字体

@end

@interface FUSegmentBar : UICollectionView

@property (nonatomic, weak) id<FUSegmentBarDelegate> segmentDelegate;

/// Unavailable initializer

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

/// 当前选中项索引（-1为取消选中）
@property (nonatomic, assign) NSInteger selectedIndex;

/// 初始化
/// @param frame frame
/// @param titles SegmentsTitle数组
/// @param configuration 配置信息
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles configuration:(nullable FUSegmentBarConfigurations *)configuration;

@end

@interface FUSegmentsBarCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *segmentTitleLabel;
@property (nonatomic, strong) UIColor *segmentNormalTitleColor;
@property (nonatomic, strong) UIColor *segmentSelectedTitleColor;

@end

NS_ASSUME_NONNULL_END
