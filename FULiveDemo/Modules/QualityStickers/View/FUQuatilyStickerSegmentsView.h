//
//  FUQuatilyStickerSegmentsView.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/9/26.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUQuatilyStickerSegmentsView;

NS_ASSUME_NONNULL_BEGIN

@protocol FUQualityStickerSegmentsViewDelegate <NSObject>

- (void)qualityStickerSegmentsView:(FUQuatilyStickerSegmentsView *)segmentsView didSelectItemAtIndex:(NSUInteger)index;

@end

@interface FUQuatilyStickerSegmentsConfigurations : NSObject

@property (nonatomic, strong) UIColor *normalTitleColor;             // 普通颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;           // 选中颜色

@end

@interface FUQuatilyStickerSegmentsView : UICollectionView

@property (nonatomic, weak) id<FUQualityStickerSegmentsViewDelegate> quatilyStickerSegmentsDelegate;

/// Unvailable initializer

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

/// 初始化
/// @param frame frame
/// @param titles SegmentsTitle数组
/// @param configuration 配置信息
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles configuration:(nullable FUQuatilyStickerSegmentsConfigurations *)configuration;

/// 选择指定项
/// @param index 索引
- (void)selectSegmentItemAtIndex:(NSInteger)index;

@end

@interface FUQuatilyStickerSegmentsCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *segmentTitleLabel;
@property (nonatomic, strong) UIColor *segmentNormalTitleColor;
@property (nonatomic, strong) UIColor *segmentSelectedTitleColor;

@end

NS_ASSUME_NONNULL_END
