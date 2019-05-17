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

#define finalPath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"finalVideo.mp4"]

@interface FURenderImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, FUVideoReaderDelegate, FUAPIDemoBarDelegate, FUItemsViewDelegate,FUMakeUpViewDelegate>
{
    __block BOOL takePic ;
    
    BOOL videHasRendered ;
    
    dispatch_queue_t renderQueue;
}

@property (nonatomic, strong) FULiveModel *model ;

@property (strong, nonatomic) FUOpenGLView *glView;
@property (nonatomic, strong) FUVideoReader *videoReader ;

@property (strong, nonatomic) UIButton *playBtn;

@property (strong, nonatomic) FUAPIDemoBar *demoBar;
@property (strong, nonatomic) FUItemsView *itemsView;

@property (strong, nonatomic) UIButton *downloadBtn;
@property (strong, nonatomic)  UILabel *tipLabel;
@property (nonatomic, strong) AVPlayer *avPlayer;

// 定时器
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic,assign) NSInteger  degress;
@end

@implementation FURenderImageViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
     renderQueue = dispatch_queue_create("com.faceUMakeup", DISPATCH_QUEUE_SERIAL);
    [self addObserver];
    
    [self setupView];
    
    self.model = [FUManager shareManager].currentModel;
    
    if (self.model.type == FULiveModelTypeBeautifyFace) {
        
        self.demoBar.hidden = NO ;
        [self.itemsView removeFromSuperview ];
        self.itemsView = nil ;
        
        self.downloadBtn.transform = CGAffineTransformMakeTranslation(0, 30) ;
        /* 轻美妆 */
        [[FUManager shareManager] loadMakeupBundleWithName:@"light_makeup"];
        
    }else {
        self.demoBar.hidden = YES ;
        
        self.itemsView.delegate = self ;
        [self.view addSubview:self.itemsView];
        [self.itemsView updateCollectionArray:self.model.items];
        
        NSString *item = self.model.items[0];
        self.itemsView.selectedItem = item;
        [[FUManager shareManager] loadItem:item];
    }
    
    takePic = NO ;
    videHasRendered = NO ;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startRendering];
}

-(void)setupView{
    /* opengl */
    _glView = [[FUOpenGLView alloc] initWithFrame:self.view.bounds];
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
    /* 提示 */
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:17];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(22);
    }];
    
    /* 美颜调节 */
    _demoBar = [[FUAPIDemoBar alloc] init];
    _demoBar.performance = [FUManager shareManager].performance;
    [self demoBarSetBeautyDefultParams];
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
    [_downloadBtn setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
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
    [self.itemsView updateCollectionArray:self.model.items];
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(84);
    }];
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
    [super viewWillDisappear:animated];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.model.type == FULiveModelTypeBeautifyFace) {
        [self.demoBar hiddeTopView];
    }
}

- (void)startRendering {
    [FURenderer onCameraChange];
    if (self.image ) {
        
        [self processImage];
    }else {
        
        if (self.videoURL) {
            
            self.downloadBtn.hidden = YES ;
            self.playBtn.hidden = NO ;
            
            if (self.videoReader) {
                
                [self.videoReader setVideoURL:self.videoURL];
            }else {
                
                self.videoReader = [[FUVideoReader alloc] initWithVideoURL:self.videoURL];
                self.videoReader.delegate = self ;
                self.glView.origintation = (int)self.videoReader.videoOrientation ;
            }
            
            [self.videoReader startReadForFirstFrame];
        }
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
    _image = image;
}

-(void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL ;
    
    self.degress = [self degressFromVideoFileWithURL:videoURL];
    
    _glView.origintation = self.degress;
//    degressFromVideoFileWithURL
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
        self.glView.origintation = (int)self.videoReader.videoOrientation ;
    }else {
        self.videoReader = [[FUVideoReader alloc] initWithVideoURL:self.videoURL];
        self.videoReader.delegate = self ;
        self.glView.origintation = (int)self.videoReader.videoOrientation ;
    }
    [self.videoReader startReadWithDestinationPath:finalPath];
}


