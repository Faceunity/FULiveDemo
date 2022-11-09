//
//  FUBodyBeautyViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import "FURenderViewModel.h"
#import "FUBodyBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBodyBeautyViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<FUBodyBeautyModel *> *bodyBeautyItems;
/// 是否所有值都是默认
@property (nonatomic, assign, readonly) BOOL isDefaultValue;
/// 当前选中索引，默认为0
@property (nonatomic, assign) NSInteger selectedIndex;

/// 设置单项美体值
/// @param value 当前选中单项的值
- (void)setCurrentValue:(double)value;

/// 恢复所有美肤值为默认
- (void)recoverToDefault;

@end

NS_ASSUME_NONNULL_END
