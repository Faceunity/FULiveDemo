//
//  FUCustomizedMakeupViewModel.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FUMakeupDefine.h"

@class FUCustomizedMakeupModel, FUSubMakeupModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomizedMakeupViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUCustomizedMakeupModel *> *customizedMakeups;

/// 当前自定义子妆数组
@property (nonatomic, copy, readonly) NSArray<FUSubMakeupModel *> *selectedSubMakeups;

/// 当前自定义子妆是否需要自定义颜色选择器
@property (nonatomic, assign, readonly) BOOL needsColorPicker;

/// 当前自定义子妆可选颜色数组
@property (nonatomic, copy, readonly) NSArray<NSArray<NSNumber *> *> *currentColors;

/// 当前自定义子妆标题
@property (nonatomic, copy, readonly) NSString *selectedSubMakeupTitle;

/// 选中类型索引，默认为0
@property (nonatomic, assign) NSUInteger selectedCategoryIndex;

/// 当前自定义子妆索引
@property (nonatomic, assign) NSUInteger selectedSubMakeupIndex;

/// 当前自定义子妆选择的颜色索引
@property (nonatomic, assign) NSUInteger selectedColorIndex;

/// 当前自定义子妆程度值
@property (nonatomic, assign) double selectedSubMakeupValue;

/// face_makeup.bundle 路径
@property (nonatomic, copy) NSString *faceMakeupPath;

/// 更新自定义妆容数据
/// @param type 子妆类型
/// @param index 子妆索引
/// @param value 子妆程度值
/// @param colorIndex 子妆颜色索引
- (void)updateCustomizedMakeupsWithSubMakeupType:(FUSubMakeupType)type
                          selectedSubMakeupIndex:(NSUInteger)index
                          selectedSubMakeupValue:(double)value
                              selectedColorIndex:(NSUInteger)colorIndex;

/// 当前自定义妆容中指定类型子妆的索引
- (NSUInteger)subMakeupIndexWithType:(FUSubMakeupType)type;

/// 当前自定义妆容中指定类型子妆的程度值
- (double)subMakeupValueWithType:(FUSubMakeupType)type;

/// 当前自定义妆容中指定类型子妆的颜色索引
- (NSUInteger)subMakeupColorIndexWithType:(FUSubMakeupType)type;

/// 子妆容分类名称
/// @param index 分类索引
- (NSString *)categoryNameAtIndex:(NSUInteger)index;

/// 子妆容是否有值
/// @param index 分类索引
- (BOOL)hasValidValueAtCategoryIndex:(NSUInteger)index;

/// 子妆容视图背景色
/// @param index 子妆容索引
- (UIColor *)subMakeupBackgroundColorAtIndex:(NSUInteger)index;

/// 子妆容icon
/// @param index 子妆容索引
- (UIImage *)subMakeupImageAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
