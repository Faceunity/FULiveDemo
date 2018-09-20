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
#import <FUAPIDemoBar/FUAPIDemoBar.h>
#import "FUItemsView.h"

#define finalPath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"finalVideo.mp4"]

@interface FURenderImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, FUVideoReaderDelegate, FUAPIDemoBarDelegate, FUItemsViewDelegate>
{
    __block BOOL takePic ;
    
    BOOL videHasRendered ;
}

@property (nonatomic, strong) FULiveModel *model ;

@property (weak, nonatomic) IBOutlet FUOpenGLView *glView;
@property (nonatomic, strong) FUVideoReader *videoReader ;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet FUAPIDemoBar *demoBar;
@property (strong, nonatomic) IBOutlet FUItemsView *itemsView;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) AVPlayer *avPlayer;

// 定时器
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation FURenderImageViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
    
    self.model = [FUManager shareManager].currentModel;
    
    if (self.model.type == FULiveModelTypeBeautifyFace) {
         
        self.demoBar.hidden = NO ;
        [self.itemsView removeFromSuperview ];
        self.itemsView = nil ;
        
        self.downloadBtn.transform = CGAffineTransformMakeTranslation(0, 30) ;
    }else {
        self.demoBar.hidden = YES ;
        
        self.itemsView.delegate = self ;
        [self.view addSubview:self.itemsView];
        
        self.itemsView.itemsArray = self.model.items;
        
        NSString *item = self.model.items[0];
        self.itemsView.selectedItem = item;
        [[FUManager shareManager] loadItem:item];
    }
    
    self.videoReader = [[FUVideoReader alloc] init];
    self.videoReader.delegate = self ;
    
    takePic = NO ;
    videHasRendered = NO ;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startRendering];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.videoReader stopReading];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [_avPlayer pause];
    _avPlayer = nil ;
    [self.videoReader stopReading];
    _displayLink.paused = YES ;
    _displayLink = nil ;
    
    [super viewWillDisappear:animated];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.model.type == FULiveModelTypeBeautifyFace) {
        [self.demoBar hiddeTopView];
    }
}

- (void)startRendering {
    
    if (self.image ) {
        
        [self processImage];
    }else {
        
        if (self.videoURL) {
            
            self.downloadBtn.hidden = YES ;
            self.playBtn.hidden = NO ;
            
            [self.videoReader setVideoURL:self.videoURL];
            
            [self.videoReader startReadForFirstFrame];
        }
    }
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.model.type != FULiveModelTypeBeautifyFace) {
        
        // 适配 iPhone X
        CGRect frame = self.itemsView.frame ;
        frame.origin = [[[FUManager shareManager] getPlatformtype] isEqualToString:@"iPhone X"] ? CGPointMake(0, self.view.frame.size.height - 118) : CGPointMake(0, self.view.frame.size.height - 84) ; ;
        frame.size = CGSizeMake(self.view.frame.size.width, frame.size.height) ;
        self.itemsView.frame = frame ;
    }
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive    {
    
    if (self.navigationController.visibleViewController == self) {
        
        if (self.image) {
            _displayLink.paused = YES ;
        }else {
            [self.videoReader stopReading];
            [_avPlayer pause];
            _avPlayer = nil;
        }
    }
}

- (void)willEnterForeground {
    
    if (self.navigationController.visibleViewController == self) {
        [self startRendering];
    }
}

- (void)didBecomeActive {
    
    if (self.navigationController.visibleViewController == self) {
        [self startRendering];
    }
}

-(void)setImage:(UIImage *)image {
    _image = image ;
}

-(void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL ;
}

