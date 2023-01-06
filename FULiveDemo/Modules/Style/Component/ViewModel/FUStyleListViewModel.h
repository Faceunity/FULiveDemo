//
//  FUStyleListViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import <Foundation/Foundation.h>

@class FUStyleModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUStyleFunction) {
    FUStyleFunctionFilter = 0,
    FUStyleFunctionMakeup
};

@interface FUStyleListViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUStyleModel *> *styles;
/// 当前选中的风格推荐索引，默认为1
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;
/// 是否所有选择和效果值都是默认
@property (nonatomic, assign, readonly) BOOL isDefault;

/// 当前选中的风格可选功能，默认为FUStyleFunctionMakeup
@property (nonatomic, assign) FUStyleFunction selectedStyleFunction;
/// 当前选中风格的妆容程度值
@property (nonatomic, assign) double selectedMakeupValue;
/// 当前选中风格的妆容滤镜程度值
@property (nonatomic, assign) double selectedMakeupFilterValue;

/// 选中风格推荐
/// - Parameters:
///   - index: 索引
///   - completion: 加载完成回调
- (void)selectStyleAtIndex:(NSUInteger)index completion:(nullable void (^)(void))completion;

/// 恢复默认选择和默认效果值
- (void)resetToDefault;

/// 保存风格推荐数据到本地
- (void)saveStylesPersistently;

- (NSString *)styleNameAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
