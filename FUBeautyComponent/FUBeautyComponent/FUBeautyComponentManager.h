//
//  FUBeautyComponentManager.h
//  FUBeautyComponentManager
//
//  Created by 项林平 on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUBeautyComponentDelegate <NSObject>

@optional
- (void)beautyComponentViewHeightDidChange:(CGFloat)height;

- (void)beautyComponentDidTouchDownComparison;

- (void)beautyComponentDidTouchUpComparison;
/// 提示
- (void)beautyComponentNeedsDisplayPromptContent:(NSString *)content;

@end

@interface FUBeautyComponentManager : NSObject

@property (nonatomic, weak) id<FUBeautyComponentDelegate> delegate;
/// 美颜视图总高度
@property (nonatomic, assign, readonly) CGFloat componentViewHeight;
/// 美颜视图选中功能索引，默认-1，-1表示未选中
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

+ (instancetype)sharedManager;

/// 销毁
+ (void)destory;

/// 在目标视图中添加美颜组件视图（固定位置为目标视图底部）
/// @param view 目标视图
- (void)addComponentViewToView:(UIView *)view;

/// 在父视图中移除美颜组件视图
- (void)removeComponentView;

/// 加载美颜效果
/// @param filePath 美颜 bundle 文件路径
- (void)loadBeautyForFilePath:(NSString *)filePath;

/// 卸载当前加载的美颜
- (void)unloadBeauty;

/// 保存当前美颜数据到本地
- (void)saveBeauty;

@end

NS_ASSUME_NONNULL_END
