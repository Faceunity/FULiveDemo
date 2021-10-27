//
//  FUBaseViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBaseViewController.h"
#import "FUItemsView.h"
#import "FULiveModel.h"
#import <SVProgressHUD.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FUEditImageViewController.h"
#import "FUSelectedImageController.h"
#import <CoreMotion/CoreMotion.h>
#import "FUPopupMenu.h"

#import <FURenderKit/FURenderIO.h>
#import <FURenderKit/FURenderKit.h>
#import <FURenderKit/FUImageHelper.h>
#import "NSObject+economizer.h"

@interface FUBaseViewController ()<
FURenderKitDelegate,
FUPhotoButtonDelegate,
FUItemsViewDelegate,
FULightingViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,
FUPopupMenuDelegate, FUCaptureCameraDataSource
>
{
    dispatch_semaphore_t signal;
    dispatch_semaphore_t semaphore;
    UIImage *mCaptureImage;
    float imageW ;
    float imageH;
    
    BOOL _isFromOtherPage;//记录是否从其他页面回到美颜
}
@property (strong, nonatomic) FUCaptureCamera *mCamera ;

@property (strong, nonatomic) UILabel *buglyLabel;
@property (strong, nonatomic) UIImageView *adjustImage;
/* 分辨率 选中第几个项 */
@property (assign, nonatomic) int selIndex;

@end

@implementation FUBaseViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//默认YES
- (BOOL)isNeedLoadBeauty {
    return YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.baseManager = [[FUBaseViewControllerManager alloc] init];
    
    if ([self isNeedLoadBeauty]) {
        [self.baseManager loadItem];
    }
    
    [[FURenderKit shareRenderKit] startInternalCamera];
    [FURenderKit shareRenderKit].captureCamera.dataSource = self;
    //把渲染的View 赋值给 FURenderKit，这样会在FURenderKit内部自动渲染
    [FURenderKit shareRenderKit].glDisplayView = self.renderView;
    [FURenderKit shareRenderKit].delegate = self;
    [self.baseManager setMaxFaces:(int)self.model.maxFace];
    [self setupSubView];
    
    self.view.backgroundColor = [UIColor colorWithRed:17/255.0 green:18/255.0 blue:38/255.0 alpha:1.0];

    [self setupLightingValue];
    /* 道具切信号 */
    signal = dispatch_semaphore_create(1);
  
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScreenAction:)];
    [self.renderView addGestureRecognizer:tap];
    self.canPushImageSelView = YES;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置图像加载模式为视频模式
    [self.baseManager setFaceProcessorDetectMode:FUFaceProcessorDetectModeVideo];
    if (_isFromOtherPage) {
        [[FURenderKit shareRenderKit] startInternalCamera];
        [self.baseManager loadItem];
        [FURenderKit shareRenderKit].glDisplayView = self.renderView;
    }
    [FURenderKit shareRenderKit].pause = NO;
    [FURenderKit shareRenderKit].internalCameraSetting.position = self.baseManager.cameraPosition;
    //不确定是不是小bug，每次重新回到页面分辨率都被设置成AVCaptureSessionPreset1280x720了，放到页面初始化地方去
//    [FURenderKit shareRenderKit].internalCameraSetting.sessionPreset = AVCaptureSessionPreset1280x720;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isFromOtherPage = YES;
    [self.mCamera resetFocusAndExposureModes];
    /* 清一下信息，防止快速切换有人脸信息缓存 */
    [self.baseManager setOnCameraChange];
    [_photoBtn photoButtonFinishRecord];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //处理进入自定义视频/图片模块的问题，必须停止
    NSLog(@"viewWillDisappear : %@",self);
    [[FURenderKit shareRenderKit] stopInternalCamera];
    [FURenderKit shareRenderKit].glDisplayView = nil;
    
    self.baseManager.cameraPosition = [FURenderKit shareRenderKit].internalCameraSetting.position;
}

#pragma  mark -  UI
- (FUGLDisplayView *)renderView {
    if (!_renderView) {
        /* opengl */
        _renderView = [[FUGLDisplayView alloc] initWithFrame:self.view.bounds];
        _renderView.layer.masksToBounds = YES;
        [self.view addSubview:_renderView];
        [_renderView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.right.equalTo(self.view);
             if (@available(iOS 11.0, *)) {
                 make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                 if(iPhoneXStyle){
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50);
                 }else{
                     make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                 }
             } else {
                 // Fallback on earlier versions
                 make.top.equalTo(self.view.mas_top);
                 make.bottom.equalTo(self.view.mas_bottom);
             }
            
            make.left.right.equalTo(self.view);
         }];
    }
    return _renderView;
}

