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
#import "FUSaveViewController.h"
#import "FUEditImageViewController.h"
#import "FUImageHelper.h"
#import "FURenderer.h"
#import "FUSegmentBarView.h"

@interface FURenderViewController ()<
FUCameraDelegate,
PhotoButtonDelegate,
FUAPIDemoBarDelegate,
FUItemsViewDelegate,
FUMakeUpViewDelegate,
FUHairViewDelegate,
FULightingViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate
>
{
    
    dispatch_semaphore_t signal;
    dispatch_semaphore_t semaphore;
    UIImage *mCaptureImage;
}
@property (nonatomic, strong) FUCamera *mCamera ;
@property (weak, nonatomic) IBOutlet FUOpenGLView *renderView;

@property (weak, nonatomic) IBOutlet FUAPIDemoBar *demoBar;
@property (weak, nonatomic) IBOutlet PhotoButton *photoBtn;
@property (weak, nonatomic) IBOutlet FUItemsView *itemsView;
@property (weak, nonatomic) IBOutlet UIButton *mHomeBtn;

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

/* 动漫滤镜分栏*/
@property (strong, nonatomic) FUSegmentBarView *segmentBarView;
@property (strong, nonatomic) NSArray *comicItemArray;
/* 针对海报融合的提示框 */
@property (nonatomic, strong) UILabel *tipLabel;

@property (strong,nonatomic) NSString *selAnmoji;
@property (strong,nonatomic) NSString *selComic;
@end

@implementation FURenderViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //重置曝光值为0
    [self.mCamera setExposureValue:0];
    
    //曝光补偿条设置
    [self setupLightingValue];
    
    [self.mCamera startCapture];
    signal = dispatch_semaphore_create(1);
    [self addObserver];
    
    self.selectedImageBtn.hidden = !(self.model.type == FULiveModelTypeBeautifyFace || self.model.type == FULiveModelTypeItems) ;
    self.photoBtn.delegate = self ;
    
    [[FUManager shareManager] loadFilter] ;
    
    [[FUManager shareManager] setAsyncTrackFaceEnable:NO];
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
            self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -150), CGAffineTransformMakeScale(0.8, 0.8)) ;
            [self.demoBar removeFromSuperview ];
            self.demoBar = nil ;
            [self.itemsView removeFromSuperview ];
            self.itemsView = nil ;
            [self.hairContainer removeFromSuperview];
