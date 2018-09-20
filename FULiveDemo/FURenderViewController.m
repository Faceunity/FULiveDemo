//
//  FULiveViewController.m
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FURenderViewController.h"
#import "FUOpenGLView.h"
#import "FUCamera.h"
#import "FUManager.h"
#import "FUItemsView.h"
#import "PhotoButton.h"
#import <FUAPIDemoBar/FUAPIDemoBar.h>
#import "FULiveModel.h"
#import "FUMusicPlayer.h"
#import <SVProgressHUD.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FURenderImageViewController.h"

@interface FURenderViewController ()<FUCameraDelegate, PhotoButtonDelegate, FUAPIDemoBarDelegate, FUItemsViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL faceBeautyMode ;
}
@property (weak, nonatomic) IBOutlet FUOpenGLView *renderView;

@property (nonatomic, strong) FUCamera *mCamera ;

@property (weak, nonatomic) IBOutlet FUAPIDemoBar *demoBar;
@property (weak, nonatomic) IBOutlet PhotoButton *photoBtn;
@property (weak, nonatomic) IBOutlet FUItemsView *itemsView;

@property (weak, nonatomic) IBOutlet UIView *buglyView;
@property (weak, nonatomic) IBOutlet UILabel *buglyLabel;
@property (weak, nonatomic) IBOutlet UILabel *noTrackView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabe;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedImageBtn;

@property (weak, nonatomic) IBOutlet UIButton *performanceBtn;
@end

@implementation FURenderViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
    
    self.selectedImageBtn.hidden = !(self.model.type == FULiveModelTypeBeautifyFace || self.model.type == FULiveModelTypeItems) ;
    self.photoBtn.delegate = self ;
    
    faceBeautyMode = self.model.type == FULiveModelTypeBeautifyFace ;
    
    if (faceBeautyMode) {
        
        [self.itemsView removeFromSuperview ];
        self.itemsView = nil ;
        self.performanceBtn.hidden = NO ;
        self.performanceBtn.selected = [FUManager shareManager].performance;
        
        [[FUManager shareManager] loadFilter] ;
        
    }else {
        
        self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
        [self.demoBar removeFromSuperview ];
        self.demoBar = nil ;
        
        self.itemsView.delegate = self ;
        [self.view addSubview:self.itemsView];
        
        
        self.itemsView.itemsArray = self.model.items;
        
        NSString *selectItem = self.model.items.count > 0 ? self.model.items[0] : @"noitem" ;
        
        self.itemsView.selectedItem = selectItem ;
        
        [[FUManager shareManager] loadItem: selectItem];
        
        [[FUManager shareManager] loadFilter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *alertString = [[FUManager shareManager] alertForItem:selectItem];
            self.alertLabel.hidden = alertString == nil ;
            self.alertLabel.text = alertString ;
            
            [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertLabel) object:nil];
            [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:3];
            
            NSString *hint = [[FUManager shareManager] hintForItem:selectItem];
            self.tipLabe.hidden = hint == nil;
            self.tipLabe.text = hint;
            
            [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
            [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:5 ];
        });
    }
    
    [FUManager shareManager].enableMaxFaces = self.model.maxFace == 4;
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            [self.mCamera setCaptureVideoOrientation:AVCaptureVideoOrientationPortrait];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [self.mCamera setCaptureVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self.mCamera setCaptureVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self.mCamera setCaptureVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            break;
            
        default:
            break;
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!faceBeautyMode) {
        
        // 适配 iPhone X
        CGRect frame = self.itemsView.frame ;
        frame.origin = [[[FUManager shareManager] getPlatformtype] isEqualToString:@"iPhone X"] ? CGPointMake(0, self.view.frame.size.height - frame.size.height - 34) : CGPointMake(0, self.view.frame.size.height - frame.size.height) ; ;
        frame.size = CGSizeMake(self.view.frame.size.width, frame.size.height) ;
        self.itemsView.frame = frame ;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (faceBeautyMode) {
        
        [self demoBarSetBeautyDefultParams];
    }else {
        if (!self.itemsView.selectedItem) {
            self.itemsView.selectedItem = [FUManager shareManager].selectedItem ;
        }else {
            [[FUManager shareManager] loadItem:self.itemsView.selectedItem];
        }
    }
    
    if (self.model.type == FULiveModelTypeAnimoji) {
        [[FUManager shareManager] setCalibrating];
        [[FUManager shareManager] loadAnimojiFaxxBundle];
    }
    
    if (self.model.type == FULiveModelTypePortraitDrive || self.model.type == FULiveModelTypeAnimoji) {
        
        [[FUManager shareManager] set3DFlipH];
    }
    if (self.model.type == FULiveModelTypeGestureRecognition) {
        
        [[FUManager shareManager] setLoc_xy_flip];
    }
    
    [self.mCamera startCapture];
    
    if (self.model.type == FULiveModelTypeMusicFilter && ![[FUManager shareManager].selectedItem isEqualToString:@"noitem"]) {
        
        [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
//        [self.mCamera addAudio];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.model.type == FULiveModelTypeMusicFilter) {
        
        [self.mCamera removeAudio ];
        [[FUMusicPlayer sharePlayer] stop];
    }else if (self.model.type == FULiveModelTypeAnimoji) {
        
        [[FUManager shareManager] destoryAnimojiFaxxBundle];
    }
    
    [self.mCamera stopCapture];
    // 清除缓存
    [[FUManager shareManager] onCameraChange];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.demoBar hiddeTopView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (faceBeautyMode) {
        [self.demoBar hiddeTopView];
    }
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.mCamera stopCapture];
    
    [FUManager shareManager].currentModel = nil ;
    
    dispatch_async(self.mCamera.videoCaptureQueue, ^{
        [[FUManager shareManager] destoryItems];
    });
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeCamera:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES ;
    });
    
    [self.mCamera changeCameraInputDeviceisFront:sender.selected];

    /**切换摄像头要调用此函数*/
    [[FUManager shareManager] onCameraChange];

    sender.selected = !sender.selected ;
    
}

