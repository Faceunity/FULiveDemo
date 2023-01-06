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

- (BOOL)segmentBar:(FUSegmentBar *)segmentBar shouldDisableItemAtIndex:(NSInteger)index;

@end

@interface FUSegmentBarConfigurations : NSObject

/// 普通颜色
@property (nonatomic, strong) UIColor *normalTitleColor;
/// 选中状态颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;
/// 无法选中状态颜色
@property (nonatomic, strong) UIColor *disabledTitleColor;
/// 字体
@property (nonatomic, strong) UIFont *titleFont;

@end

@interface FUSegmentBar : UIView

@property (nonatomic, weak) id<FUSegmentBarDelegate> delegate;

/// 当前选中项索引
/// @discussion 默认为-1，-1为取消选中
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/// Unavailable initializer

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 初始化
/// @param frame frame
/// @param titles SegmentsTitle数组
/// @param configuration 配置信息
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles configuration:(nullable FUSegmentBarConfigurations *)configuration;

/// 选中指定索引项
/// @param index 索引
- (void)selectItemAtIndex:(NSInteger)index;

- (void)refresh;

@end

@interface FUSegmentsBarCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *segmentTitleLabel;
@property (nonatomic, strong) UIColor *segmentNormalTitleColor;
@property (nonatomic, strong) UIColor *segmentSelectedTitleColor;

@end

NS_ASSUME_NONNULL_END
