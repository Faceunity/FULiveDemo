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

@property (nonatomic, strong) FUBaseViewControllerManager *baseManager;

@property (nonatomic, strong) FULiveModel *model;

@property (strong, nonatomic,readonly) FUCaptureCamera *mCamera;
@property (strong, nonatomic) FUHeadButtonView *headButtonView;
@property (strong, nonatomic) FUPhotoButton *photoBtn;

@property (strong, nonatomic) FUGLDisplayView *renderView;
@property (strong, nonatomic) UILabel *noTrackLabel;
@property (strong, nonatomic) UILabel *tipLabel;
/* 是否开启比对 */
@property (assign, nonatomic) BOOL openComp;

/* 可以跳转到导入图片 */
@property (assign, nonatomic) BOOL canPushImageSelView;

@property (strong, nonatomic) FULightingView *lightingView;

@property (nonatomic, assign) BOOL isFromOtherPage; //记录是否从其他控制器回到该控制器

/* 子类重载，实现差异逻辑 */
-(void)takePhotoToSave:(UIImage *)image;//拍照保存

//渲染之前的buffer
- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput;
//渲染之后的buffer
- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput;

-(void)didClickSelPhoto;

-(void)displayPromptText;

-(BOOL)onlyJumpImage;

- (void)touchScreenAction:(UITapGestureRecognizer *)tap;

//avatar 不需要加载美颜，所以通过重写方法来告知父类是否加载美颜
- (BOOL)isNeedLoadBeauty;
@end

NS_ASSUME_NONNULL_END
