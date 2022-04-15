//
//  FUCustomizedMakeupView.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUCustomizedMakeupView, FUMakeupModel, FUSingleMakeupModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FUCustomizedMakeupViewDelegate <NSObject>

/// 妆容分类切换
- (void)customizedMakeupView:(FUCustomizedMakeupView *)view didChangeMakeupCategoryWithSingleMakeup:(FUSingleMakeupModel *)model;
/// 选中某个妆容选项
- (void)customizedMakeupView:(FUCustomizedMakeupView *)view didSelectedSingleMakeup:(FUSingleMakeupModel *)model;
/// 妆容程度值变化
- (void)customizedMakeupView:(FUCustomizedMakeupView *)view didChangeSingleMakeupValue:(FUSingleMakeupModel *)model;
/// 点击返回
- (void)customizedMakeupViewDidClickBack;

@end

@interface FUCustomizedMakeupView : UIView

/// 选中类型索引
@property (nonatomic, assign, readonly) NSInteger selectedCategoryIndex;

@property (nonatomic, weak) id<FUCustomizedMakeupViewDelegate> delegate;

- (void)reloadData:(NSArray<FUMakeupModel *> *)makeups;

/// 选中妆容
/// @param index 索引
- (void)selectMakeupAtIndex:(NSInteger)index;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
