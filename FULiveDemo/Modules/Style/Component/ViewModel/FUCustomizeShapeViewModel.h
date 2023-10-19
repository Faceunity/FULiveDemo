//
//  FUCustomizeShapeViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import <Foundation/Foundation.h>

@class FUStyleShapeModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomizeShapeViewModel : NSObject

@property (nonatomic, copy) NSArray<FUStyleShapeModel *> *shapes;

/// 当前选中索引，默认为-1
@property (nonatomic, assign) NSInteger selectedIndex;
/// 是否关闭效果
@property (nonatomic, assign, getter=isEffectDisabled) BOOL effectDisabled;
/// 属性需要根据高低端机适配
@property (nonatomic, assign, readonly) FUDevicePerformanceLevel performanceLevel;

- (void)setShapeValue:(double)value;

- (NSString *)nameAtIndex:(NSUInteger)index;

- (double)defaultValueAtIndex:(NSUInteger)index;

- (double)currentValueAtIndex:(NSUInteger)index;

- (BOOL)isDefaultValueInMiddleAtIndex:(NSUInteger)index;

- (BOOL)isDifferentiateDevicePerformanceAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
