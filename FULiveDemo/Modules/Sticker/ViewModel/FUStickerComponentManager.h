//
//  FUStickerComponentManager.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerComponentManager : NSObject

+ (instancetype)sharedManager;

/// 销毁
+ (void)destory;

/// 在目标视图中添加贴纸组件视图（固定位置为目标视图底部）
/// @param view 目标视图
- (void)addComponentViewToView:(UIView *)view;

/// 在父视图中移除美妆组件视图
- (void)removeComponentView;

@end

NS_ASSUME_NONNULL_END
