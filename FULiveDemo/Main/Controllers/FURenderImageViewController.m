//
//  FURenderImageViewController.m
//  FULiveDemo
//
//  Created by L on 2018/6/22.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FURenderImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FUOpenGLView.h"
#import "FUVideoReader.h"
#import "FUManager.h"
#import "FUMusicPlayer.h"
#import <SVProgressHUD.h>
#import "FUAPIDemoBar.h"
#import "FUItemsView.h"
#import <Masonry.h>
#import "FUImageHelper.h"
#import "FUBodyBeautyView.h"
#import "MJExtension.h"
#import "FUBaseViewController.h"
#import "FULvMuView.h"
#import "FUVideoDecoder.h"

#define finalPath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"finalVideo.mp4"]

@interface FURenderImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, FUVideoReaderDelegate, FUAPIDemoBarDelegate, FUItemsViewDelegate,FULvMuViewDelegate,UIGestureRecognizerDelegate,FULvMuViewDataSource>

{
    CVPixelBufferRef mPixelBuffer;
    __block BOOL takePic ;
    
    BOOL videHasRendered ;
    
    dispatch_queue_t renderQueue;
    
    float w,h;
}

@property (nonatomic, strong) FULiveModel *model ;

@property (strong, nonatomic) FUOpenGLView *glView;
@property (nonatomic, strong) FUVideoReader *videoReader ;

@property (strong, nonatomic) UIButton *playBtn;

@property (strong, nonatomic) FUAPIDemoBar *demoBar;
@property (strong, nonatomic) FUItemsView *itemsView;

@property (strong, nonatomic) UIButton *downloadBtn;
@property (strong, nonatomic)  UILabel *tipLabel;
@property (strong, nonatomic) UILabel *noTrackLabel;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property(nonatomic,strong)FUBodyBeautyView *mBodyBeautyView;

@property(strong,nonatomic) FULvMuView *lvmuEditeView;

// 定时器
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic,assign) NSInteger  degress;

/* 比对按钮 */
@property (strong, nonatomic) UIButton *compBtn;
/* 是否开启比对 */
@property (assign, nonatomic) BOOL openComp;

@property (strong, nonatomic) FUVideoDecoder *videoDecoder;

@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;

@property (nonatomic, assign) CGRect lvRect;
@end

@implementation FURenderImageViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [FUManager shareManager].currentModel;
    /* 道具切信号 */
    renderQueue = dispatch_queue_create("com.faceUMakeup", DISPATCH_QUEUE_SERIAL);
    [self addObserver];
    
    [self setupView];
    
    if (self.model.type == FULiveModelTypeBeautifyFace) {
        
        self.demoBar.hidden = NO ;
        [self.itemsView removeFromSuperview ];
        self.itemsView = nil ;
        
        self.downloadBtn.transform = CGAffineTransformMakeTranslation(0, 30) ;
        
        /* 比对按钮 */
        _compBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_compBtn setImage:[UIImage imageNamed:@"demo_icon_contrast"] forState:UIControlStateNormal];
        [_compBtn addTarget:self action:@selector(TouchDown) forControlEvents:UIControlEventTouchDown];
        [_compBtn addTarget:self action:@selector(TouchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _compBtn.hidden = YES;
        [self.view addSubview:_compBtn];
        if (iPhoneXStyle) {
            _compBtn.frame = CGRectMake(15 , self.view.frame.size.height - 70 - 182 - 34, 44, 44);
        }else{
            _compBtn.frame = CGRectMake(15 , self.view.frame.size.height - 70 - 182, 44, 44);
        }
        
    }else if(self.model.type == FULiveModelTypeBody){
        self.demoBar.hidden = YES ;
        [self.itemsView removeFromSuperview ];
        
        self.itemsView = nil ;
        
        self.downloadBtn.transform = CGAffineTransformMakeTranslation(0, 30) ;
        
        [self setupView1];
    }else if(self.model.type == FULiveModelTypeLvMu){
        [self setupLvMuSubView];
        self.downloadBtn.hidden = YES;
        self.glView.contentMode = FUOpenGLViewContentModeScaleAspectFit;
        
    }
    
    else {
        self.demoBar.hidden = YES ;
        
        self.itemsView.delegate = self ;
        [self.view addSubview:self.itemsView];
        
        NSMutableArray *array = [NSMutableArray  array];
        
        for (NSString *str in self.model.items) {
            if ([str isEqualToString:@"zhenxinhua_damaoxian"] || [str isEqualToString:@"expression_shooting"]) {
                continue;
            }
            [array addObject:str];
        }
        [self.itemsView updateCollectionArray:array];
        
        NSString *item = array[0];
        self.itemsView.selectedItem = item;
        [[FUManager shareManager] loadItem:item completion:nil];
    }
    
    takePic = NO ;
    videHasRendered = NO ;
}

