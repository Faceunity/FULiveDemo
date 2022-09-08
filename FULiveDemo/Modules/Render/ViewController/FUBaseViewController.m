//
//  FUBaseViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBaseViewController.h"
#import "FUSelectedImageController.h"

#import "FUPopupMenu.h"

#import "NSObject+economizer.h"

#import <FURenderKit/FURenderIO.h>
#import <FURenderKit/FUImageHelper.h>
#import <CoreMotion/CoreMotion.h>
#import <SVProgressHUD.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface FUBaseViewController ()<
FURenderKitDelegate,
FUPhotoButtonDelegate,
FULightingViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
FUPopupMenuDelegate,
FUCaptureCameraDataSource
>
{
    dispatch_semaphore_t semaphore;
    dispatch_semaphore_t signal;
    UIImage *mCaptureImage;
    float imageW ;
    float imageH;
}

@property (nonatomic, strong) FUBaseViewControllerManager *baseManager;
@property (nonatomic, strong) FUCaptureCamera *mCamera;
@property (nonatomic, strong) FUHeadButtonView *headButtonView;
@property (nonatomic, strong) FUPhotoButton *photoBtn;
@property (nonatomic, strong) FUGLDisplayView *renderView;
@property (nonatomic, strong) FULightingView *lightingView;
@property (nonatomic, strong) UILabel *noTrackLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) BOOL isFromOtherPage;

@property (nonatomic, strong) FUInsetsLabel *buglyLabel;
@property (nonatomic, strong) UIImageView *adjustImage;
/// 选中分辨率索引
@property (nonatomic, assign) int selIndex;
@property (nonatomic, assign) BOOL isCameraRunning;

@end

@implementation FUBaseViewController

#pragma mark - Life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // 加载AI模型
    if (self.necessaryAIModelTypes & FUAIModelTypeFace) {
        [FUManager loadFaceAIModel];
    }
    if (self.necessaryAIModelTypes & FUAIModelTypeHuman) {
        [FUManager loadHumanAIModel];
    }
    if (self.necessaryAIModelTypes & FUAIModelTypeHand) {
        [FUManager loadHandAIModel];
    }
    // 设置设备性能相关细项
    [[FUManager shareManager] setDevicePerformanceDetails];
    
    self.baseManager = [[FUBaseViewControllerManager alloc] init];
    if (self.needsLoadingBeauty) {
        [self.baseManager loadItem];
    }
    // 需要音频输入输出
    [FURenderKit shareRenderKit].internalCameraSetting.needsAudioTrack = YES;
    [[FURenderKit shareRenderKit] startInternalCamera];
    _isCameraRunning = YES;
    [FURenderKit shareRenderKit].captureCamera.dataSource = self;
    //把渲染的View 赋值给 FURenderKit，这样会在FURenderKit内部自动渲染
    [FURenderKit shareRenderKit].glDisplayView = self.renderView;
    [FURenderKit shareRenderKit].delegate = self;
    
    [self.baseManager setMaxFaces:4];
    
    [self setupSubView];
    
    self.view.backgroundColor = [UIColor colorWithRed:17/255.0 green:18/255.0 blue:38/255.0 alpha:1.0];

    [self setupLightingValue];
    
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
        [FURenderKit shareRenderKit].internalCameraSetting.position = self.baseManager.cameraPosition;
        [FURenderKit shareRenderKit].glDisplayView = self.renderView;
        _isCameraRunning = YES;
        if (self.needsLoadingBeauty) {
            [self.baseManager loadItem];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _isFromOtherPage = YES;
    [self.mCamera resetFocusAndExposureModes];
    /* 清一下信息，防止快速切换有人脸信息缓存 */
    [self.baseManager setOnCameraChange];
    [self.photoBtn photoButtonFinishRecord];
    //处理进入自定义视频/图片模块的问题，必须停止
    NSLog(@"viewWillDisappear : %@",self);
    
    if (_isCameraRunning) {
        [[FURenderKit shareRenderKit] stopInternalCamera];
        _isCameraRunning  = NO;
        [FURenderKit shareRenderKit].glDisplayView = nil;
    }
    
    self.baseManager.cameraPosition = [FURenderKit shareRenderKit].internalCameraSetting.position;
    
}

-(void)dealloc{
    NSLog(@"----界面销毁");
}


#pragma  mark -  UI

