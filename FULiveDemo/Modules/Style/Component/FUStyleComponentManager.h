//
//  FUStyleComponentManager.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUStyleComponentDelegate <NSObject>

@optional
- (void)styleComponentViewHeightDidChange:(CGFloat)height;

- (void)styleComponentDidTouchDownComparison;

- (void)styleComponentDidTouchUpComparison;

@end

@interface FUStyleComponentManager : NSObject

/// 视图总高度
@property (nonatomic, assign, readonly) CGFloat componentViewHeight;

@property (nonatomic, weak) id<FUStyleComponentDelegate> delegate;

+ (instancetype)sharedManager;

/// 销毁
+ (void)destory;

/// 在目标视图中添加视图（固定位置为目标视图底部）
/// @param view 目标视图
- (void)addComponentViewToView:(UIView *)view;

/// 在父视图中移除视图
- (void)removeComponentView;

- (void)saveStyles;

@end

NS_ASSUME_NONNULL_END