-(void)setupLvMuSubView{
    // Do any additional setup after loading the view.
    _lvmuEditeView = [[FULvMuView alloc] initWithFrame:CGRectZero];
    _lvmuEditeView.mDelegate = self;
    _lvmuEditeView.mDataSource = self;
    [self.view addSubview:_lvmuEditeView];
    [_lvmuEditeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(184 + 34);
        }else{
            make.height.mas_equalTo(184);
        }
    }];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_lvmuEditeView addSubview:effectview];
    [_lvmuEditeView sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_lvmuEditeView);
    }];
    
    CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, 180 * -0.6) ;
    CGAffineTransform photoTransform1 = CGAffineTransformMakeScale(0.9, 0.9);
    self.downloadBtn.transform = CGAffineTransformConcat(photoTransform0, photoTransform1) ;
    
    _lvRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    [self setLvFrameRect:_lvRect];
    
    [self initMovementGestures];
    
}


-(void)initMovementGestures
{
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    //
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    self.pinchGesture.delegate = self;
    [self.view addGestureRecognizer:self.pinchGesture];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startRendering];
}

-(void)setupView{
    /* opengl */
    _glView = [[FUOpenGLView alloc] initWithFrame:self.view.bounds];
    _glView.contentMode = FUOpenGLViewContentModeScaleAspectFit;
    [self.view addSubview:_glView];
    
    /* 播放按钮 */
    _playBtn = [[UIButton alloc] init];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"Replay_icon"] forState:UIControlStateSelected];
    self.playBtn.hidden = YES;
    [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    /* 返回按钮 */
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    /* 未检测到人脸提示 */
    _noTrackLabel = [[UILabel alloc] init];
    _noTrackLabel = [[UILabel alloc] init];
    _noTrackLabel.textColor = [UIColor whiteColor];
    _noTrackLabel.font = [UIFont systemFontOfSize:17];
    _noTrackLabel.textAlignment = NSTextAlignmentCenter;
    _noTrackLabel.text = FUNSLocalizedString(@"No_Face_Tracking", @"未检测到人脸");
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
    
    /* 美颜调节 */
    _demoBar = [[FUAPIDemoBar alloc] init];
    [_demoBar reloadShapView:[FUManager shareManager].shapeParams];
    [_demoBar reloadSkinView:[FUManager shareManager].skinParams];
    [_demoBar reloadFilterView:[FUManager shareManager].filters];
    [_demoBar reloadStyleView:[FUManager shareManager].styleParams defaultStyle:[FUManager shareManager].currentStyle];
    
    _demoBar.mDelegate = self;
    [_demoBar setDefaultFilter:[FUManager shareManager].seletedFliter];
    [self.view addSubview:_demoBar];
    [_demoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(280);
    }];
    
    /* 下载 */
    _downloadBtn = [[UIButton alloc] init];
    _downloadBtn.backgroundColor = [UIColor whiteColor];
    _downloadBtn.layer.cornerRadius = 85/2;
    [_downloadBtn setBackgroundImage:[UIImage imageNamed:@"demo_icon_save1"] forState:UIControlStateNormal];
    [_downloadBtn addTarget:self action:@selector(downLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downloadBtn];
    [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-110);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-110);
        }
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(85);
    }];
    
    /* 贴纸调节 */
    _itemsView = [[FUItemsView alloc] init];
    _itemsView.delegate = self;
    [self.view addSubview:_itemsView];
