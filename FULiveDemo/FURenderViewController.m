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
#import "FUMakeUpView.h"
#import "FUHairView.h"
#import "FULightingView.h"

@interface FURenderViewController ()<
FUCameraDelegate,
PhotoButtonDelegate,
FUAPIDemoBarDelegate,
FUItemsViewDelegate,
FUMakeUpViewDelegate,
FUHairViewDelegate,
FULightingViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
{
    
    dispatch_semaphore_t signal;
}
@property (nonatomic, strong) FUCamera *mCamera ;
@property (weak, nonatomic) IBOutlet FUOpenGLView *renderView;

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
@property (weak, nonatomic) IBOutlet UIView *makeupContainer;
@property (nonatomic, strong) FUMakeUpView *makeupView ;

@property (weak, nonatomic) IBOutlet UIView *hairContainer;
@property (nonatomic, strong) FUHairView *hairView ;
@property (weak, nonatomic) IBOutlet UIView *lightingContainer;
@property (nonatomic, strong) FULightingView *lightingView ;
@property (weak, nonatomic) IBOutlet UIImageView *adjustImage;
@end

@implementation FURenderViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    signal = dispatch_semaphore_create(1);
    [self addObserver];
    
    self.selectedImageBtn.hidden = !(self.model.type == FULiveModelTypeBeautifyFace || self.model.type == FULiveModelTypeItems) ;
    self.photoBtn.delegate = self ;
    
    [[FUManager shareManager] loadFilter] ;
    
    [[FUManager shareManager] setAsyncTrackFaceEnable:YES];
    switch (self.model.type) {
        case FULiveModelTypeBeautifyFace:{      // 美颜
            
            [self.itemsView removeFromSuperview ];
            self.itemsView = nil ;
            [self.makeupContainer removeFromSuperview];
            self.makeupView = nil ;
            [self.hairContainer removeFromSuperview];
            
            self.performanceBtn.hidden = NO ;
            self.performanceBtn.selected = [FUManager shareManager].performance;
            
        }
            break;
        case FULiveModelTypeMakeUp:{            //  美妆
            
            [self.demoBar removeFromSuperview ];
            self.demoBar = nil ;
            [self.itemsView removeFromSuperview ];
            self.itemsView = nil ;
            [self.hairContainer removeFromSuperview];
//            [[FUManager shareManager] loadMakeupItem] ;
            [[FUManager shareManager] setAsyncTrackFaceEnable:NO];
        }
            break ;
        case FULiveModelTypeHair:{
            
            self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8)) ;
            [self.demoBar removeFromSuperview ];
            self.demoBar = nil ;
            [self.itemsView removeFromSuperview ];
            self.itemsView = nil ;
            [self.makeupContainer removeFromSuperview];
            self.makeupView = nil ;
            
            self.hairView.itemsArray = self.model.items;
            
            [[FUManager shareManager] loadItem:@"hair_color"];
            [[FUManager shareManager] setHairColor:0];
            [[FUManager shareManager] setHairStrength:0.5];
        }
            break ;
        default:{                               // 道具
            
            self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
            [self.demoBar removeFromSuperview ];
            self.demoBar = nil ;
            [self.makeupContainer removeFromSuperview];
            self.makeupView = nil ;
            [self.hairContainer removeFromSuperview];
            
            self.itemsView.delegate = self ;
            [self.view addSubview:self.itemsView];
            
            
            self.itemsView.itemsArray = self.model.items;
            
            NSString *selectItem = self.model.items.count > 0 ? self.model.items[0] : @"noitem" ;
            self.itemsView.selectedItem = selectItem ;
            [[FUManager shareManager] loadItem: selectItem];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *alertString = [[FUManager shareManager] alertForItem:selectItem];
                self.alertLabel.hidden = alertString == nil ;
                self.alertLabel.text = NSLocalizedString(alertString, nil) ;
                
                [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertLabel) object:nil];
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:3];
                
                NSString *hint = [[FUManager shareManager] hintForItem:selectItem];
                self.tipLabe.hidden = hint == nil;
                self.tipLabe.text = NSLocalizedString(hint, nil);
                
                [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
                [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:5 ];
            });
        }
            break;
    }
    
    [FUManager shareManager].enableMaxFaces = self.model.maxFace == 4;
    
    self.lightingContainer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScreenAction:)];
    [self.renderView addGestureRecognizer:tap];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.model.type > 0 && self.model.type != FULiveModelTypeHair) {
        
        // 适配 iPhone X
        CGRect frame = self.itemsView.frame ;
        frame.origin = [[[FUManager shareManager] getPlatformtype] isEqualToString:@"iPhone X"] ? CGPointMake(0, self.view.frame.size.height - frame.size.height - 34) : CGPointMake(0, self.view.frame.size.height - frame.size.height) ; ;
        frame.size = CGSizeMake(self.view.frame.size.width, frame.size.height) ;
        self.itemsView.frame = frame ;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.model.type == FULiveModelTypeBeautifyFace) {
        
        [self demoBarSetBeautyDefultParams];
    }
    
    if (self.model.type > 1 && self.model.type != FULiveModelTypeHair){
        if (!self.itemsView.selectedItem) {
            self.itemsView.selectedItem = [FUManager shareManager].selectedItem ;
        }else {
            [[FUManager shareManager] loadItem:self.itemsView.selectedItem];
        }
    }
    
    if (self.model.type == FULiveModelTypeAnimoji) {
        [[FUManager shareManager] loadAnimojiFaxxBundle];
        [[FUManager shareManager] set3DFlipH];
    }
    
    if (self.model.type == FULiveModelTypePortraitDrive) {
        [[FUManager shareManager] set3DFlipH];
    }
    
    if (self.model.type == FULiveModelTypeGestureRecognition) {
        [[FUManager shareManager] setLoc_xy_flip];
    }
    
    [self.mCamera startCapture];
    
    if (self.model.type == FULiveModelTypeMusicFilter && ![[FUManager shareManager].selectedItem isEqualToString:@"noitem"]) {
        [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
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
//    [[FUManager shareManager] destoryItems];
//    [[FUManager shareManager] onCameraChange];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.demoBar hiddeTopView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier ;
    if ([identifier isEqualToString:@"FUMakeUpView"]) {
        UIViewController *vc= segue.destinationViewController;
        self.makeupView = (FUMakeUpView *)vc.view ;
        self.makeupView.delegate = self ;
    }else if ([identifier isEqualToString:@"FUHairView"]){
        UIViewController *vc= segue.destinationViewController;
        self.hairView = (FUHairView *)vc.view ;
        self.hairView.delegate = self ;
    }else if ([identifier isEqualToString:@"FULightingView"]){
        UIViewController *vc= segue.destinationViewController;
        self.lightingView = (FULightingView *)(vc.view) ;
        self.lightingView.delegate = self ;
        self.lightingView.hidden = YES ;
    }
}

static CFAbsoluteTime adjustTime = 0 ;
- (void)touchScreenAction:(UITapGestureRecognizer *)tap {
    
    if (tap.view == self.renderView) {
        if (self.model.type == FULiveModelTypeBeautifyFace) {
            [self.demoBar hiddeTopView];
        }else if (self.model.type == FULiveModelTypeMakeUp) {
            [self.makeupView hiddenMakeupViewTopView] ;
        }
        // 聚焦
        if (self.adjustImage.hidden) {
            self.adjustImage.hidden = NO ;
            self.lightingContainer.hidden = NO ;
            self.lightingView.hidden = NO ;
        }
        
        CGPoint center = [tap locationInView:self.renderView];
        // 聚焦 + 曝光
        self.mCamera.focusPoint = CGPointMake(center.y/self.view.bounds.size.height, self.mCamera.isFrontCamera ? center.x/self.view.bounds.size.width : 1 - center.x/self.view.bounds.size.width);
        self.mCamera.exposurePoint = CGPointMake(center.y/self.view.bounds.size.height, self.mCamera.isFrontCamera ? center.x/self.view.bounds.size.width : 1 - center.x/self.view.bounds.size.width);
        
        // UI
        adjustTime = CFAbsoluteTimeGetCurrent() ;
        self.adjustImage.center = center ;
        self.adjustImage.transform = CGAffineTransformIdentity ;
        [UIView animateWithDuration:0.3 animations:^{
            self.adjustImage.transform = CGAffineTransformMakeScale(0.67, 0.67) ;
        }completion:^(BOOL finished) {
            [self hiddenAdjustViewWithTime:1.0];
        }];
    }
}

- (IBAction)backAction:(UIButton *)sender {
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    [self.mCamera stopCapture];
    
    [FUManager shareManager].currentModel = nil ;
    [[FUManager shareManager] destoryItems];
    [[FUManager shareManager] onCameraChange];
    
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_semaphore_signal(signal);
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
    [self setPhotoScaleWithHeight:self.demoBar.frame.size.height show:shown];
}

- (void)setPhotoScaleWithHeight:(CGFloat)height show:(BOOL)shown {
    
    if (shown) {
        
        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, height * -0.9) ;
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
    
//    [FUManager shareManager].blurShape = sender.selected ? 1 : 0 ;
//    [FUManager shareManager].faceShape = sender.selected ? 3 : 4;;
    
    [self demoBarSetBeautyDefultParams];
}

#pragma mark ---- FUMakeUpViewDelegate
// 显示上半部分
-(void)makeupViewDidShowTopView:(BOOL)shown {
    [self setPhotoScaleWithHeight:self.makeupView.frame.size.height show:shown];
}

// 点击事件
-(void)makeupViewDidSelectedItemWithType:(NSInteger)typeIndex itemName:(NSString *)itemName value:(float)value {
//    NSLog(@"--- did selected type: %ld - name: %@ - value: %f", typeIndex, itemName, value);
    [self makeupViewDidChangeValue:value Type:typeIndex];
    
    [[FUManager shareManager] loadMakeupItemWithType:typeIndex itemName:itemName];
}

// 滑动事件
-(void)makeupViewDidChangeValue:(float)value Type:(NSInteger)typeIndx {
//    NSLog(@"--- value change: %f - type: %ld", value, typeIndx);
    switch (typeIndx) {
        case 0:
            [FUManager shareManager].lipstick = value;
            break;
        case 1:
            [FUManager shareManager].blush = value;
            break;
        case 2:
            [FUManager shareManager].eyebrow = value;
            break;
        case 3:
            [FUManager shareManager].eyeShadow = value;
            break;
        case 4:
            [FUManager shareManager].eyeLiner = value;
            break;
        case 5:
            [FUManager shareManager].eyelash = value;
            break;
        case 6:
            [FUManager shareManager].contactLens = value;
            break;
            
        default:
            break;
    }
}

#pragma mark --- FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
//        if ([item isEqualToString:@"noitem"]) {
//
//            [[FUManager shareManager] setHairStrength:NO];
//        }else {
//            NSInteger index = [self.model.items indexOfObject:item];
//            [[FUManager shareManager] setHairColor:(int)index];
//            [[FUManager shareManager] setHairStrength:YES];
//        }
//
//        [self.itemsView stopAnimation];
    
    [[FUManager shareManager] loadItem:item];
    
    [self.itemsView stopAnimation];
    
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
        self.alertLabel.text = NSLocalizedString(alertString, nil) ;
        
        [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertLabel) object:nil];
        [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:3];
        
        NSString *hint = [[FUManager shareManager] hintForItem:item];
        self.tipLabe.hidden = hint == nil;
        self.tipLabe.text = NSLocalizedString(hint, nil);
        
        [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:5 ];
        
    });
    
    dispatch_semaphore_signal(signal);
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
    _demoBar.selectedFilterLevel = [FUManager shareManager].selectedFilterLevel;

    _demoBar.delegate = self;
}

#pragma mark --- FUHairViewDelegate
-(void)hairViewDidSelectedhairIndex:(NSInteger)index Strength:(float)strength{
    
    if (index == -1) {
        [[FUManager shareManager] setHairColor:0];
        [[FUManager shareManager] setHairStrength:0.0];
    }else {
        [[FUManager shareManager] setHairColor:(int)index];
        [[FUManager shareManager] setHairStrength:strength];
    }
}

#pragma mark ---- FULightingViewDelegate
-(void)lightingViewValueDidChange:(float)value {
    adjustTime = CFAbsoluteTimeGetCurrent() ;
    [self hiddenAdjustViewWithTime:1.3];
    [self.mCamera setExposureValue:value];
}

- (void)hiddenAdjustViewWithTime:(float)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (CFAbsoluteTimeGetCurrent() - adjustTime > 1.29) {
            self.adjustImage.hidden = YES ;
            self.lightingContainer.hidden = YES ;
            self.lightingView.hidden = YES ;
        }
    });
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
