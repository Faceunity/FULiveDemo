//
//  FUStyleCustomizingViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import <Foundation/Foundation.h>

@class FUStyleModel, FUCustomizeSkinViewModel, FUCustomizeShapeViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUStyleCustomizingViewModel : NSObject

@property (nonatomic, strong, readonly) FUCustomizeSkinViewModel *skinViewModel;
@property (nonatomic, strong, readonly) FUCustomizeShapeViewModel *shapeViewModel;

@property (nonatomic, assign) BOOL skinEffectDisabled;
@property (nonatomic, assign) BOOL shapeEffectDisabled;

@property (nonatomic, assign) BOOL skinSegmentationEnabled;

/// 选中自定义功能（美肤或者美型）索引，默认为0
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
/// 自定义风格
@property (nonatomic, strong) FUStyleModel *customizingStyle;

@end

NS_ASSUME_NONNULL_END