//    [self.itemsView updateCollectionArray:self.model.items];
    
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(84 + 34);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
    
    if(self.model.type == FULiveModelTypeLvMu){
        return;
    }
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 1.0;
    [self.itemsView addSubview:effectview];
    [self.itemsView sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_itemsView);
    }];
}

-(void)setupView1{
    NSString *bodyBeautyPath=[[NSBundle mainBundle] pathForResource:@"BodyBeautyDefault" ofType:@"json"];
    NSData *bodyData=[[NSData alloc] initWithContentsOfFile:bodyBeautyPath];
    NSDictionary *bodyDic=[NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = [FUPosition mj_objectArrayWithKeyValuesArray:bodyDic];
    
    _mBodyBeautyView = [[FUBodyBeautyView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 134, [UIScreen mainScreen].bounds.size.width, 134) dataArray:dataArray];
    _mBodyBeautyView.delegate = self;
    [self.view addSubview:_mBodyBeautyView];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [_avPlayer pause];
    _avPlayer = nil ;
    [self.videoReader stopReading];
    [self.videoReader destory];
    [_displayLink invalidate];
    _displayLink.paused = YES ;
    _displayLink = nil ;
    
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeMakeup];
    
    /* 销毁背景 */
    int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
    fuDeleteTexForItem(lvmuHandle, (char *)[@"tex_bg" UTF8String]);

    
    [self.lvmuEditeView destoryLvMuView];
    [_videoDecoder videoStopRending];
    _videoDecoder = nil;
    [super viewWillDisappear:animated];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.model.type == FULiveModelTypeBeautifyFace) {
        [self.demoBar hiddenTopViewWithAnimation:YES];
    }
    
    if (self.model.type == FULiveModelTypeLvMu) {
        [_lvmuEditeView hidenTop:YES];
        if(self.playBtn.hidden){
            self.downloadBtn.hidden = NO;
        }
        
    }
}

- (void)startRendering {
    [FURenderer onCameraChange];
    if (self.image) {
        fuSetDefaultRotationMode(0);
        int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        [FURenderer itemSetParam:handle withName:@"rotation_mode" value:@(0)];
        [self processImage];
    }else {
        
        if (self.videoURL) {
            
            self.downloadBtn.hidden = YES ;
            self.playBtn.hidden = YES ;
            
            if (self.videoReader) {
                
                [self.videoReader setVideoURL:self.videoURL];
            }else {
                
                self.videoReader = [[FUVideoReader alloc] initWithVideoURL:self.videoURL];
                self.videoReader.delegate = self ;
                self.glView.origintation = (int)self.videoReader.videoOrientation ;
                if (self.videoReader.videoOrientation == FUVideoReaderOrientationLandscapeRight || self.videoReader.videoOrientation == FUVideoReaderOrientationLandscapeLeft) {
                    fuSetDefaultRotationMode([self setOrientationWithDegress:self.glView.origintation]);
                }
            }
            
            [self playAction:_playBtn];
        }
    }
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive    {
    
    if (self.navigationController.visibleViewController == self) {
        [_videoDecoder videoStopRending];
        if (self.image) {
            _displayLink.paused = YES ;
        }else {
            [self.videoReader stopReading];
            [_avPlayer pause];
            _avPlayer = nil;
        }
    }
}


- (void)didBecomeActive {
    if(_lvmuEditeView.mBgCollectionView.selectedIndex > 0){
        [_videoDecoder videoStartReading];
    }
    if (self.navigationController.visibleViewController == self && self.downloadBtn.hidden == YES) {//播放过程中
        [self.videoReader startReadWithDestinationPath:finalPath];
        self.playBtn.hidden = YES;
    }
    if (self.image) {
        [self processImage];
    }
}



-(void)setImage:(UIImage *)image {
    NSData *imageData0 = UIImageJPEGRepresentation(image, 1.0);
    UIImage *newImage = [UIImage imageWithData:imageData0];
    
    _image = newImage;
}

-(void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL ;
    
}


-(int)setOrientationWithDegress:(NSInteger)degress{
    switch (degress) {
        case 0:
            return 0;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
            
        case 3:
            return 1;
            break;
    }
    return 0;
}

#pragma  mark -  UI事件
-(void)downLoadAction:(UIButton *)sender {
    if (self.image) {   // 下载图片
        takePic = YES ;
    }else {             // 下载视频
        UISaveVideoAtPathToSavedPhotosAlbum(finalPath, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadBtn.hidden = YES ;
        });
    }
}

