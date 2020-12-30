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
#import "FUCamera.h"
#import "FUHeadButtonView.h"
#import "FUPhotoButton.h"
#import <Masonry.h>
#import "FULiveModel.h"
#import "FUManager.h"
#import "FUOpenGLView.h"
#import "FULightingView.h"

#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define  iPhoneXStyle ((KScreenWidth == 375.f && KScreenHeight == 812.f ? YES : NO) || (KScreenWidth == 414.f && KScreenHeight == 896.f ? YES : NO))

NS_ASSUME_NONNULL_BEGIN

@interface FUBaseViewController : UIViewController<FUHeadButtonViewDelegate>
@property (nonatomic, strong) FULiveModel *model;

@property (strong, nonatomic,readonly) FUCamera *mCamera;
@property (strong, nonatomic) FUHeadButtonView *headButtonView;
@property (strong, nonatomic) FUPhotoButton *photoBtn;

@property (strong, nonatomic) FUOpenGLView *renderView;
@property (strong, nonatomic) UILabel *noTrackLabel;
@property (strong, nonatomic) UILabel *tipLabel;
/* 是否开启比对 */
@property (assign, nonatomic) BOOL openComp;

/* 可以跳转到导入图片 */
@property (assign, nonatomic) BOOL canPushImageSelView;

@property (strong, nonatomic) FULightingView *lightingView ;

/* 子类重载，实现差异逻辑 */
-(void)takePhotoToSave:(UIImage *)image;//拍照保存
-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

-(void)didClickSelPhoto;

-(void)displayPromptText;

-(BOOL)onlyJumpImage;

- (void)willResignActive;
- (void)didBecomeActive;

-(FUNamaHandleType)getNamaRenderType;

- (void)touchScreenAction:(UITapGestureRecognizer *)tap;

///  屏幕方向改变
/// @param orientation 方向
-(void)setOrientation:(int)orientation;

/* 抓图 */
-(UIImage *)captureImage;

@end

NS_ASSUME_NONNULL_END