//            [[FUManager shareManager] loadMakeupItem] ;
            [self.makeupView setDefaultSupItem:1];
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
            
            [[FUManager shareManager] loadItem:@"hair_gradient"];
            [[FUManager shareManager] setHairColor:0];
            [[FUManager shareManager] setHairStrength:0.5];
        }
            break ;
        case FULiveModelTypePoster:{
            [self.itemsView removeFromSuperview ];
            self.itemsView = nil ;
            [self.makeupContainer removeFromSuperview];
            self.makeupView = nil ;
            [self.hairContainer removeFromSuperview];
            [self.demoBar removeFromSuperview ];
            self.demoBar = nil ;
            [self.mHomeBtn setImage:[UIImage imageNamed:@"save_nav_back_n"] forState:UIControlStateNormal];
            [_photoBtn setType:FUPhotoButtonTypeTakePhoto];
            
            _itemsView.hidden = YES;
            self.selectedImageBtn.hidden = NO;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_contour"]];
            CGPoint center = self.view.center;
            center.y = center.y - 50;
            imageView.center = center;
            
            _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, [UIScreen mainScreen].bounds.size.width, 20)];
            _tipLabel.textAlignment = NSTextAlignmentCenter;
            _tipLabel.text = NSLocalizedString(@"对准线框 正脸拍摄", nil);
            _tipLabel.font = [UIFont systemFontOfSize:13];
            _tipLabel.textColor = [UIColor whiteColor];
            [self.view addSubview:_tipLabel];
            
            
            [self.view addSubview:imageView];
            
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
            
            [self.itemsView updateCollectionArray:self.model.items];
            
            NSString *selectItem = self.model.items.count > 0 ? self.model.items[0] : @"noitem" ;


            
            if(self.model.type == FULiveModelTypeAnimoji){//animoji动漫滤镜按钮
                selectItem = @"noitem";
                [[FUManager shareManager] loadFilterAnimoji:@"fuzzytoonfilter" style:0];//默认开启动漫
                _selAnmoji = self.itemsView.selectedItem;
                _comicItemArray = @[@"fuzzytoonfilter1",@"fuzzytoonfilter2",@"fuzzytoonfilter3"];
                _selComic = _comicItemArray[0];
                _segmentBarView = [[FUSegmentBarView alloc] initWithFrame:CGRectMake(0, 200,[UIScreen mainScreen].bounds.size.width, 49) titleArray:@[@"Animoji",NSLocalizedString(@"动漫滤镜",nil)] selBlock:^(int index) {
                    if (index == 0) {
                        self.itemsView.selectedItem = _selAnmoji;
                        [_itemsView updateCollectionArray:self.model.items];
                    }else{
                        self.itemsView.selectedItem = _selComic;
                        [_itemsView updateCollectionArray:_comicItemArray];
                    }
                    NSLog(@"选中---%d",index);
                }];
                [self.view addSubview:_segmentBarView];
                
                
            }
            
            self.itemsView.selectedItem = selectItem ;
            [[FUManager shareManager] loadItem: selectItem];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *alertString = [[FUManager shareManager] alertForItem:selectItem];
                self.alertLabel.hidden = alertString == nil ;
                if (alertString && alertString.length != 0) {
                    self.alertLabel.text = NSLocalizedString(alertString, nil) ;
                }
                
                [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertLabel) object:nil];
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:3];
                
                NSString *hint = [[FUManager shareManager] hintForItem:selectItem];
                self.tipLabe.hidden = hint == nil;
                if (hint && hint.length != 0) {
                    self.tipLabe.text = NSLocalizedString(hint, nil);
                }
                
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
    
    /* 开启音量拦截*/
    [_photoBtn startObserveVolumeChangeEvents];
}

#pragma  mark ----  曝光补偿初始化  -----
-(void)setupLightingValue{
//    float min ,max,currentV;
//    [self.mCamera getCurrentExposureValue:&currentV max:&max min:&min];
    
    //设置默认调节的区间
    self.lightingView.slider.minimumValue = -2;
    self.lightingView.slider.maximumValue = 2;
//    if(currentV > 2){
//        currentV = 2;
//    }
//    if (currentV < -2) {
//        currentV = -2;
//    }
    self.lightingView.slider.value = 0;
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.model.type > 0 && self.model.type != FULiveModelTypeHair) {
        
        // 适配 iPhone X
        CGRect frame = self.itemsView.frame ;
        frame.origin = [[[FUManager shareManager] getPlatformtype] isEqualToString:@"iPhone X"] ? CGPointMake(0, self.view.frame.size.height - frame.size.height - 34) : CGPointMake(0, self.view.frame.size.height - frame.size.height) ; ;
        frame.size = CGSizeMake(self.view.frame.size.width, frame.size.height) ;
        self.itemsView.frame = frame;
        
        if (self.model.type == FULiveModelTypeAnimoji) {
            CGRect frame0 = CGRectMake(frame.origin.x, frame.origin.y - 49, frame.size.width, frame.size.height);
            self.itemsView.frame = frame0;
            _segmentBarView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 49, frame.size.width, 49);
            
            CGRect frame1 = CGRectMake(_photoBtn.frame.origin.x, _photoBtn.frame.origin.y - 49, _photoBtn.frame.size.width, _photoBtn.frame.size.height);
            _photoBtn.frame = frame1;
        }
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

    [self.mCamera resetFocusAndExposureModes];
    [self.mCamera stopCapture];
    
    /* 关闭音量拦截*/
    [_photoBtn stopObserveVolumeChangeEvents];
    if (self.model.type == FULiveModelTypeMusicFilter) {
        
        [self.mCamera removeAudio];
        [[FUMusicPlayer sharePlayer] stop];
    }else if (self.model.type == FULiveModelTypeAnimoji) {
        
        [[FUManager shareManager] destoryAnimojiFaxxBundle];
    }
    
    // 清除缓存