// 开始播放
- (void)playAction:(UIButton *)sender {
    sender.selected = YES ;
    sender.hidden = YES ;
    videHasRendered = NO;
    self.downloadBtn.hidden = YES ;
    
    /* 音频的播放 */
    if (_avPlayer) {
        [_avPlayer pause];
        _avPlayer = nil ;
    }
    _avPlayer = [[AVPlayer alloc] init];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.videoURL];
    [_avPlayer replaceCurrentItemWithPlayerItem:item];
    _avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [_avPlayer play];
    
    if (self.videoReader) {
        [self.videoReader setVideoURL:self.videoURL];
    }else {
        self.videoReader = [[FUVideoReader alloc] initWithVideoURL:self.videoURL];
        self.videoReader.delegate = self ;
    }
    [self.videoReader startReadWithDestinationPath:finalPath];
    
    self.glView.origintation = (int)self.videoReader.videoOrientation ;
    if (self.videoReader.videoOrientation == FUVideoReaderOrientationLandscapeRight || self.videoReader.videoOrientation == FUVideoReaderOrientationLandscapeLeft) {
        fuSetDefaultRotationMode([self setOrientationWithDegress:self.glView.origintation]);
    }
    
    if (self.model.type == FULiveModelTypeLvMu) {
        int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        int sdkOrientation = [self setOrientationWithDegress:(int)self.videoReader.videoOrientation];
        [FURenderer itemSetParam:handle withName:@"rotation_mode" value:@(sdkOrientation)];
    }
}


- (void)backAction:(UIButton *)sender {
    
    [self.videoReader stopReading];
    [self.videoReader destory];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)TouchDown{
    self.openComp = YES;
}

- (void)TouchUp{
    self.openComp = NO;
}

#pragma mark -   FUVideoReaderDelegate

-(void)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer {
    
    mPixelBuffer = pixelBuffer;
    if (!_openComp) {
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    }
    
    w = CVPixelBufferGetWidth(pixelBuffer);
    h = CVPixelBufferGetHeight(pixelBuffer);
    
    [self.glView displaySyncPixelBuffer:pixelBuffer];
    
    if(self.model.type != FULiveModelTypeLvMu){
        self.noTrackLabel.hidden = [[FUManager shareManager] isTracking];
    }else{
        self.noTrackLabel.hidden = YES;
    }
    
}


// 读取结束
-(void)videoReaderDidFinishReadSuccess:(BOOL)success {
    [self.videoReader startReadForLastFrame];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playBtn.hidden = NO ;
        
        if (self.model.type == FULiveModelTypeLvMu) {
            if (self.lvmuEditeView.isHidenTop) {
                self.downloadBtn.hidden = NO ;
            }else{
                self.downloadBtn.hidden = YES ;
            }
        }else{
            self.downloadBtn.hidden = NO;
        }
        
        if (self.model.type == FULiveModelTypeBeautifyFace) {
            self.downloadBtn.hidden = self.demoBar.isTopViewShow ;
        }
    });
    
    //    [self.videoReader startReadForLastFrame];
    videHasRendered = YES ;
}

#pragma  mark ---- process image

- (void)processImage  {
    
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setFrameInterval:10];
        _displayLink.paused = NO;
    }
    if (_displayLink.paused) {
        _displayLink.paused = NO ;
    }
}