- (IBAction)changeCaptureFormat:(UISegmentedControl *)sender {
    
    _mCamera.captureFormat = _mCamera.captureFormat == kCVPixelFormatType_32BGRA ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:kCVPixelFormatType_32BGRA;
}

- (IBAction)showBuglyView:(UIButton *)sender {
     
    self.buglyView.hidden = !self.buglyView.hidden ;
}

#pragma mark --- FUCameraDelegate

-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    
    CFAbsoluteTime startRenderTime = CFAbsoluteTimeGetCurrent();
    
    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    
    CFAbsoluteTime renderTime = (CFAbsoluteTimeGetCurrent() - startRenderTime);
    
    [self.renderView displayPixelBuffer:pixelBuffer];
    
    if (self.model.type == FULiveModelTypeMusicFilter) {
        
        [[FUManager shareManager] musicFilterSetMusicTime];
    }
    
    CFAbsoluteTime frameTime = (CFAbsoluteTimeGetCurrent() - startTime);
    
    
    int frameWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
    int frameHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    CGSize frameSize;
    if (CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32BGRA) {
        frameSize = CGSizeMake(CVPixelBufferGetBytesPerRow(pixelBuffer) / 4, CVPixelBufferGetHeight(pixelBuffer));
    }else{
        frameSize = CGSizeMake(CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer));
    }
    
    NSString *ratioStr = [NSString stringWithFormat:@"%dX%d", frameWidth, frameHeight];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /**判断是否检测到人脸*/
        self.noTrackView.hidden = [[FUManager shareManager] isTracking];
        
        CGFloat fps = 1.0 / frameTime ;
        if (fps > 30) {
            fps = 30 ;
        }
        self.buglyLabel.text = [NSString stringWithFormat:@"resolution:\n %@\nfps: %.0f \nrender time:\n %.0fms", ratioStr, fps, renderTime * 1000.0];
        
        // 根据人脸中心点实时调节摄像头曝光参数及聚焦参数
        CGPoint center = [[FUManager shareManager] getFaceCenterInFrameSize:frameSize];;
        self.mCamera.exposurePoint = CGPointMake(center.y,self.mCamera.isFrontCamera ? center.x:1-center.x);
        
        /** 显示表情校准 **/
        if (self.model.type == FULiveModelTypeAnimoji) {
            if ([[FUManager shareManager] isCalibrating]) {
                
                if (self.alertLabel.hidden) {
                    self.alertLabel.alpha = 0.0;
                    self.alertLabel.hidden = NO;
                    self.alertLabel.text = @"表情校准中..." ;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.alertLabel.alpha = .55;
                    }];
                }
            }else{
                self.alertLabel.hidden = YES;
            }
        }
    }) ;
}

