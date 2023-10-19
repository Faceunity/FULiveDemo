//
//  FUCombinationMakeupViewModel.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FUMakeupDefine.h"

@class FUCombinationMakeupModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUCombinationMakeupViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUCombinationMakeupModel *> *combinationMakeups;

/// 当前选中组合妆是否允许自定义
@property (nonatomic, assign, readonly) BOOL isSelectedMakeupAllowedEdit;

/// 当前选中组合妆索引
/// @note 0表示卸载状态，-1表示未选中状态
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/// 当前选中组合妆程度值
@property (nonatomic, assign) double selectedMakeupValue;

/// face_makeup.bundle 路径
@property (nonatomic, copy) NSString *faceMakeupPath;

/// 选择组合妆，异步加载
/// @param index 组合妆索引，0为卸载，-1为未选中状态
/// @param complection 完成回调
- (void)selectCombinationMakeupAtIndex:(NSInteger)index complectionHandler:(nullable void (^)(void))complection;

/// 组合妆名称
/// @param index 索引
- (NSString *)combinationMakeupNameAtIndex:(NSUInteger)index;

/// 组合妆icon
/// @param index 索引
- (UIImage *)combinationMakeupIconAtIndex:(NSUInteger)index;

/// 选中组合妆中指定类型子妆的索引
/// @note 未选中组合妆时返回默认值0
- (NSUInteger)subMakeupIndexOfSelectedCombinationMakeupWithType:(FUSubMakeupType)type;

/// 选中组合妆中指定类型子妆的程度值
/// @note 未选中组合妆时返回默认值1.0
- (double)subMakeupValueOfSelectedCombinationMakeupWithType:(FUSubMakeupType)type;

/// 选中组合妆中指定类型子妆的颜色索引
/// @note 未选中组合妆时返回默认值0
- (NSUInteger)subMakeupColorIndexOfSelectedCombinationMakeupWithType:(FUSubMakeupType)type;

@end

NS_ASSUME_NONNULL_END
