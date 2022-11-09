//
//  FURenderViewController.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/19.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FUBeautyComponent/FUBeautyComponent.h>

#import "FUHeadButtonView.h"
#import "FUCaptureButton.h"
#import "FURenderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FURenderViewController : UIViewController<FURenderViewModelDelegate, FUHeadButtonViewDelegate, FUCaptureButtonDelegate>

/// 渲染视图
@property (nonatomic, strong, readonly) FUGLDisplayView *renderView;
/// 顶部功能视图
@property (nonatomic, strong, readonly) FUHeadButtonView *headButtonView;
/// 人脸/人体/手势检测提示标签
@property (nonatomic, strong, readonly) UILabel *noTrackLabel;
/// 额外操作提示标签
@property (nonatomic, strong, readonly) UILabel *tipLabel;

@property (nonatomic, strong, readonly) FURenderViewModel *viewModel;

- (instancetype)initWithViewModel:(FURenderViewModel *)viewModel;

/// 更新拍照/录制按钮到屏幕底部的距离
/// @param animated 是否需要动画
- (void)updateBottomConstraintsOfCaptureButton:(CGFloat)constant animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