//    [[FUManager shareManager] destoryItems];
//    [[FUManager shareManager] onCameraChange];
}
-(void)dealloc{
    NSLog(@"dealloc---");
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

#pragma  mark ----  UI Action  -----

static CFAbsoluteTime adjustTime = 0 ;
- (void)touchScreenAction:(UITapGestureRecognizer *)tap {
    
    if (tap.view == self.renderView) {
        if (self.model.type == FULiveModelTypeBeautifyFace) {
            [self.demoBar hiddeTopView];
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

- (IBAction)pickerPhotoClick:(id)sender {
    
    if (self.model.type == FULiveModelTypePoster) {
        [self selectedImage];
    }else{
        [self performSegueWithIdentifier:@"sleIamgeView" sender:nil];
    }
    
}

-(UIImage *)captureImage{
    mCaptureImage = nil;
    semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return mCaptureImage;
    
}


#pragma mark --- FUCameraDelegate

-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    CFAbsoluteTime startRenderTime = CFAbsoluteTimeGetCurrent();
    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    CFAbsoluteTime renderTime = (CFAbsoluteTimeGetCurrent() - startRenderTime);
    [self.renderView displayPixelBuffer:pixelBuffer withLandmarks:NULL count:0];
    
    if (self.model.type == FULiveModelTypeMusicFilter) {
        [[FUManager shareManager] musicFilterSetMusicTime];
    }
    
    if (!mCaptureImage && semaphore) {//拍照抓图
        mCaptureImage = [FUImageHelper imageFromPixelBuffer:pixelBuffer];
        dispatch_semaphore_signal(semaphore);
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
    
    if (_model.type == FULiveModelTypePoster) {
        NSLog(@"抓图");
        UIImage *image = [self captureImage];
        FUSaveViewController *vc = [[FUSaveViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.mImage = image;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
         [self.mCamera takePhotoAndSave];
    }
    
   
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
//-(void)makeupViewDidShowTopView:(BOOL)shown {
//    [self setPhotoScaleWithHeight:self.makeupView.frame.size.height show:shown];
//}
- (void)makeupSupItemDidSel:(int)index value:(float)value{
    NSLog(@"选中了%d",index);
    [self makeupRemoveAll];
    value = 0.7 * value;//组合妆，产品说降低值域
    switch (index) {
        case 0:
            //卸妆
           // [[FUManager shareManager] makeupIntensity:0 param:@"is_makeup_on"];
            break;
        case 1:{//桃花
            [self loadPeachBlossomMakeupParm:value];
        }
            break;
        case 2:{//雀斑
            [self loadFrecklesParm:value];
        }
            break;
        case 3:{
            //朋克
            [self loadPunkMakeupParm:value];
        }
            break;
        default:
            break;
    }
}

-(void)makeupSupDidChangeValue:(int)index value:(float)value{
    value = value * 0.7;//组合妆，产品说降低值域
   // [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity"];
    [self makeupAllValue:value];
    if (index == 3) {//朋克妆 没有腮红
        [[FUManager shareManager] makeupIntensity:0 param:@"makeup_intensity_blusher"];
    }
   
}

// 点击事件
-(void)makeupViewDidSelectedItemWithType:(NSInteger)typeIndex itemName:(NSString *)itemName value:(float)value {
    itemName = [itemName stringByAppendingString:@"_nama"];
    switch (typeIndex) {
        case 0:{
            NSArray *rgba = [self jsonToLipRgbaArrayResName:itemName];
            double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
            [[FUManager shareManager] makeupLipstick:lip];
        }
            break;
        case 1:{
             [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:itemName] param:@"tex_blusher"];
        }
            break;
        case 2:{
             [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:itemName] param:@"tex_brow"];
        }
            break;
        case 3:{
             [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:itemName] param:@"tex_eye"];
        }
            break;
        case 4:{
             [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:itemName] param:@"tex_eyeLiner"];
        }
            break;
        case 5:{
            [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:itemName] param:@"tex_eyeLash"];
        }
            break;
        case 6:{
             [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:itemName] param:@"tex_pupil"];
        }
            break;
            
        default:
            break;
    }
    
    if ([itemName isEqualToString:@"makeup_noitem_nama"]){
        [self makeupViewDidChangeValue:0 Type:typeIndex];
    }else{
        [self makeupViewDidChangeValue:value Type:typeIndex];
    }
    
    
}

// 滑动事件
-(void)makeupViewDidChangeValue:(float)value Type:(NSInteger)typeIndx {
//    NSLog(@"--- value change: %f - type: %ld", value, typeIndx);
    switch (typeIndx) {
        case 0:{
            [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_lip"];
            [FUManager shareManager].lipstick = value;
            break;            
        }
        case 1:{
            [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_blusher"];
            [FUManager shareManager].blush = value;
        }
            break;
        case 2:{
            [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eyeBrow"];
            [FUManager shareManager].eyebrow = value;
        }
            break;
        case 3:{
            [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eye"];
            [FUManager shareManager].eyeShadow = value;
        }
            break;
        case 4:{
            [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eyeLiner"];
            [FUManager shareManager].eyeLiner = value;
        }
            break;
        case 5:{
            [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eyelash"];
            [FUManager shareManager].eyelash = value;
        }
            break;
        case 6:{
            [FUManager shareManager].contactLens = value;
            [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_pupil"];
        }
            break;
            
        default:
            break;
    }
}

#pragma  mark ----  桃花妆  -----
-(void)loadPeachBlossomMakeupParm:(float)value{
    NSArray *rgba = [self jsonToLipRgbaArrayResName:@"口红07_nama"];
    double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
    [[FUManager shareManager] makeupLipstick:lip];
    //桃花
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眉毛07_nama"] param:@"tex_brow"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眼影07_nama"] param:@"tex_eye"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眼线07_nama"] param:@"tex_eyeLiner"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"睫毛07_nama"] param:@"tex_eyeLash"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"美瞳10_nama"] param:@"tex_pupil"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"腮红11_nama"] param:@"tex_blusher"];
    [self makeupAllValue:value];
}

#pragma  mark ----  雀斑妆  -----

-(void)loadFrecklesParm:(float)value{

    NSArray *rgba = [self jsonToLipRgbaArrayResName:@"口红08_nama"];
    double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
     [[FUManager shareManager] makeupLipstick:lip];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眉毛08_nama"] param:@"tex_brow"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眼影08_nama"] param:@"tex_eye"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眼线08_nama"] param:@"tex_eyeLiner"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"睫毛08_nama"] param:@"tex_eyeLash"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"美瞳11_nama"] param:@"tex_pupil"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"腮红12_nama"] param:@"tex_blusher"];
    [self makeupAllValue:value];
}
#pragma  mark ----  朋克妆  -----
-(void)loadPunkMakeupParm:(float)value{
    NSArray *rgba = [self jsonToLipRgbaArrayResName:@"口红09_nama"];
    double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
     [[FUManager shareManager] makeupLipstick:lip];
    
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眉毛09_nama"] param:@"tex_brow"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眼影09_nama"] param:@"tex_eye"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"眼线08_nama"] param:@"tex_eyeLiner"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"睫毛07_nama"] param:@"tex_eyeLash"];
    [[FUManager shareManager] loadMakeupItemImage:[UIImage imageNamed:@"美瞳12_nama"] param:@"tex_pupil"];

    [self makeupAllValue:value];
    [[FUManager shareManager] makeupIntensity:0 param:@"makeup_intensity_blusher"];//没有腮红

}


#pragma  mark ----  关闭美妆  -----
-(void)makeupRemoveAll{
    [self makeupAllValue:0];
}

-(void)makeupAllValue:(float)value{
    [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_blusher"];
    [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eyeBrow"];
    [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eye"];
    [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eyeLiner"];
    [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_eyelash"];
    [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_pupil"];
    [[FUManager shareManager] makeupIntensity:value param:@"makeup_intensity_lip"];
}


-(NSArray *)jsonToLipRgbaArrayResName:(NSString *)resName{
    NSString *path=[[NSBundle mainBundle] pathForResource:resName ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    //解析成字典
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *rgba = [dic objectForKey:@"rgba"];
    
    if (rgba.count != 4) {
        NSLog(@"颜色json不合法");
    }
    return rgba;
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
    
    
    if (self.model.type == FULiveModelTypeAnimoji && self.segmentBarView.currentBtnIndex == 1){//动漫滤镜
        _selComic = item;
        if ([item containsString:@"3"]) { // fuzzytoonfilter123
            [[FUManager shareManager] loadFilterAnimoji:item style:1];
        }else if ([item containsString:@"2"]){
            [[FUManager shareManager] loadFilterAnimoji:item style:2];
        }else{
            [[FUManager shareManager] loadFilterAnimoji:item style:0];
        }
        
    }else{
         _selAnmoji = item;
        [[FUManager shareManager] loadItem:item];
        if ([_selComic containsString:@"3"]) { // fuzzytoonfilter123
            [[FUManager shareManager] loadFilterAnimoji:_selComic style:1];
        }else if ([item containsString:@"2"]){
            [[FUManager shareManager] loadFilterAnimoji:_selComic style:2];
        }else{
            [[FUManager shareManager] loadFilterAnimoji:_selComic style:0];
        }
    }
    
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
        if (alertString && alertString.length != 0) {
            self.alertLabel.text = NSLocalizedString(alertString, nil) ;
        }
        [FURenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertLabel) object:nil];
        [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:3];
        
        NSString *hint = [[FUManager shareManager] hintForItem:item];
        self.tipLabe.hidden = hint == nil;
        if (hint && hint.length != 0) {
            self.tipLabe.text = NSLocalizedString(hint, nil);
        }
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

-(void)changePosterTip:(NSString *)str{
    _tipLabel.text = str;
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
-(void)hairViewDidSelectedhairIndex:(NSInteger)index{
    if (index == -1) {
        [[FUManager shareManager] setHairColor:0];
        [[FUManager shareManager] setHairStrength:0.0];
    }else{
        if(index < 5) {//渐变色
            [[FUManager shareManager] loadItem:@"hair_gradient"];
            [[FUManager shareManager] setHairColor:(int)index];
         }else{
             [[FUManager shareManager] loadItem:@"hair_color"];
             [[FUManager shareManager] setHairColor:(int)index - 5];
    }
  }
}

-(void)hairViewChanageStrength:(float)strength{
    [[FUManager shareManager] setHairStrength:strength];
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

#pragma  mark ----  Picker photo  -----

- (void)selectedImage{
    [self showImagePickerWithMediaType:(NSString *)kUTTypeImage];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    FUEditImageViewController *vc = [[FUEditImageViewController alloc] initWithNibName:@"FUEditImageViewController" bundle:nil];
    vc.view.backgroundColor = [UIColor blackColor];
    vc.PushFrom = FUEditImagePushFromAlbum;
    [self.navigationController pushViewController:vc animated:YES];
    // 图片转正
    if(image.size.width  > 1500 ||  image.size.height > 1500 ){// 图片转正 + 超大取缩略,这里有点随意，不知道sdk算法
        int scalew = image.size.width  / 1000;
        int scaleH = image.size.height  / 1000;
        
        int scale = scalew > scaleH ? scalew + 1: scaleH + 1;
        
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width / scale, image.size.height / scale));
        
        [image drawInRect:CGRectMake(0, 0, image.size.width/scale, image.size.height/scale)];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }else{
        
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width , image.size.height));
        
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    vc.mPhotoImage = image;
}

- (UIImage *)normalizedImage:(UIImage *)photoImage{
    if (photoImage.imageOrientation == UIImageOrientationUp) return photoImage;

    UIGraphicsBeginImageContextWithOptions(photoImage.size, NO, photoImage.scale);
    [photoImage drawInRect:CGRectMake(0, 0, photoImage.size.width/4, photoImage.size.height/4)];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}





- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImagePickerWithMediaType:(NSString *)mediaType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[mediaType] ;
    [self presentViewController:picker animated:YES completion:nil];
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
