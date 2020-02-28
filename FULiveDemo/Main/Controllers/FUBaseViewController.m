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
#import "FULightingView.h"
#import "FUSaveViewController.h"
#import "FUEditImageViewController.h"
#import "FUImageHelper.h"
#import "FURenderer.h"
#import "FUSelectedImageController.h"
#import <CoreMotion/CoreMotion.h>

#import "FUPopupMenu.h"

typedef NS_ENUM( NSInteger, FUCameraFocusModel) {
    FUCameraModelAutoFace,
    FUCameraModelChangeless
};

@interface FUBaseViewController ()<
FUCameraDelegate,
FUPhotoButtonDelegate,
FUItemsViewDelegate,
FULightingViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,
FUPopupMenuDelegate,
UIGestureRecognizerDelegate
>
{
    dispatch_semaphore_t signal;
    dispatch_semaphore_t semaphore;
    UIImage *mCaptureImage;
    float imageW ;
    float imageH;
}
@property (strong, nonatomic) FUCamera *mCamera ;
//@property (strong, nonatomic) FUOpenGLView *renderView;
//@property (strong, nonatomic) FUItemsView *itemsView;

@property (strong, nonatomic) UILabel *buglyLabel;
@property (strong, nonatomic) FULightingView *lightingView ;
@property (strong, nonatomic) UIImageView *adjustImage;
/* 分辨率 选中第几个项 */
@property (assign, nonatomic) int selIndex;
/* 当前 */
@property (nonatomic, assign) int orientation;

/* 监听屏幕方向 */
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic) FUCameraFocusModel cameraFocusModel;
@end

@implementation FUBaseViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupSubView];
//    self.view.backgroundColor = [UIColor whiteColor];
    /* 美颜道具 */
    [[FUManager shareManager] loadFilter];
    
    //重置曝光值为0
    [self.mCamera setExposureValue:0];
    _cameraFocusModel = FUCameraModelAutoFace;
    [self setupLightingValue];
    /* 道具切信号 */
    signal = dispatch_semaphore_create(1);
    /* 后台监听 */
    [self addObserver];
    /* 同步 */
    [[FUManager shareManager] setAsyncTrackFaceEnable:NO];
    /* 最大识别人脸数 */
    [FUManager shareManager].enableMaxFaces = self.model.maxFace == 4;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScreenAction:)];
    tap.delegate = self;
    [self.renderView addGestureRecognizer:tap];
    self.canPushImageSelView = YES;
//    self.renderView.contentMode = FUOpenGLViewContentModeScaleAspectFit;
   
    if ([self needSetMultiSamples]) {
        fuSetMultiSamples(4);
    }else{
        fuSetMultiSamples(0);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mCamera startCapture];
    [_mCamera changeSessionPreset:AVCaptureSessionPreset1280x720];
    /* 监听屏幕方向 */
    [self startListeningDirectionOfDevice];
    
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBeauty];
        /* 单独美颜点位点位*/
        [FURenderer itemSetParam:handle withName:@"landmarks_type" value:@(FUAITYPE_FACEPROCESSOR)];
    });
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.mCamera resetFocusAndExposureModes];
    [self.mCamera stopCapture];
    
    /* 清一下信息，防止快速切换有人脸信息缓存 */
    [FURenderer onCameraChange];
    /* 监听屏幕方向 */
    [self stopListeningDirectionOfDevice];
}

#pragma  mark -  UI