-(void)setupSubView{
    /* 顶部按钮 */
    _headButtonView = [[FUHeadButtonView alloc] init];
    _headButtonView.delegate = self;
    _headButtonView.selectedImageBtn.hidden = YES;
    [self.view addSubview:_headButtonView];
    [_headButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    /* bugly信息 */
    _buglyLabel = [[UILabel alloc] init];
    _buglyLabel.layer.masksToBounds = YES;
    _buglyLabel.layer.cornerRadius = 5;
    _buglyLabel.numberOfLines = 0;
    _buglyLabel.backgroundColor = [UIColor darkGrayColor];
    _buglyLabel.textColor = [UIColor whiteColor];
    _buglyLabel.alpha = 0.74;
    _buglyLabel.font = [UIFont systemFontOfSize:15];
    _buglyLabel.hidden = YES;
    _buglyLabel.text = @" resolution:\n  720*1280\n fps: 30 \n render time:\n  10ms";
    [self.view addSubview:_buglyLabel];
    [_buglyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headButtonView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(100);
    }];
    
    /* 曝光度指示器 */
    _lightingView = [[FULightingView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    _lightingView.center = CGPointMake(self.view.frame.size.width - 20, self.view.frame.size.height / 2 - 60);
    [self.view addSubview:_lightingView];
    _lightingView.delegate = self;
    _lightingView.hidden = YES;
    _lightingView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    /* 点击校准知识 */
    _adjustImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_校准"]];
    _adjustImage.center = self.view.center;
    _adjustImage.hidden = YES;
    [self.renderView addSubview:_adjustImage];
    
    /* 未检测到人脸提示 */
    _noTrackLabel = [[UILabel alloc] init];
    _noTrackLabel.textColor = [UIColor whiteColor];
    _noTrackLabel.font = [UIFont systemFontOfSize:17];
    _noTrackLabel.textAlignment = NSTextAlignmentCenter;
    _noTrackLabel.text = FUNSLocalizedString(@"No_Face_Tracking", @"未检测到人脸");
    _noTrackLabel.hidden = YES;
    [self.view addSubview:_noTrackLabel];
    [_noTrackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(22);
    }];
    
    /* 额外操作提示 */
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:32];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = @"张张嘴";
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noTrackLabel.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(32);
    }];
    
    /* 录制按钮 */
    _photoBtn = [[FUPhotoButton alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
    [_photoBtn setImage:[UIImage imageNamed:@"camera_btn_camera_normal"] forState:UIControlStateNormal];
    if(iPhoneXStyle){
        _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 85 - 50);
    }else{
        _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 85 - 20);
    }
    
    _photoBtn.delegate = self;
    [self.view addSubview:_photoBtn];
    
    /* 默认选中720P index = 1 */
    _selIndex = self.model.type == FULiveModelTypeQSTickers ? 0 : 1;
}


-(void)setupLightingValue{
    //设置默认调节的区间
    self.lightingView.slider.minimumValue = -2;
    self.lightingView.slider.maximumValue = 2;
    self.lightingView.slider.value = 0;
}

