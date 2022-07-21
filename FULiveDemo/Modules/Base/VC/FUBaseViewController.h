//
//  FUBaseViewController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//
/* 视频采集·切换，公用UI，基类控制器 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "FUHeadButtonView.h"
#import "FUPhotoButton.h"
#import "FULiveModel.h"
#import "FUManager.h"
#import "FULightingView.h"
#import "FUBaseViewControllerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBaseViewController : UIViewController<FUHeadButtonViewDelegate>

@property (nonatomic, strong) FULiveModel *model;

@property (nonatomic, strong, readonly) FUBaseViewControllerManager *baseManager;
@property (nonatomic, strong, readonly) FUCaptureCamera *mCamera;
@property (nonatomic, strong, readonly) FUHeadButtonView *headButtonView;
@property (nonatomic, strong, readonly) FUPhotoButton *photoBtn;
@property (nonatomic, strong, readonly) FUGLDisplayView *renderView;
@property (nonatomic, strong, readonly) FULightingView *lightingView;
@property (nonatomic, strong, readonly) UILabel *noTrackLabel;
@property (nonatomic, strong, readonly) UILabel *tipLabel;
/// 记录是否从其他控制器回到该控制器
@property (nonatomic, assign, readonly) BOOL isFromOtherPage;

/// 是否开启效果对比
@property (nonatomic, assign) BOOL openComp;
/// 是否可以跳转到导入图片
@property (nonatomic, assign) BOOL canPushImageSelView;
/// 是否可选择分辨率
@property (nonatomic, assign) BOOL needsPresetSelections;
/// 是否需要加载美颜
@property (nonatomic, assign) BOOL needsLoadingBeauty;


#pragma mark - Override methods
- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput;

- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput;
/// 拍照保存
-(void)takePhotoToSave:(UIImage *)image;
/// 点击选择图片或视频
-(void)didClickSelPhoto;
/// 点击背景
- (void)touchScreenAction:(UITapGestureRecognizer *)tap;
/// 人脸/人体检测提示
-(void)displayPromptText;

@end

NS_ASSUME_NONNULL_END