-(void)setupSubView{
    /* 顶部按钮 */
    _headButtonView = [[FUHeadButtonView alloc] init];
    _headButtonView.delegate = self;
    _headButtonView.selectedImageBtn.hidden = YES;
    [self.view addSubview:_headButtonView];
    [self.headButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    /* bugly信息 */
    _buglyLabel = [[FUInsetsLabel alloc] initWithFrame:CGRectZero insets:UIEdgeInsetsMake(5, 5, 5, 5)];
    _buglyLabel.layer.masksToBounds = YES;
    _buglyLabel.layer.cornerRadius = 5;
    _buglyLabel.numberOfLines = 0;
    _buglyLabel.backgroundColor = [UIColor darkGrayColor];
    _buglyLabel.textColor = [UIColor whiteColor];
    _buglyLabel.alpha = 0.74;
    _buglyLabel.font = [UIFont systemFontOfSize:13];
    _buglyLabel.hidden = YES;
    [self.view addSubview:_buglyLabel];
    [_buglyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headButtonView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(90);
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
        make.top.equalTo(_noTrackLabel.mas_bottom);
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
    _selIndex = self.type == FUModuleTypeQualityTicker ? 0 : 1;
}

#pragma mark - Private methods

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
    return CGPointMake(center.y, [FURenderKit shareRenderKit].internalCameraSetting.position == AVCaptureDevicePositionFront ? center.x : 1 - center.x);
}

-(void)setupLightingValue {
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
    return [FURenderKit shareRenderKit].captureCamera;
}

-(UIImage *)captureImage{
    mCaptureImage = nil;
    semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return mCaptureImage;
}

#pragma  mark -  FUHeadButtonViewDelegate

-(void)headButtonViewSegmentedChange:(UISegmentedControl *)sender {
    int format = [FURenderKit shareRenderKit].internalCameraSetting.format == kCVPixelFormatType_32BGRA ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:kCVPixelFormatType_32BGRA;
    [FURenderKit shareRenderKit].internalCameraSetting.format = format;
}

-(void)headButtonViewSelImageAction:(UIButton *)btn{

    if (!self.needsPresetSelections) {
        [self fuPopupMenuDidSelectedImage];
        return;
    }
    
    if (self.canPushImageSelView) {
        [FUPopupMenu showRelyOnView:btn frame:CGRectMake(17, CGRectGetMaxY(self.headButtonView.frame) + 1 , 340, 132) defaultSelectedAtIndex:_selIndex onlyTop:NO delegate:self];
    } else {
        if (self.type == FUModuleTypeQualityTicker) {
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

#pragma mark - FULightingViewDelegate

static CFAbsoluteTime adjustTime = 0;
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
    NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", FUCurrentDateString()]];
    if (!videoPath) {
        return;
    }
    [FURenderKit startRecordVideoWithFilePath:videoPath];
}

/*  停止录像    */
- (void)stopRecord {
       __weak typeof(self)weakSelf  = self ;
    [FURenderKit stopRecordVideoComplention:^(NSString * _Nonnull filePath) {
        if (!filePath) {
            return;
        }
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

- (FUImageOrientation)transformOrientation:(AVCaptureVideoOrientation)orientation {
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

#pragma mark - FURenderKitDelegate

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
            NSString *buglyString = [NSString stringWithFormat:@"resolution:\n%@\nfps: %d\nrender time:\n%.0fms",ratioStr, diaplayRate, diaplayRenderTime * 1000.0 / diaplayRate];
            self.buglyLabel.text = buglyString;
        });
        totalRenderTime = 0;
        rate = 0;
    }
}

#pragma  mark -  FUPopupMenuDelegate

-(void)headButtonViewBackAction:(UIButton *)btn{
    dispatch_semaphore_signal(signal);
    [[FURenderKit shareRenderKit] stopInternalCamera];
    _isCameraRunning  = NO;
    [FURenderKit shareRenderKit].glDisplayView = nil;
    // 分别率还原成720 * 1080
    [FURenderKit shareRenderKit].internalCameraSetting.sessionPreset = AVCaptureSessionPreset1280x720;
    // 格式还原为kCVPixelFormatType_32BGRA
    [FURenderKit shareRenderKit].internalCameraSetting.format = kCVPixelFormatType_32BGRA;
    [self.baseManager clearItems];
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_semaphore_signal(signal);
}

-(void)fuPopupMenuDidSelectedAtIndex:(NSInteger)index{
    [self.baseManager setOnCameraChange];
    BOOL ret = NO;
    NSInteger old = _selIndex;
    _selIndex = (int)index;
    
    switch (index) {
        case 0:
            ret = self.type == FUModuleTypeQualityTicker ? [self.mCamera changeSessionPreset:AVCaptureSessionPreset1280x720] : [self.mCamera changeSessionPreset:AVCaptureSessionPreset640x480];
            break;
        case 1:
            ret = self.type == FUModuleTypeQualityTicker ? [self.mCamera changeSessionPreset:AVCaptureSessionPreset1920x1080] : [self.mCamera changeSessionPreset:AVCaptureSessionPreset1280x720];
            break;
        case 2:
            ret = [self.mCamera changeSessionPreset:AVCaptureSessionPreset1920x1080];
            break;
        default:
            break;
    }
    
    [FURenderKit shareRenderKit].internalCameraSetting.sessionPreset = self.mCamera.sessionPreset;
    
    if (!ret) {
        NSLog(@"摄像机不支持");
        [SVProgressHUD showInfoWithStatus:@"摄像机不支持"];
        _selIndex = (int)old;
    }
}

-(void)fuPopupMenuDidSelectedImage {
    //更新美颜参数,使得自定义照片和视频可以直接使用已经设置好的参数。
    [self.baseManager updateBeautyCache:NO];
    
    [self didClickSelPhoto];
}

#pragma mark - Overriding

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)needsPresetSelections {
    return YES;
}

- (BOOL)needsLoadingBeauty {
    return YES;
}

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace;
}

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

#pragma mark -  Getters

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

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning {
    NSLog(@"*******************self == %@ didReceiveMemoryWarning *******************",self);
}

@end