#pragma  mark -  UI事件
- (void)touchScreenAction:(UITapGestureRecognizer *)tap {
    if (tap.view == self.renderView) {
        // 聚焦
        if (self.adjustImage.hidden) {
            self.adjustImage.hidden = NO ;
            self.lightingView.hidden = NO ;
        }
        /* 先找人脸对焦模式 */
//        FUCaptureCameraFocusModelAutoFace,
//        /* 固定点对焦模式 */
//        FUCaptureCameraFocusModelChangeless
        [self.mCamera cameraChangeModle:FUCaptureCameraFocusModelChangeless];
        CGPoint center = [tap locationInView:self.renderView];
  
        // UI
        adjustTime = CFAbsoluteTimeGetCurrent() ;
        self.adjustImage.center = center ;
        self.adjustImage.transform = CGAffineTransformIdentity ;
        [UIView animateWithDuration:0.3 animations:^{
            self.adjustImage.transform = CGAffineTransformMakeScale(0.67, 0.67) ;
        }completion:^(BOOL finished) {
            [self hiddenAdjustViewWithTime:1.0];
        }];
       
        if (self.renderView.contentMode == FUGLDisplayViewContentModeScaleAspectFill) {
                float scal2 = imageH/imageW;
                float apaceLead = (self.renderView.bounds.size.height / scal2 - self.renderView.bounds.size.width )/2;
                float imagecW = self.renderView.bounds.size.width + 2 * apaceLead;
                center.x = center.x + apaceLead;
            
            if (center.y > 0) {
                CGPoint point = CGPointMake(center.y/self.renderView.bounds.size.height, self.mCamera.isFrontCamera ? center.x/imagecW : 1 - center.x/imagecW);
                [self.mCamera focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:point monitorSubjectAreaChange:YES];
                    NSLog(@"手动曝光点-----%@",NSStringFromCGPoint(point));
            }
        }else if(self.renderView.contentMode == FUGLDisplayViewContentModeScaleAspectFit){
            float scal2 = imageH/imageW;
            float apaceTOP = (self.renderView.bounds.size.height - self.renderView.bounds.size.width * scal2)/2;
            float imagecH = self.renderView.bounds.size.height - 2 * apaceTOP;
            center.y = center.y - apaceTOP;
        
            if (center.y > 0) {
                CGPoint point = CGPointMake(center.y/imagecH, self.mCamera.isFrontCamera ? center.x/self.renderView.bounds.size.width : 1 - center.x/self.renderView.bounds.size.width);
                [self.mCamera focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:point monitorSubjectAreaChange:YES];
                NSLog(@"手动曝光点-----%@",NSStringFromCGPoint(point));
            }
        }else{
            CGPoint point = CGPointMake(center.y/self.renderView.bounds.size.height, self.mCamera.isFrontCamera ? center.x/self.renderView.bounds.size.width : 1 - center.x/self.renderView.bounds.size.width);
            [self.mCamera focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:point monitorSubjectAreaChange:YES];
            NSLog(@"手动曝光点-----%@",NSStringFromCGPoint(point));
        }

    }
}

#pragma mark -  Loading

-(FUCaptureCamera *)mCamera {
    if (!_mCamera) {
        _mCamera = [FURenderKit shareRenderKit].captureCamera;
    }
    return _mCamera;
}

-(UIImage *)captureImage{
    mCaptureImage = nil;
    semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return mCaptureImage;
    
}

#pragma  mark -  FUHeadButtonViewDelegate

-(void)headButtonViewBackAction:(UIButton *)btn{
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    [FURenderKit shareRenderKit].glDisplayView = nil;
    [self.baseManager releaseItem];
    [self.baseManager updateBeautyCache];
    NSLog(@"~~~~~~~~~业务层进入关闭内部相机方法");
//    [FURenderKit shareRenderKit].pause = YES;
    [[FURenderKit shareRenderKit] stopInternalCamera];
    //分别率还原成720 * 1080
    [FURenderKit shareRenderKit].internalCameraSetting.sessionPreset = AVCaptureSessionPreset1280x720;
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_semaphore_signal(signal);
}

-(void)headButtonViewSegmentedChange:(UISegmentedControl *)sender {
    int foramt = [FURenderKit shareRenderKit].internalCameraSetting.format == kCVPixelFormatType_32BGRA ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:kCVPixelFormatType_32BGRA;
    [FURenderKit shareRenderKit].internalCameraSetting.format = foramt;
}

-(void)headButtonViewSelImageAction:(UIButton *)btn{
    
    if ([self onlyJumpImage]) {
        [self fuPopupMenuDidSelectedImage];
        return;
    }
    
    if (self.canPushImageSelView) {
        [FUPopupMenu showRelyOnView:btn frame:CGRectMake(17, CGRectGetMaxY(self.headButtonView.frame) + 1 , 340, 132) defaultSelectedAtIndex:_selIndex onlyTop:NO delegate:self];
    } else {
        if (self.model.type == FULiveModelTypeQSTickers) {
            // 精品贴纸特殊处理
            [FUPopupMenu showRelyOnView:btn frame:CGRectMake(17, CGRectGetMaxY(self.headButtonView.frame) + 1, 340, 80) defaultSelectedAtIndex:_selIndex onlyTop:YES dataSource:@[@"720x1280", @"1080x1920"] delegate:self];
        } else {
            [FUPopupMenu showRelyOnView:btn frame:CGRectMake(17, CGRectGetMaxY(self.headButtonView.frame) + 1 , 340, 80) defaultSelectedAtIndex:_selIndex onlyTop:YES delegate:self];
        }
    }
}

-(void)headButtonViewBuglyAction:(UIButton *)btn{
    self.buglyLabel.hidden = !self.buglyLabel.hidden;
}

