//
//  FUPopupMenu.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/11.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@class FUPopupMenu;
@protocol FUPopupMenuDelegate <NSObject>

@optional
/**
 点击事件回调
 */
- (void)fuPopupMenuSegment:(FUSegmentedControl *)segment didSelectedAtIndex:(NSInteger)index;
- (void)fuPopupMenuDidSelectedImage;
@end

@interface FUPopupMenu : UIView

/**
 代理
 */
@property (nonatomic, weak) id <FUPopupMenuDelegate> delegate;


///  弹出
/// @param view b绑定的view
/// @param frame 尺寸
/// @param index 分辨率默认选中
/// @param onlyTop 是否只显示分辨率
/// @param delegate 代理
+ (FUPopupMenu *)showRelyOnView:(UIView *)view frame:(CGRect)frame defaultSelectedAtIndex:(int)index onlyTop:(BOOL)onlyTop delegate:(id<FUPopupMenuDelegate>)delegate;

///  弹出
/// @param view b绑定的view
/// @param frame 尺寸
/// @param index 分辨率默认选中
/// @param onlyTop 是否只显示分辨率
/// @param dataSource 数据源
/// @param delegate 代理
+ (FUPopupMenu *)showRelyOnView:(UIView *)view frame:(CGRect)frame defaultSelectedAtIndex:(int)index onlyTop:(BOOL)onlyTop dataSource:(nullable NSArray *)dataSource delegate:(id<FUPopupMenuDelegate>)delegate;

@property (nonatomic) int  selIndex;


/// 隐藏
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