- (IBAction)downLoadAction:(UIButton *)sender {
    
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
- (IBAction)playAction:(UIButton *)sender {
    sender.selected = YES ;
    sender.hidden = YES ;
    
    self.downloadBtn.hidden = YES ;
    
    if (_avPlayer) {
        [_avPlayer pause];
        _avPlayer = nil ;
    }
    _avPlayer = [[AVPlayer alloc] init];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.videoURL];
    [_avPlayer replaceCurrentItemWithPlayerItem:item];
    _avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [_avPlayer play];
    [self.videoReader setVideoURL:self.videoURL];
    [self.videoReader startReadWithDestinationPath:finalPath];
}

#pragma mark ----   FUVideoReaderDelegate

-(void)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer {
    
    self.glView.contentMode = CVPixelBufferGetWidth(pixelBuffer) < CVPixelBufferGetHeight(pixelBuffer) ? FUOpenGLViewContentModeScaleAspectFill:FUOpenGLViewContentModeScaleAspectFit;
   
    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    
    [self.glView displayPixelBuffer:pixelBuffer];
}

// 读取结束
-(void)videoReaderDidFinishReadSuccess:(BOOL)success {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playBtn.hidden = NO ;
        self.downloadBtn.hidden = NO ;
        if (self.model.type == FULiveModelTypeBeautifyFace) {
            self.downloadBtn.hidden = self.demoBar.isTopViewShow ;
        }
    });
    
    [self.videoReader startReadForLastFrame];
    videHasRendered = YES ;
}

#pragma  mark ---- process image

- (void)processImage  {
    
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setFrameInterval:4];
        _displayLink.paused = NO;
    }
    if (_displayLink.paused) {
        _displayLink.paused = NO ;
    }
}

- (void)displayLinkAction {
    __weak typeof(self)weakSelf  = self ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CVPixelBufferRef pixelBuffer = [weakSelf pixelBufferFromImage:self.image];
        
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        
        [weakSelf.glView displayPixelBuffer:pixelBuffer];
        
        BOOL isTrack = [[FUManager shareManager] isTracking] ;
        
        if (!isTrack) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.tipLabel.text = @"未识别到人脸" ;
                if (self.tipLabel.hidden) {
                    self.tipLabel.hidden = NO ;
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!self.tipLabel.hidden) {
                    self.tipLabel.hidden = YES ;
                }
            });
        }
        
        if (takePic) {
            takePic = NO ;
            
            CFRetain(pixelBuffer) ;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{

                UIImage *image = [self imageFromPixelBuffer:pixelBuffer];
                if (image) {
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }

                CFRelease(pixelBuffer) ;
            });
        }
        CFRelease(pixelBuffer) ;
    });
}

-(void)setDemoBar:(FUAPIDemoBar *)demoBar {
    _demoBar = demoBar;
    [self demoBarSetBeautyDefultParams];
}

- (void)demoBarSetBeautyDefultParams {
    _demoBar.delegate = nil ;
    _demoBar.skinDetect = [FUManager shareManager].skinDetectEnable;
    _demoBar.blurLevel = [FUManager shareManager].blurShape ;
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
    _demoBar.performance = NO ;
    _demoBar.delegate = self;
}

#pragma mark --- FUAPIDemoBarDelegate
/**设置美颜参数*/
- (void)demoBarBeautyParamChanged   {
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
    
    self.tipLabel.hidden = NO;
    self.tipLabel.text = message;
    [FURenderImageViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
    [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
}

-(void)demoBarDidShowTopView:(BOOL)shown {
    
    if (shown) {
        self.downloadBtn.hidden = YES ;
    }else {
        if (self.image) {
            self.downloadBtn.hidden = NO ;
        }else {
            self.downloadBtn.hidden = !videHasRendered ;
        }
    }
}

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}
#pragma mark --- FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    
    [[FUManager shareManager] loadItem:item];
    
    [self.itemsView stopAnimation];
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
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"图片已保存到相册"];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:@"保存视频失败"];
        
    }else{
        [SVProgressHUD showSuccessWithStatus:@"视频已保存到相册"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    self.image = nil ;
    self.videoURL = nil ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:finalPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:finalPath error:nil];
    }
}

@end
