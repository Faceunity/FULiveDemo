//
//  FUMakeupComponentManager.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUMakeupComponentDelegate <NSObject>

@optional
- (void)makeupComponentViewHeightDidChange:(CGFloat)height;
/// 提示
- (void)makeupComponentNeedsDisplayPromptContent:(NSString *)content;

@end

@interface FUMakeupComponentManager : NSObject

@property (nonatomic, weak) id<FUMakeupComponentDelegate> delegate;

/// 美妆视图总高度
@property (nonatomic, assign, readonly) CGFloat componentViewHeight;

+ (instancetype)sharedManager;

/// 销毁
+ (void)destory;

/// 设置美妆特效资源路径（face_makeup.bundle）
- (void)loadMakeupForFilePath:(NSString *)filePath;

/// 在目标视图中添加美妆组件视图（固定位置为目标视图底部）
/// @param view 目标视图
- (void)addComponentViewToView:(UIView *)view;

/// 在父视图中移除美妆组件视图
- (void)removeComponentView;

@end

NS_ASSUME_NONNULL_END
