//
//  FUVideoRenderViewController.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import <UIKit/UIKit.h>
#import <FUBeautyComponent/FUBeautyComponent.h>

#import "FUVideoRenderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUVideoRenderViewController : UIViewController<FUVideoRenderViewModelDelegate>

@property (nonatomic, strong, readonly) FUGLDisplayView *renderView;
/// 人脸/人体/手势检测提示标签
@property (nonatomic, strong, readonly) UILabel *noTrackLabel;
/// 额外操作提示标签
@property (nonatomic, strong, readonly) UILabel *tipLabel;

@property (nonatomic, strong, readonly) FUVideoRenderViewModel *viewModel;

- (instancetype)initWithViewModel:(FUVideoRenderViewModel *)viewModel;

/// 更新保存按钮距离屏幕底部的距离
- (void)updateBottomConstraintsOfDownloadButton:(CGFloat)constraints;

@end

NS_ASSUME_NONNULL_END
