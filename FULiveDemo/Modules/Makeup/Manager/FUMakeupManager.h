//
//  FUMakeupManager.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/15.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"

@class FUCombinationMakeupModel, FUMakeupModel, FUSingleMakeupModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUMakeupManager : FUMetaManager

/// 组合妆数据
/// 注：此处把卸妆功能也组装成了一个组合妆模型
@property (nonatomic, copy, readonly) NSArray<FUCombinationMakeupModel *> *combinationMakeups;
/// 自定义妆容数据
@property (nonatomic, copy, readonly) NSArray<FUMakeupModel *> *makeups;
/// 当前选中的组合妆模型（nil表示当前未选择组合妆）
@property (nonatomic, strong, nullable) FUCombinationMakeupModel *currentCombinationMakeupModel;
/// 当前选择组合妆是否被自定义改变
@property (nonatomic, assign, readonly, getter=isChangedMakeup) BOOL changedMakeup;

/// 更新组合妆程度值
/// @param model 组合妆模型
- (void)updateIntensityOfCombinationMakeup:(FUCombinationMakeupModel *)model;

/// 更新单个妆容程度值
/// @param model 单个妆容模型
- (void)updateIntensityOfSingleMakeup:(FUSingleMakeupModel *)model;

/// 更新自定义单个妆容
/// @param model 单个妆容模型
- (void)updateCustomizedSingleMakeup:(FUSingleMakeupModel *)model;

/// 更新自定义单个妆容颜色
/// @param model 单个妆容模型
- (void)updateColorOfCustomizedSingleMakeup:(FUSingleMakeupModel *)model;

/// 对比当前选择的组合妆和自定义妆容数据
- (void)compareCustomizedMakeupsWithCurrentCombinationMakeup;

@end

NS_ASSUME_NONNULL_END