- (void)displayLinkAction{
    __weak typeof(self)weakSelf  = self ;
    dispatch_async(renderQueue, ^{
        
        if(_displayLink == nil) return;//防止任务还被执行
        @autoreleasepool {//防止大图片，内存峰值过高
            UIImage *newImage = nil;
            if (!_openComp) {
                newImage = [[FUManager shareManager] renderItemsToImage:_image];
            }else{
                newImage = _image;
            }
            int postersWidth = (int)CGImageGetWidth(newImage.CGImage);
            int postersHeight = (int)CGImageGetHeight(newImage.CGImage);
            CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(newImage.CGImage));
            GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
            //        void *data =
            
            [weakSelf.glView displayImageData:imageData Size:CGSizeMake(postersWidth, postersHeight) Landmarks:NULL count:0 zoomScale:1];
            CFRelease(dataFromImageDataProvider);
            if (takePic) {
                takePic = NO ;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (newImage) {
                        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    }
                });
            }
        }
        
        if(self.model.type == FULiveModelTypeLvMu){
            dispatch_async(dispatch_get_main_queue(), ^{ 
              self.noTrackLabel.hidden = YES;
            });
            return ;
        }
        
        BOOL isTrack = [[FUManager shareManager] isTracking] ;
        
        if (!isTrack) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.noTrackLabel.text = FUNSLocalizedString(@"未识别到人脸", nil) ;
                if (self.noTrackLabel.hidden) {
                    self.noTrackLabel.hidden = NO ;
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!self.noTrackLabel.hidden) {
                    self.noTrackLabel.hidden = YES ;
                }
            });
        }
    });
}


#pragma  mark -  FUBodyBeautyViewDelegate
-(void)bodyBeautyViewDidSelectPosition:(FUPosition *)position{
    if (!position.bundleKey) {
        return;
    }
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBodySlim name:position.bundleKey value:position.value];
}


#pragma  mark -  FULvMuViewDataSource
-(UIColor *)lvMuViewTakeColorView:(CGPoint)screenP{
    CGPoint point =  [self.glView convertPoint:screenP fromView:self.view];
    return [self.glView getColorWithPoint:point];
}

#pragma  mark -  FULvMuViewDelegate

-(void)beautyCollectionView:(FULvMuView *)beautyView didSelectedParam:(FUBeautyParam *)param{
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        [FURenderer itemSetParam:lvmuHandle withName:param.mParam value:@(param.mValue)];
        
        NSLog(@"----%d---%@",lvmuHandle,param.mParam);
    });
}

-(void)colorDidSelectedR:(float)r G:(float)g B:(float)b A:(float)a{
    int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        static double color[4];
        color[0] = round(r * 255);
        color[1] = round(g * 255);
        color[2] = round(b * 255);
        color[3] = round(a * 255);
        
        [FURenderer itemSetParamdv:lvmuHandle withName:@"key_color" value:color length:4];
        NSLog(@"取色点位------rgba %f %f %f %f",r,g,b,a);
    });
}


-(void)lvmuViewShowTopView:(BOOL)shown{
    float h = shown?180:49;
    [self setPhotoScaleWithHeight:h show:shown];
    
    if(self.playBtn.isHidden && !shown){
        self.downloadBtn.hidden = NO;
    }else{
        self.downloadBtn.hidden = YES;
    }
}


- (void)setPhotoScaleWithHeight:(CGFloat)height show:(BOOL)shown {
    if (shown) {
        
        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, height * -0.6) ;
        CGAffineTransform photoTransform1 = CGAffineTransformMakeScale(0.9, 0.9);
        [UIView animateWithDuration:0.35 animations:^{
            
            self.downloadBtn.transform = CGAffineTransformConcat(photoTransform0, photoTransform1) ;
            
        }];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            self.downloadBtn.transform = CGAffineTransformIdentity ;
        }];
    }
}

-(void)didSelectedParam:(FUBeautyParam *)param{
    if(param.mParam){
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:param.mParam ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        [self setupVideoDecoder:url];
    }else{
        [_videoDecoder videoStopRending];
        int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
         fuDeleteTexForItem(lvmuHandle, (char *)[@"tex_bg" UTF8String]);
    }
}

/* 取色的时候，不rendder */
-(void)takeColorState:(FUTakeColorState)state{
    if (state == FUTakeColorStateStop) {
        [[FUManager shareManager] preventRenderingAarray:nil];
    }else{
        [[FUManager shareManager] preventRenderingAarray:@[@(FUNamaHandleTypeItem)]];
    }
}