-(void)headButtonViewSwitchAction:(UIButton *)sender{
    sender.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES ;
    });
    if (![self.mCamera supportsAVCaptureSessionPreset:sender.selected]) {//硬件不支持 降低一个分辨率
        _selIndex = _selIndex - 1;
        [self fuPopupMenuDidSelectedAtIndex:_selIndex];
    }
    
     [self.mCamera changeCameraInputDeviceisFront:sender.selected];
    [FURenderKit shareRenderKit].internalCameraSetting.position = self.mCamera.isFrontCamera?AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;
    /**切换摄像头要调用此函数*/
    [self.baseManager setOnCameraChange];
    sender.selected = !sender.selected ;
}
static CFAbsoluteTime adjustTime = 0 ;
#pragma mark - FULightingViewDelegate
-(void)lightingViewValueDidChange:(float)value {
    adjustTime = CFAbsoluteTimeGetCurrent() ;
    [self hiddenAdjustViewWithTime:1.3];
    [self.mCamera setExposureValue:value];
}

- (void)hiddenAdjustViewWithTime:(float)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (CFAbsoluteTimeGetCurrent() - adjustTime > 1.29) {
            self.adjustImage.hidden = YES ;
            self.lightingView.hidden = YES ;
        }
    });
}

#pragma mark -  PhotoButtonDelegate

/*  拍照  */
- (void)takePhoto {
    [self controlEventWithInterval:0.1 queue:dispatch_get_main_queue() controlEventBlock:^{
        UIImage *image = [FURenderKit captureImage];
        if (image) {
            [self takePhotoToSave:image];
        }
    }];
}

-(void)takePhotoToSave:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/*  开始录像    */
- (void)startRecord {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateString]];
    [FURenderKit startRecordVideoWithFilePath:videoPath];
}

/*  停止录像    */
- (void)stopRecord {
       __weak typeof(self)weakSelf  = self ;
    [FURenderKit stopRecordVideoComplention:^(NSString * _Nonnull filePath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, weakSelf, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:FUNSLocalizedString(@"保存视频失败", nil)];
        
    }else{
        [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"视频已保存到相册", nil)];
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:FUNSLocalizedString(@"保存图片失败", nil)];
    }else{
        [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"图片已保存到相册", nil)];
    }
}

- (FUImageOrientation)transfornOrientation:(AVCaptureVideoOrientation)orientation {
    switch (orientation) {
        case AVCaptureVideoOrientationPortrait:
            return FUImageOrientationUP;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            return FUImageOrientationDown;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            return FUImageOrientationRight;
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
            return FUImageOrientationLeft;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

#pragma mark - FUCameraDelegate
static int rate = 0;
static NSTimeInterval totalRenderTime = 0;
static NSTimeInterval oldTime = 0;
static NSTimeInterval startTime = 0;
// 使用内部相机时，即将处理图像时输入回调
- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput {
    imageW = CVPixelBufferGetWidth(renderInput.pixelBuffer);
    imageH = CVPixelBufferGetHeight(renderInput.pixelBuffer);
    [self.baseManager updateBeautyBlurEffect];
    startTime = [[NSDate date] timeIntervalSince1970];
}

// 使用内部相机时，处理图像后的输出回调
- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput {
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    totalRenderTime += endTime - startTime;
    rate ++;
    CVPixelBufferRef pixelBuffer = renderOutput.pixelBuffer;
    [self updateVideoParametersText:endTime bufferRef:pixelBuffer];
    /* 拍照抓图 */
    if (!mCaptureImage && semaphore) {
        mCaptureImage = [FUImageHelper imageFromPixelBuffer:pixelBuffer];
        dispatch_semaphore_signal(semaphore);
    }
    
    [self autoFocus];
    /**判断是否检测到人脸*/
    [self displayPromptText];
   
}

// 使用内部相机时，内部是否进行render处理，返回NO，将直接输出原图。
- (BOOL)renderKitShouldDoRender{
    return !_openComp;
}


//-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
//
//    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
//    imageW = CVPixelBufferGetWidth(pixelBuffer);
//    imageH = CVPixelBufferGetHeight(pixelBuffer);
//    NSTimeInterval startTime =  [[NSDate date] timeIntervalSince1970];
//
//
//    if(!_openComp){//按住对比，不处理
//        FURenderInput *input = [[FURenderInput alloc] init];
//        input.pixelBuffer = pixelBuffer;
////        input.renderConfig.gravityEnable = YES; //开启内部重力感应
////        input.renderConfig.imageOrientation = [self transfornOrientation:[self.mCamera videoOrientation]];
//        FURenderOutput *outPut = [[FURenderKit shareRenderKit] renderWithInput:input];
//        pixelBuffer = outPut.pixelBuffer;
//    }
//    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
//    /* renderTime */
//    totalRenderTime += endTime - startTime;
//    rate ++;
//    [self updateVideoParametersText:endTime bufferRef:pixelBuffer];
//    /* 拍照抓图 */
//    if (!mCaptureImage && semaphore) {
//        mCaptureImage = [FUImageHelper imageFromPixelBuffer:pixelBuffer];
//        dispatch_semaphore_signal(semaphore);
//    }
//
//    [self.renderView displayPixelBuffer:pixelBuffer];
//    /**判断是否检测到人脸*/
//     [self displayPromptText];
//}

#pragma mark - FUCameraDataSource
-(CGPoint)fuCaptureFaceCenterInImage:(FUCaptureCamera *)camera{
    return self.baseManager.faceCenter;
}

#pragma  mark -  刷新bugly text
// 更新视频参数栏
-(void)updateVideoParametersText:(NSTimeInterval)startTime bufferRef:(CVPixelBufferRef)pixelBuffer{
    if (startTime - oldTime >= 1) {//一秒钟计算平均值
        oldTime = startTime;
        int diaplayRate = rate;
        NSTimeInterval diaplayRenderTime = totalRenderTime;
        
        float w = CVPixelBufferGetWidth(pixelBuffer);
        float h = CVPixelBufferGetHeight(pixelBuffer);
        NSString *ratioStr = [NSString stringWithFormat:@"%.0fX%.0f", w, h];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.buglyLabel.text = [NSString stringWithFormat:@" resolution:\n  %@\n fps: %d \n render time:\n  %.0fms",ratioStr,diaplayRate,diaplayRenderTime * 1000.0 / diaplayRate];
        });
        totalRenderTime = 0;
        rate = 0;
    }
}