-(void)setupSubView{
    /* opengl */
    _renderView = [[FUOpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_renderView];
    
    /* 顶部按钮 */
    _headButtonView = [[FUHeadButtonView alloc] init];
    _headButtonView.delegate = self;
    _headButtonView.selectedImageBtn.hidden = YES;
    [self.view addSubview:_headButtonView];
    [_headButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
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
    [self.view addSubview:_adjustImage];
    
    /* 未检测到人脸提示 */
    _noTrackLabel = [[UILabel alloc] init];
    _noTrackLabel = [[UILabel alloc] init];
    _noTrackLabel.textColor = [UIColor whiteColor];
    _noTrackLabel.font = [UIFont systemFontOfSize:17];
    _noTrackLabel.textAlignment = NSTextAlignmentCenter;
    _noTrackLabel.text = NSLocalizedString(@"No_Face_Tracking", @"未检测到人脸");
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
    _selIndex = 1;
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
        
        _cameraFocusModel = FUCameraModelChangeless;
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

        if (self.renderView.contentMode == FUOpenGLViewContentModeScaleToFill) {
                float scal2 = imageH/imageW;
                
                float apaceLead = (self.view.bounds.size.height / scal2 - self.view.bounds.size.width )/2;
                float imagecW = self.view.bounds.size.width + 2 * apaceLead;
                center.x = center.x + apaceLead;
            
            if (center.y > 0) {
                CGPoint point = CGPointMake(center.y/self.view.bounds.size.height, self.mCamera.isFrontCamera ? center.x/imagecW : 1 - center.x/imagecW);
                [self.mCamera focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:point monitorSubjectAreaChange:YES];
            }
        }else if(self.renderView.contentMode == FUOpenGLViewContentModeScaleAspectFit){

            float scal2 = imageH/imageW;
            
            float apaceTOP = (self.view.bounds.size.height - self.view.bounds.size.width * scal2)/2;
            float imagecH = self.view.bounds.size.height - 2 * apaceTOP;
            center.y = center.y - apaceTOP;
        
            if (center.y > 0) {
                CGPoint point = CGPointMake(center.y/imagecH, self.mCamera.isFrontCamera ? center.x/self.view.bounds.size.width : 1 - center.x/self.view.bounds.size.width);
                [self.mCamera focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:point monitorSubjectAreaChange:YES];
            }


        }else{
            CGPoint point = CGPointMake(center.y/self.view.bounds.size.height, self.mCamera.isFrontCamera ? center.x/self.view.bounds.size.width : 1 - center.x/self.view.bounds.size.width);
            [self.mCamera focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:point monitorSubjectAreaChange:YES];
        }

    }
}

#pragma mark -  Loading

-(FUCamera *)mCamera {
    if (!_mCamera) {
        _mCamera = [[FUCamera alloc] init];
        _mCamera.delegate = self ;
    }
    return _mCamera ;
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
    [self.mCamera stopCapture];
    [[FUManager shareManager] onCameraChange];
    [self.navigationController popViewControllerAnimated:YES];
    
    dispatch_semaphore_signal(signal);
}

-(void)headButtonViewSegmentedChange:(UISegmentedControl *)sender{
    _mCamera.captureFormat = _mCamera.captureFormat == kCVPixelFormatType_32BGRA ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:kCVPixelFormatType_32BGRA;
}

-(void)headButtonViewSelImageAction:(UIButton *)btn{
    
    if ([self onlyJumpImage]) {
        [self fuPopupMenuDidSelectedImage];
        return;
    }
    if (self.canPushImageSelView) {
        [FUPopupMenu showRelyOnView:btn frame:CGRectMake(17, CGRectGetMaxY(self.headButtonView.frame) + 1 , 340, 132) defaultSelectedAtIndex:_selIndex onlyTop:NO delegate:self];
    }else{
        [FUPopupMenu showRelyOnView:btn frame:CGRectMake(17, CGRectGetMaxY(self.headButtonView.frame) + 1 , 340, 80) defaultSelectedAtIndex:_selIndex onlyTop:YES delegate:self];
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
    /**切换摄像头要调用此函数*/
    [[FUManager shareManager] onCameraChange];
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
- (void)takePhoto{
    //拍照效果
    self.photoBtn.enabled = NO;
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.bounds];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    whiteView.alpha = 0.3;
    [UIView animateWithDuration:0.1 animations:^{
        whiteView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            whiteView.alpha = 0;
        } completion:^(BOOL finished) {
            self.photoBtn.enabled = YES;
            [whiteView removeFromSuperview];
        }];
    }];
    
    
    UIImage *image = [self captureImage];
    if (image) {
        [self takePhotoToSave:image];
    }
}

-(void)takePhotoToSave:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/*  开始录像    */
- (void)startRecord {
    [self.mCamera startRecord];
}

/*  停止录像    */
- (void)stopRecord {
       __weak typeof(self)weakSelf  = self ;
    [self.mCamera stopRecordWithCompletionHandler:^(NSString *videoPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, weakSelf, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存视频失败", nil)];
        
    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"视频已保存到相册", nil)];
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存图片失败", nil)];
    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片已保存到相册", nil)];
    }
}

#pragma mark - FUCameraDelegate
static int rate = 0;
static NSTimeInterval totalRenderTime = 0;
static  NSTimeInterval oldTime = 0;
static int faceframe = 60;
-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    imageW = CVPixelBufferGetWidth(pixelBuffer);
    imageH = CVPixelBufferGetHeight(pixelBuffer);
    NSTimeInterval startTime =  [[NSDate date] timeIntervalSince1970];
    if(!_openComp){//按住对比，不处理
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    }
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    /* renderTime */
    totalRenderTime += endTime - startTime;
    rate ++;
    [self updateVideoParametersText:endTime bufferRef:pixelBuffer];
    /* 拍照抓图 */
    if (!mCaptureImage && semaphore) {
        mCaptureImage = [FUImageHelper imageFromPixelBuffer:pixelBuffer];
        dispatch_semaphore_signal(semaphore);
    }
 
    [self cameraFocusAndExpose];
    
    [self.renderView displayPixelBuffer:pixelBuffer];
//    [self.renderView displayPixelBuffer:pixelBuffer withLandmarks:cetera count:2 MAX:NO];
    /**判断是否检测到人脸*/
     [self displayPromptText];
}

-(void)cameraSubjectAreaDidChange{
    _cameraFocusModel = FUCameraModelAutoFace;
}

