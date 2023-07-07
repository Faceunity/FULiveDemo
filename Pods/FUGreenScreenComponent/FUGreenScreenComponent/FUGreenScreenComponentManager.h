//
//  FUGreenScreenComponentManager.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/11.
//

#import <Foundation/Foundation.h>
#import <FURenderKit/FURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUGreenScreenComponentDelegate <NSObject>

/// 自定义安全区域
- (void)greenScreenComponentDidCustomizeSafeArea;

@optional
- (void)greenScreenComponentViewHeightDidChange:(CGFloat)height;

@end

@interface FUGreenScreenComponentManager : NSObject

/// 用于绿幕取色，默认为FURenderKit的glDisplayView
@property (nonatomic, strong, nullable) FUGLDisplayView *displayView;
/// 绿幕视图总高度
@property (nonatomic, assign, readonly) CGFloat componentViewHeight;
/// 绿幕视图选中功能索引，默认为0，-1表示未选中
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

@property (nonatomic, weak) id<FUGreenScreenComponentDelegate> delegate;

+ (instancetype)sharedManager;

/// 销毁
+ (void)destory;

/// 在目标视图中添加绿幕组件视图（固定位置为目标视图底部）
/// @param view 目标视图
- (void)addComponentViewToView:(UIView *)view;

/// 在父视图中移除绿幕组件视图
- (void)removeComponentView;

/// 加载绿幕效果
- (void)loadGreenScreen;

/// 卸载当前加载的绿幕
- (void)unloadGreenScreen;

/// 保存自定义安全区域图片
/// @param image 图片
- (void)saveCustomSafeArea:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