#pragma mark --- PhotoButtonDelegate

/*  拍照  */
- (void)takePhoto {
    
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
    
    [self.mCamera takePhotoAndSave];
}

/*  开始录像    */
- (void)startRecord {
    [self.mCamera startRecord];
}

/*  停止录像    */
- (void)stopRecord {
    [self.mCamera stopRecord];
}

#pragma mark --- FUAPIDemoBarDelegate
/**设置美颜参数*/
- (void)demoBarBeautyParamChanged
{
    [self syncBeautyParams];
}

- (void)syncBeautyParams    {
    
    [FUManager shareManager].skinDetectEnable = _demoBar.skinDetect;
    [FUManager shareManager].blurShape = _demoBar.heavyBlur;
    [FUManager shareManager].blurLevel = _demoBar.blurLevel ;
    [FUManager shareManager].whiteLevel = _demoBar.colorLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].eyelightingLevel = _demoBar.eyeBrightLevel;
    [FUManager shareManager].beautyToothLevel = _demoBar.toothWhitenLevel;
    [FUManager shareManager].faceShape = _demoBar.faceShape;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    [FUManager shareManager].enlargingLevel_new = _demoBar.enlargingLevel_new;
    [FUManager shareManager].thinningLevel_new = _demoBar.thinningLevel_new;
    [FUManager shareManager].jewLevel = _demoBar.chinLevel;
    [FUManager shareManager].foreheadLevel = _demoBar.foreheadLevel;
    [FUManager shareManager].noseLevel = _demoBar.noseLevel;
    [FUManager shareManager].mouthLevel = _demoBar.mouthLevel;
    
    [FUManager shareManager].selectedFilter = _demoBar.selectedFilter ;
    [FUManager shareManager].selectedFilterLevel = _demoBar.selectedFilterLevel;
}

-(void)demoBarShouldShowMessage:(NSString *)message {
    
    self.tipLabe.hidden = NO;
    self.tipLabe.text = message;
    [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
    [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1 ];
}

-(void)demoBarDidShowTopView:(BOOL)shown {
    
    if (shown) {

        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, -_demoBar.frame.size.height * 0.9) ;
        CGAffineTransform photoTransform1 = CGAffineTransformMakeScale(0.8, 0.8) ;

        [UIView animateWithDuration:0.35 animations:^{

            self.photoBtn.transform = CGAffineTransformConcat(photoTransform0, photoTransform1) ;
        }];
    } else {

        [UIView animateWithDuration:0.35 animations:^{

            self.photoBtn.transform = CGAffineTransformIdentity ;
        }];
    }
}

- (IBAction)performanceValueChange:(UIButton *)sender {
    sender.selected = !sender.selected ;
    
    self.demoBar.performance = sender.selected ;
    
    [FUManager shareManager].performance = sender.selected;
    
    [[FUManager shareManager] setBeautyDefaultParameters];
    
    [FUManager shareManager].faceShape = sender.selected ? 3 : 4;;
    
    [self demoBarSetBeautyDefultParams];
}

