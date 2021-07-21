//
//  FUStickerSegmentsView.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUStickerSegmentsView;

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerSegmentsConfigurations : NSObject

@property (nonatomic, strong) UIColor *normalColor;             // 普通颜色
@property (nonatomic, strong) UIColor *selectedColor;           // 选中颜色

@end


@protocol FUStickerSegmentsViewDelegate<NSObject>

- (void)stickerSegmentsView:(FUStickerSegmentsView *)segmentsView didSelectItemAtIndex:(NSInteger)index;

@end

@interface FUStickerSegmentsView : UIView

@property (nonatomic, weak) id<FUStickerSegmentsViewDelegate> delegate;

/**
 初始化

 @param frame frame
 @param titles title数组
 @param configuration 配置信息
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles configuration:(nullable FUStickerSegmentsConfigurations *)configuration;

/**
 选择指定项

 @param index index
 */
- (void)selectSegmentItemWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