#pragma  mark -  人脸曝光逻辑
//主题区域发生了变化，60帧人脸检测对焦人脸
-(void)cameraFocusAndExpose{
    if (_cameraFocusModel == FUCameraModelAutoFace) {
        BOOL isHaveFace = [[FUManager shareManager] isTracking];
        if (isHaveFace) {
            [self cameraFocusAndExposeFace];
        }
        faceframe --;
        if (faceframe == 0) {
            faceframe = 60;
            _cameraFocusModel = FUCameraModelChangeless;
            NSLog(@"------取消人脸对焦----");
        }
    }
}

-(void)cameraFocusAndExposeFace{
    NSLog(@"------人脸对焦----");
    static float posterLandmarks[239* 2];
    int ret = [FURenderer getFaceInfo:0 name:@"landmarks" pret:posterLandmarks number:75* 2];
     if (ret == 0) {
        ret = [FURenderer getFaceInfo:0 name:@"landmarks_new" pret:posterLandmarks number:239* 2];
         if (ret == 0) {
             memset(posterLandmarks, 0, sizeof(float)*239* 2);
         }
     }
    
    CGPoint center = [self getCenterFromeLandmarks:posterLandmarks];
    
    if (center.y > 0) {
        CGPoint point = CGPointMake(center.y/imageH, self.mCamera.isFrontCamera ? center.x/imageW : 1 - center.x/imageW);
        [self.mCamera focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:point monitorSubjectAreaChange:YES];
    }
    
}


-(CGPoint)getCenterFromeLandmarks:(float *)Landmarks{
    float min_x = 10000,min_y =10000,max_x =0 ,max_y=0;
    for(int i = 0;i<75;i++){
        min_x = MIN(min_x,Landmarks[i*2+0]);
        min_y = MIN(min_y,Landmarks[i*2+1]);
        max_x = MAX(max_x,Landmarks[i*2+0]);
        max_y = MAX(max_y,Landmarks[i*2+1]);
    }
    CGPoint center=CGPointMake((min_x + max_x)/2.0, (min_y + max_y)/2.0);
    return center;
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
    [FURenderer onCameraChange];
    BOOL ret = NO;
    _selIndex = (int)index;
    switch (index) {
        case 0:
            ret = [self.mCamera changeSessionPreset:AVCaptureSessionPreset640x480];
            break;
        case 1:
            ret = [self.mCamera changeSessionPreset:AVCaptureSessionPreset1280x720];
            break;
        case 2:
            ret = [self.mCamera changeSessionPreset:AVCaptureSessionPreset1920x1080];
            break;
        default:
            break;
    }
    
    if (!ret) {
        [SVProgressHUD showInfoWithStatus:@"摄像机不支持"];
    }
}

-(void)fuPopupMenuDidSelectedImage{
    [self didClickSelPhoto];
}

#pragma  mark -  子类差异实现

-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)displayPromptText{
    BOOL isHaveFace = [[FUManager shareManager] isTracking];
    dispatch_async(dispatch_get_main_queue(), ^{
       self.noTrackLabel.text = NSLocalizedString(@"No_Face_Tracking",nil);
       self.noTrackLabel.hidden = isHaveFace;
    }) ;
}

/* 该功能，是否需要开启多重采样 */
-(BOOL)needSetMultiSamples{
    return NO;
}
     

-(BOOL)onlyJumpImage{
    return NO;
}

#pragma mark -  Observer

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive{
    if (self.navigationController.visibleViewController == self) {
        [self.mCamera stopCapture];
//        self.mCamera = nil;
    }
}


- (void)didBecomeActive{
    if (self.navigationController.visibleViewController == self) {
        [self.mCamera startCapture];
        _cameraFocusModel = FUCameraModelAutoFace;
    }
}



#pragma  mark -  方向监听

/// 开启屏幕旋转的检测
- (void)startListeningDirectionOfDevice {
    if (self.motionManager == nil) {
        self.motionManager = [[CMMotionManager alloc] init];
    }
    self.motionManager.deviceMotionUpdateInterval = 0.3;
    
    // 判断设备传感器是否可用
    if (self.motionManager.deviceMotionAvailable) {
        // 启动设备的运动更新，通过给定的队列向给定的处理程序提供数据。
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        [self setMotionManager:nil];
    }
}

- (void)stopListeningDirectionOfDevice {
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {

    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    int orientation = 0;
    
    if (fabs(y) >= fabs(x)) {// 竖屏
        if (y < 0) {
            orientation = 0;
        }
        else {
            orientation = 2;
        }
    }
    else { // 横屏
        if (x < 0) {
           orientation = 1;
        }
        else {
           orientation = 3;
        }
    }
    
    if (orientation != _orientation) {
        self.orientation = orientation;
    }
    
}

-(void)setOrientation:(int)orientation{
    _orientation = orientation;
}



-(void)dealloc{
    [self stopListeningDirectionOfDevice];
    NSLog(@"----界面销毁");
}


@end