#pragma mark --- FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    
    [[FUManager shareManager] loadItem:item];
    
    [self.itemsView stopAnimation];
    
    
    if (self.model.type == FULiveModelTypeAnimoji) {
        if ([item isEqualToString:@"noitem"]) {
            
            [[FUManager shareManager] removeCalibrating];
        }else {
            
            [[FUManager shareManager] setCalibrating];
        }
    }
    
    if (self.model.type == FULiveModelTypeMusicFilter) {
        [[FUMusicPlayer sharePlayer] stop];
        if (![item isEqualToString:@"noitem"]) {
            [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
        }
    }
    
    if (self.model.type == FULiveModelTypeGestureRecognition) {
        
        [[FUManager shareManager] setLoc_xy_flip];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *alertString = [[FUManager shareManager] alertForItem:item];
        self.alertLabel.hidden = alertString == nil ;
        self.alertLabel.text = alertString ;
        
        [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertLabel) object:nil];
        [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:3];
        
        NSString *hint = [[FUManager shareManager] hintForItem:item];
        self.tipLabe.hidden = hint == nil;
        self.tipLabe.text = hint;
        
        [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:5 ];
        
    });
}

- (void)dismissTipLabel
{
    self.tipLabe.hidden = YES;
}

- (void)dismissAlertLabel {
    self.alertLabel.hidden = YES ;
}

#pragma mark --- Loading

-(FUCamera *)mCamera {
    if (!_mCamera) {
        _mCamera = [[FUCamera alloc] init];
        _mCamera.delegate = self ;
    }
    return _mCamera ;
}

-(void)setDemoBar:(FUAPIDemoBar *)demoBar {
    
    _demoBar = demoBar;
//
//    BOOL perf = [FUManager shareManager].performance;
//    [FUManager shareManager].faceShape = perf ? 3 : 4 ;
//
//    _demoBar.performance = perf ;
    
    _demoBar.performance = [FUManager shareManager].performance;
    
    [self demoBarSetBeautyDefultParams];
}

- (void)demoBarSetBeautyDefultParams {
    _demoBar.delegate = nil ;
    _demoBar.skinDetect = [FUManager shareManager].skinDetectEnable;
    _demoBar.heavyBlur = [FUManager shareManager].blurShape ;
    _demoBar.blurLevel = [FUManager shareManager].blurLevel ;
    _demoBar.colorLevel = [FUManager shareManager].whiteLevel ;
    _demoBar.redLevel = [FUManager shareManager].redLevel;
    _demoBar.eyeBrightLevel = [FUManager shareManager].eyelightingLevel ;
    _demoBar.toothWhitenLevel = [FUManager shareManager].beautyToothLevel ;
    _demoBar.faceShape = [FUManager shareManager].faceShape ;
    _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel ;
    _demoBar.thinningLevel = [FUManager shareManager].thinningLevel ;
    _demoBar.enlargingLevel_new = [FUManager shareManager].enlargingLevel_new ;
    _demoBar.thinningLevel_new = [FUManager shareManager].thinningLevel_new ;
    _demoBar.chinLevel = [FUManager shareManager].jewLevel ;
    _demoBar.foreheadLevel = [FUManager shareManager].foreheadLevel ;
    _demoBar.noseLevel = [FUManager shareManager].noseLevel ;
    _demoBar.mouthLevel = [FUManager shareManager].mouthLevel ;

    _demoBar.filtersDataSource = [FUManager shareManager].filtersDataSource ;
    _demoBar.beautyFiltersDataSource = [FUManager shareManager].beautyFiltersDataSource ;
    _demoBar.filtersCHName = [FUManager shareManager].filtersCHName ;
    _demoBar.selectedFilter = [FUManager shareManager].selectedFilter ;

    _demoBar.delegate = self;
}

#pragma mark --- Observer

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive
{
    
    if (self.navigationController.visibleViewController == self) {
        [_mCamera stopCapture];
        if (self.model.type == FULiveModelTypeMusicFilter) {
            [[FUMusicPlayer sharePlayer] pause] ;
        }
    }
}

- (void)willEnterForeground
{
    
    if (self.navigationController.visibleViewController == self) {
        [_mCamera startCapture];
        
        if (self.model.type == FULiveModelTypeMusicFilter && ![[FUManager shareManager].selectedItem isEqualToString:@"noitem"]) {
            [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"] ;
        }
    }
}

- (void)didBecomeActive
{
    
    if (self.navigationController.visibleViewController == self) {
        [_mCamera startCapture];
        if (self.model.type == FULiveModelTypeMusicFilter && ![[FUManager shareManager].selectedItem isEqualToString:@"noitem"]) {
            [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"] ;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
