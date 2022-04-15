//
//  FUCombinationMakeupView.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUCombinationMakeupModel, FUCombinationMakeupView;

NS_ASSUME_NONNULL_BEGIN

@protocol FUCombinationMakeupViewDelegate <NSObject>

/// 选中组合妆
- (void)combinationMakeupView:(FUCombinationMakeupView *)view didSelectCombinationMakeup:(FUCombinationMakeupModel *)model;

/// 组合妆程度值变化
- (void)combinationMakeupView:(FUCombinationMakeupView *)view didChangeCombinationMakeupValue:(FUCombinationMakeupModel *)model;

/// 自定义妆容
- (void)combinationMakeupViewDidClickCustomize;

@end

@interface FUCombinationMakeupView : UIView

@property (nonatomic, assign) BOOL showing;
@property (nonatomic, weak) id<FUCombinationMakeupViewDelegate> delegate;

- (void)reloadData:(NSArray<FUCombinationMakeupModel *> *)combinationMakeups;

/// 选中组合妆
/// @param index 索引
- (void)selectCombinationMakeupAtIndex:(NSInteger)index;

/// 取消选中当前组合妆
- (void)deselectCurrentCombinationMakeup;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