-(void)setupVideoDecoder:(NSURL *)url{
    [_videoDecoder videoStopRending];
    _videoDecoder = nil;
    _videoDecoder = [[FUVideoDecoder alloc] initWithVideoDecodeUrl:url fps:30 repeat:YES callback:^(CVPixelBufferRef  _Nonnull pixelBuffer) {
        if(pixelBuffer){
            
            int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
            CVPixelBufferLockBaseAddress(pixelBuffer, 0);
            char *buffer = CVPixelBufferGetBaseAddress(pixelBuffer);
            int w = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
            int h = (int)CVPixelBufferGetHeight(pixelBuffer);
            [FURenderer itemSetParam:lvmuHandle withName:@"is_bgra" value:@(1)];
            /* 数据写入nama */
            //            fuDeleteTexForItem(lvmuHandle, (char *)[@"tex_bg" UTF8String]);
            fuCreateTexForItem(lvmuHandle, (char *)[@"tex_bg" UTF8String], buffer, w, h);
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        }
        
    }];
    [_videoDecoder videoStartReading];
}


/**设置美颜参数*/
#pragma mark -  FUAPIDemoBarDelegate

-(void)restDefaultValue:(int)type{
    if (type == 1) {//美肤
        [[FUManager shareManager] setBeautyDefaultParameters:FUBeautyModuleTypeSkin];
    }
    
    if (type == 2) {
        [[FUManager shareManager] setBeautyDefaultParameters:FUBeautyModuleTypeShape];
    }
    
}
-(void)showTopView:(BOOL)shown{
    if (shown) {
        _compBtn.hidden = NO;
        self.downloadBtn.hidden = YES ;
    }else {
        _compBtn.hidden = YES;
        if (self.image) {
            self.downloadBtn.hidden = NO ;
        }else {
            self.downloadBtn.hidden = !videHasRendered ;
        }
    }
}

//-(void)filterShowMessage:(NSString *)message{
//    self.tipLabel.hidden = NO;
//    self.tipLabel.text = message;
//    [FURenderImageViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
//    [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
//}

-(void)filterValueChange:(FUBeautyParam *)param{
    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBeauty];
    [FURenderer itemSetParam:handle withName:@"filter_name" value:[param.mParam lowercaseString]];
    [FURenderer itemSetParam:handle withName:@"filter_level" value:@(param.mValue)]; //滤镜程度
    
    [FUManager shareManager].seletedFliter = param;
}

-(void)beautyParamValueChange:(FUBeautyParam *)param{
    if (_demoBar.selBottomIndex == 3) {//风格栏
        if (param.beautyAllparams) {
            [[FUManager shareManager] setStyleBeautyParams:param.beautyAllparams];
            [FUManager shareManager].currentStyle = param;
        }else{// 点击无
            [FUManager shareManager].currentStyle = param;
            [[FUManager shareManager] setBeautyParameters];
        }

        return;
    }
    
    if ([param.mParam isEqualToString:@"cheek_narrow"] || [param.mParam isEqualToString:@"cheek_small"]){//程度值 只去一半
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBeauty name:param.mParam value:param.mValue * 0.5];
    }else if([param.mParam isEqualToString:@"blur_level"]) {//磨皮 0~6
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBeauty name:param.mParam value:param.mValue * 6];
    }else{
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBeauty name:param.mParam value:param.mValue];
    }
}


- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}


#pragma  mark ----  手势事件  -----
-(void)handlePanGesture:(UIPanGestureRecognizer *) panGesture{
    
    UIView *view = panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged){
        
        CGPoint translation = [panGesture translationInView:view.superview];
        
        float x ,y;
        
        int sdkOrientation = [self setOrientationWithDegress:(int)self.videoReader.videoOrientation];
        if (sdkOrientation == 0 || sdkOrientation == 2) {
            x = _lvRect.origin.x + translation.x/[UIScreen mainScreen].bounds.size.width;
            y = _lvRect.origin.y + translation.y/[UIScreen mainScreen].bounds.size.height;
            _lvRect.origin = CGPointMake(x,y);
        }else{
            x = _lvRect.origin.x + translation.y/[UIScreen mainScreen].bounds.size.height;
            y = _lvRect.origin.y - translation.x/[UIScreen mainScreen].bounds.size.width;
            _lvRect.origin = CGPointMake(x,y);
        }
        
        [self setLvFrameRect:_lvRect];
        
        [panGesture setTranslation:CGPointZero inView:view.superview];
        
    }
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture{
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        float w ,h,x,y;
        
        w = _lvRect.size.width * pinchGesture.scale;
        h = _lvRect.size.height * pinchGesture.scale;
        y = _lvRect.origin.y - (h - _lvRect.size.width)/2;
        x = _lvRect.origin.x - (w - _lvRect.size.width)/2;
        
        
        if (w <= 0.2) {
            w = 0.2;
            h = 0.2;
        }
        if (w >= 1.0) {
            x = 0;
            y = 0;
            w = 1.0;
            h = 1.0;
        }
        
        _lvRect = CGRectMake(x, y, w, h);
        [self setLvFrameRect:_lvRect];
        
        pinchGesture.scale = 1;
    }
}