- (void)backAction:(UIButton *)sender {
    
    [self.videoReader stopReading];
    [self.videoReader destory];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -   FUVideoReaderDelegate

-(void)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer {
   
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
        [_displayLink setFrameInterval:30];
        _displayLink.paused = NO;
    }
    if (_displayLink.paused) {
        _displayLink.paused = NO ;
    }
}

- (void)displayLinkAction{
    __weak typeof(self)weakSelf  = self ;
    
    dispatch_async(renderQueue, ^{
        NSData *imageData0 = UIImageJPEGRepresentation(self.image, 1.0);
        UIImage *mPhotoImage = [UIImage imageWithData:imageData0];
        [[FUManager shareManager] resetAllBeautyParams];
        UIImage *newImage = [[FUManager shareManager] renderItemsToImage:mPhotoImage];
        int postersWidth = (int)CGImageGetWidth(newImage.CGImage);
        int postersHeight = (int)CGImageGetHeight(newImage.CGImage);
        CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(newImage.CGImage));
        GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
        //        void *data =
        
        [weakSelf.glView displayImageData:imageData Size:CGSizeMake(postersWidth, postersHeight) Landmarks:NULL count:0];
        CFRelease(dataFromImageDataProvider);
        BOOL isTrack = [[FUManager shareManager] isTracking] ;
        
        if (!isTrack) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.tipLabel.text = NSLocalizedString(@"未识别到人脸", nil) ;
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
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (newImage) {
                    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }
            });
        }

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
    _demoBar.selectedFilterLevel = [FUManager shareManager].selectedFilterLevel;
    _demoBar.performance = [FUManager shareManager].performance ;
    _demoBar.delegate = self;
    _demoBar.demoBar.makeupView.delegate = self;
}

#pragma mark - FUAPIDemoBarDelegate
/**设置美颜参数*/
- (void)demoBarBeautyParamChanged   {
    [self syncBeautyParams];
    [[FUManager shareManager] resetAllBeautyParams];
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
    
    /* 暂时解决展示表中，没有显示滤镜，引起bug */
    if (![[FUManager shareManager].beautyFiltersDataSource containsObject:_demoBar.selectedFilter]) {
        return;
    }
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
#pragma mark - FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    
    [[FUManager shareManager] loadItem:item];
    
    [self.itemsView stopAnimation];
}

#pragma mark -  FUMakeUpViewDelegate
- (void)makeupViewDidSelectedItemName:(NSString *)itemName namaStr:(NSString *)namaStr isLip:(BOOL)isLip{
    if (!itemName || [itemName isEqualToString:@""]) {
        return;
    }
    if (isLip) {
        NSArray *rgba = [self jsonToLipRgbaArrayResName:itemName];
        double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
        [[FUManager shareManager] setMakeupItemLipstick:lip];
    }else{
        UIImage *namaImage = [UIImage imageNamed:itemName];
        if (!namaImage) {
            return;
        }
        [[FUManager shareManager] setMakeupItemParamImage:[UIImage imageNamed:itemName]  param:namaStr];
    }
}

-(void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr{
    
    [[FUManager shareManager] setMakeupItemIntensity:value param:namaStr];
    
}

-(void)makeupFilter:(NSString *)filterStr value:(float)filterValue{
    if(!filterStr || [filterStr isEqualToString:@""]){
        return;
    }
    self.demoBar.selectedFilter = filterStr;
    self.demoBar.selectedFilterLevel = filterValue;
    [FUManager shareManager].selectedFilter = filterStr ;
    [FUManager shareManager].selectedFilterLevel = filterValue;
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
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存图片失败", nil)];
    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片已保存到相册", nil)];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存视频失败", nil)];
        
    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"视频已保存到相册", nil)];
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
            degress = 1;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 3;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 2;
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
}

@end
