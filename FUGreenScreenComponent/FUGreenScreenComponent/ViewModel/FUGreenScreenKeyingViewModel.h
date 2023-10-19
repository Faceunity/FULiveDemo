//
//  FUGreenScreenKeyingViewModel.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <Foundation/Foundation.h>

#import "FUGreenScreenSafeAreaViewModel.h"

@class FUGreenScreenKeyingModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenKeyingViewModel : NSObject

@property (nonatomic, strong, readonly) FUGreenScreenSafeAreaViewModel *safeAreaViewModel;

@property (nonatomic, copy, readonly) NSArray<FUGreenScreenKeyingModel *> *keyingArray;
/// 可选关键颜色数组
@property (nonatomic, strong, readonly) NSMutableArray<UIColor *> *keyColorArray;
/// 是否所有值都是默认
@property (nonatomic, assign, readonly) BOOL isDefaultValue;

/// 当前选中抠像功能索引，默认为0
@property (nonatomic, assign) NSInteger selectedIndex;
/// 当前选中抠像功能指
@property (nonatomic, assign) double selectedValue;
/// 当前选中关键颜色索引，默认为1
@property (nonatomic, assign) NSInteger selectedColorIndex;
/// 当前取的关键颜色
@property (nonatomic, strong) UIColor *currentKeyColor;

/// 设置所有抠像效果值
- (void)setAllKeyingValues;

/// 恢复自定义取色为默认
- (void)recoverCustomizedKeyColor;

/// 恢复所有效果为默认
- (void)recoverToDefault;

- (NSString *)keyingNameAtIndex:(NSInteger)index;

- (NSString *)keyingImageNameAtIndex:(NSInteger)index;

- (double)keyingDefaultValueAtIndex:(NSInteger)index;

- (double)keyingCurrentValueAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