-(void)setLvFrameRect:(CGRect)rect{
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        [FURenderer itemSetParam:lvmuHandle withName:@"start_x" value:@(rect.origin.x)];
        [FURenderer itemSetParam:lvmuHandle withName:@"start_y" value:@(rect.origin.y)];
        [FURenderer itemSetParam:lvmuHandle withName:@"end_x" value:@(rect.origin.x + rect.size.width)];
        [FURenderer itemSetParam:lvmuHandle withName:@"end_y" value:@(rect.origin.y + rect.size.height)];
        
        NSLog(@"移动---%f---%f---%f---%f",rect.origin.x,rect.origin.y,rect.origin.x + rect.size.width,rect.origin.y + rect.size.height);
    });
}



#pragma mark - FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    [[FUManager shareManager] loadItem:item completion:^(BOOL finished) {
        /* 设置成默认检测方向 */
        int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        int sdkOrientation = [self setOrientationWithDegress:(int)self.videoReader.videoOrientation];
        [FURenderer itemSetParam:handle withName:@"rotationMode" value:@(sdkOrientation)];
        [FURenderer itemSetParam:handle withName:@"rotMode" value:@(sdkOrientation)];
        [FURenderer itemSetParam:handle withName:@"freeRotMode" value:@(sdkOrientation)];
        [FURenderer itemSetParam:handle withName:@"rotationAngle" value:@(sdkOrientation * 90)];
        
        [self.itemsView stopAnimation];
    }];
    
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



- (CVPixelBufferRef) pixelBufferFromImage:(UIImage *)image {
    
    NSDictionary *options = @{
        (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
        (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
        (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
    };
    
    CVPixelBufferRef pxbuffer = NULL;
    CGFloat frameWidth = CGImageGetWidth(image.CGImage);
    CGFloat frameHeight = CGImageGetHeight(image.CGImage);
    CVReturn status = CVPixelBufferCreate(
                                          kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(
                                                 pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
    NSParameterAssert(context);
    
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    
    CGContextDrawImage(context, CGRectMake(0, 0, frameWidth, frameHeight), image.CGImage);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    //    CFRelease(rgbColorSpace) ;
    
    return pxbuffer;
}


- (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
    
    CGFloat SW = [UIScreen mainScreen].bounds.size.width;
    CGFloat SH = [UIScreen mainScreen].bounds.size.height;
    
    float width = CVPixelBufferGetWidth(pixelBufferRef);
    float height = CVPixelBufferGetHeight(pixelBufferRef);
    
    float dw = width / SW;
    float dh = height / SH;
    
    float cropW = width;
    float cropH = height;
    
    if (dw > dh) {
        cropW = SW * dh;
    }else
    {
        cropH = SH * dw;
    }
    
    CGFloat cropX = (width - cropW) * 0.5;
    CGFloat cropY = (height - cropH) * 0.5;
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(cropX, cropY,
                                                 cropW,
                                                 cropH)];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    return image;
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo  {
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:FUNSLocalizedString(@"保存图片失败", nil)];
    }else{
        [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"图片已保存到相册", nil)];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:FUNSLocalizedString(@"保存视频失败", nil)];
        
    }else{
        [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"视频已保存到相册", nil)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url
{
    NSUInteger degress = 0;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 0;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 2;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 1;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 3;
        }
    }
    
    
    return degress;
}

-(void)dealloc {
    self.image = nil ;
    self.videoURL = nil ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:finalPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:finalPath error:nil];
    }
    
    NSLog(@"render control dealloc");
}

@end