#pragma  mark -  FUPopupMenuDelegate

-(void)fuPopupMenuDidSelectedAtIndex:(NSInteger)index{
    [self.baseManager setOnCameraChange];
    BOOL ret = NO;
    NSInteger old = _selIndex;
    _selIndex = (int)index;
    
    switch (index) {
        case 0:
            ret = self.model.type == FULiveModelTypeQSTickers ? [self.mCamera changeSessionPreset:AVCaptureSessionPreset1280x720] : [self.mCamera changeSessionPreset:AVCaptureSessionPreset640x480];
            break;
        case 1:
            ret = self.model.type == FULiveModelTypeQSTickers ? [self.mCamera changeSessionPreset:AVCaptureSessionPreset1920x1080] : [self.mCamera changeSessionPreset:AVCaptureSessionPreset1280x720];
            break;
        case 2:
            ret = [self.mCamera changeSessionPreset:AVCaptureSessionPreset1920x1080];
            break;
        default:
            break;
    }
    
    if (!ret) {
        NSLog(@"摄像机不支持");
        [SVProgressHUD showInfoWithStatus:@"摄像机不支持"];
        _selIndex = (int)old;
    }
}

-(void)fuPopupMenuDidSelectedImage {
    //更新美颜参数,使得自定义照片和视频可以直接使用已经设置好的参数。
    [self.baseManager updateBeautyCache];
    
    [self didClickSelPhoto];
}

#pragma  mark -  子类差异实现

-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)displayPromptText {
    BOOL isHaveFace = [self.baseManager faceTrace];
    dispatch_async(dispatch_get_main_queue(), ^{
       self.noTrackLabel.text = FUNSLocalizedString(@"No_Face_Tracking",nil);
       self.noTrackLabel.hidden = isHaveFace;
    });
}

//自动对焦
- (void)autoFocus {
    BOOL isHaveFace = [self.baseManager faceTrace];
    CGPoint center = CGPointMake(0.5, 0.5);
    if (isHaveFace) {
        center = [self cameraFocusAndExposeFace];
    }
    self.baseManager.faceCenter = center; //在渲染线程获取人脸中心点是准确的，保存起来，让其他线程去访问。
}


-(CGPoint)cameraFocusAndExposeFace {
   CGPoint center = [self.baseManager getFaceCenterInFrameSize:CGSizeMake(imageW, imageH)];
   return  CGPointMake(center.y, self.mCamera.isFrontCamera ? center.x : 1 - center.x);
}

-(BOOL)onlyJumpImage{
    return NO;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"*******************self == %@ didReceiveMemoryWarning *******************",self);
}

-(void)dealloc{
    NSLog(@"----界面销毁");
}


@end
