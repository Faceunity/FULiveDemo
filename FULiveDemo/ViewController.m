//
//  ViewController.m
//  FUAPIDemo
//
//  Created by 刘洋 on 2017/1/9.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import "FUCamera.h"
#import <FUAPIDemoBar/FUAPIDemoBar.h>

#import "FURenderer.h"
#include <sys/mman.h>
#include <sys/stat.h>
#import "authpack.h"

@interface ViewController ()<FUAPIDemoBarDelegate,FUCameraDelegate>
{
    //MARK: Faceunity
    int items[3];
    int frameID;
    
    // --------------- Faceunity ----------------
    
    FUCamera *curCamera;
}
@property (weak, nonatomic) IBOutlet FUAPIDemoBar *demoBar;//工具条

@property (nonatomic, strong) FUCamera *bgraCamera;//BGRA摄像头

@property (nonatomic, strong) FUCamera *yuvCamera;//YUV摄像头

@property (nonatomic, strong) AVSampleBufferDisplayLayer *bufferDisplayer;

@property (weak, nonatomic) IBOutlet UILabel *noTrackView;

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;

@property (weak, nonatomic) IBOutlet UIButton *barBtn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIButton *changeCameraBtn;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addObserver];
    
    [self initFaceunity];
    
    curCamera = self.bgraCamera;
    [curCamera startUp];
    
    self.bufferDisplayer.frame = self.view.bounds;
    
}

- (void)initFaceunity
{
    #warning faceunity全局只需要初始化一次
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        int size = 0;
        
        void *v3 = [self mmap_bundle:@"v3.bundle" psize:&size];
        
        #warning 这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。如果设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。
        
        [[FURenderer shareRenderer] setupWithData:v3 ardata:NULL authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
    });
    
    //开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内）
    [FURenderer setMaxFaces:4];
    
    [self loadItem];
    [self loadFilter];
}

- (void)destoryFaceunityItems
{
    
    [FURenderer destroyAllItems];
    
    for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
        items[i] = 0;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self destoryFaceunityItems];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

//底部工具条
- (void)setDemoBar:(FUAPIDemoBar *)demoBar
{
    _demoBar = demoBar;
    _demoBar.itemsDataSource = @[@"noitem", @"tiara", @"item0208", @"YellowEar", @"PrincessCrown", @"Mood" , @"Deer" , @"BeagleDog", @"item0501", @"item0210",  @"HappyRabbi", @"item0204", @"hartshorn", @"ColorCrown"];
    _demoBar.selectedItem = _demoBar.itemsDataSource[1];

    _demoBar.filtersDataSource = @[@"nature", @"delta", @"electric", @"slowlived", @"tokyo", @"warm"];
    _demoBar.selectedFilter = _demoBar.filtersDataSource[0];

    _demoBar.selectedBlur = 6;

    _demoBar.beautyLevel = 0.2;
    
    _demoBar.thinningLevel = 1.0;
    
    _demoBar.enlargingLevel = 0.5;
    
    _demoBar.faceShapeLevel = 0.5;
    
    _demoBar.faceShape = 3;
    
    _demoBar.redLevel = 0.5;

    _demoBar.delegate = self;
}

//bgra摄像头
- (FUCamera *)bgraCamera
{
    if (!_bgraCamera) {
        _bgraCamera = [[FUCamera alloc] init];
        
        _bgraCamera.delegate = self;
        
    }
    
    return _bgraCamera;
}

//yuv摄像头
- (FUCamera *)yuvCamera
{
    if (!_yuvCamera) {
        _yuvCamera = [[FUCamera alloc] initWithCameraPosition:AVCaptureDevicePositionFront captureFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
        
        _yuvCamera.delegate = self;
    }
    
    return _yuvCamera;
}

//显示摄像头画面
- (AVSampleBufferDisplayLayer *)bufferDisplayer
{
    if (!_bufferDisplayer) {
        _bufferDisplayer = [[AVSampleBufferDisplayLayer alloc] init];
        _bufferDisplayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _bufferDisplayer.frame = self.view.bounds;
        
        [self.view.layer insertSublayer:_bufferDisplayer atIndex:0];
    }
    
    return _bufferDisplayer;
}

- (void)willResignActive
{
    
    [curCamera stopCapture];
    
}

- (void)willEnterForeground
{
    
    [curCamera startCapture];
}

- (void)didBecomeActive
{
    static BOOL firstActive = YES;
    if (firstActive) {
        firstActive = NO;
        return;
    }
    [curCamera startCapture];
}

//拍照
- (IBAction)takePhoto
{
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
    
    [curCamera takePhotoAndSave];
}

#pragma -显示工具栏
- (IBAction)filterBtnClick:(UIButton *)sender {
    self.barBtn.hidden = YES;
    self.photoBtn.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.demoBar.transform = CGAffineTransformMakeTranslation(0, -self.demoBar.frame.size.height);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches allObjects].firstObject;
    if (touch.view != self.view) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.demoBar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.barBtn.hidden = NO;
        self.photoBtn.hidden = NO;
    }];
}

#pragma -摄像头切换
- (IBAction)changeCamera:(UIButton *)sender {
    
    [self.bgraCamera changeCameraInputDeviceisFront:!self.bgraCamera.isFrontCamera];
    [self.yuvCamera changeCameraInputDeviceisFront:!self.yuvCamera.isFrontCamera];
    [curCamera startCapture];
    
#warning 切换摄像头要调用此函数
    [FURenderer onCameraChange];
}

#pragma -BGRA/YUV切换
- (IBAction)changeCaptureFormat:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0 && curCamera == self.yuvCamera)
    {
        [curCamera stopCapture];
        curCamera = self.bgraCamera;
    }else if (sender.selectedSegmentIndex == 1 && curCamera == self.bgraCamera){
        [curCamera stopCapture];
        curCamera = self.yuvCamera;
    }
    [curCamera startCapture];
    
}

#pragma -FUAPIDemoBarDelegate
- (void)demoBarDidSelectedItem:(NSString *)item
{
    //异步加载道具
    [self loadItem];
}

#pragma -FUCameraDelegate
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    
    //人脸跟踪
    int curTrack = [FURenderer isTracking];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackView.hidden = curTrack;
    });
    
    #warning 如果需开启手势检测，请打开下方的注释
    /*
     if (items[2] == 0) {
     [self loadHeart];
     }
     */
    
    /*设置美颜效果（滤镜、磨皮、美白、瘦脸、大眼....）*/
    [FURenderer itemSetParam:items[1] withName:@"cheek_thinning" value:@(self.demoBar.thinningLevel)]; //瘦脸
    [FURenderer itemSetParam:items[1] withName:@"eye_enlarging" value:@(self.demoBar.enlargingLevel)]; //大眼
    [FURenderer itemSetParam:items[1] withName:@"color_level" value:@(self.demoBar.beautyLevel)]; //美白
    [FURenderer itemSetParam:items[1] withName:@"filter_name" value:_demoBar.selectedFilter]; //滤镜
    [FURenderer itemSetParam:items[1] withName:@"blur_level" value:@(self.demoBar.selectedBlur)]; //磨皮
    [FURenderer itemSetParam:items[1] withName:@"face_shape" value:@(self.demoBar.faceShape)]; //瘦脸类型
    [FURenderer itemSetParam:items[1] withName:@"face_shape_level" value:@(self.demoBar.faceShapeLevel)]; //瘦脸等级
    [FURenderer itemSetParam:items[1] withName:@"red_level" value:@(self.demoBar.redLevel)]; //红润
    
    //Faceunity核心接口，将道具及美颜效果作用到图像中，执行完此函数pixelBuffer即包含美颜及贴纸效果
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:3 flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    
    #warning 执行完上一步骤，即可将pixelBuffer绘制到屏幕上或推流到服务器进行直播
    //本地显示视频图像
    
    CFRetain(sampleBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.bufferDisplayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
            [self.bufferDisplayer flush];
        }
        
        if ([self.bufferDisplayer isReadyForMoreMediaData]) {
            [self.bufferDisplayer enqueueSampleBuffer:sampleBuffer];
        }
        
        CFRelease(sampleBuffer);
    });
}

#pragma -Faceunity Load Data
- (void)loadItem
{
    if ([_demoBar.selectedItem isEqual: @"noitem"] || _demoBar.selectedItem == nil)
    {
        if (items[0] != 0) {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[0]];
        }
        items[0] = 0;
        return;
    }
    
    int size = 0;
    
    // 先创建再释放可以有效缓解切换道具卡顿问题
    void *data = [self mmap_bundle:[_demoBar.selectedItem stringByAppendingString:@".bundle"] psize:&size];
    
    int itemHandle = [FURenderer createItemFromPackage:data size:size];
    
    if (items[0] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[0]];
    }
    
    items[0] = itemHandle;
    
    NSLog(@"faceunity: load item");
}

- (void)loadFilter
{
    
    int size = 0;
    
    void *data = [self mmap_bundle:@"face_beautification.bundle" psize:&size];
    
    items[1] = [FURenderer createItemFromPackage:data size:size];
}

- (void)loadHeart
{
    int size = 0;
    
    void *data = [self mmap_bundle:@"heart_v2.bundle" psize:&size];
    
    items[2] = [FURenderer createItemFromPackage:data size:size];
}

- (void *)mmap_bundle:(NSString *)bundle psize:(int *)psize {
    
    // Load item from predefined item bundle
    NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundle];
    const char *fn = [str UTF8String];
    int fd = open(fn,O_RDONLY);
    
    int size = 0;
    void* zip = NULL;
    
    if (fd == -1) {
        NSLog(@"faceunity: failed to open bundle");
        size = 0;
    }else
    {
        size = [self getFileSize:fd];
        zip = mmap(nil, size, PROT_READ, MAP_SHARED, fd, 0);
        close(fd);
    }
    
    *psize = size;
    return zip;
}

- (int)getFileSize:(int)fd
{
    struct stat sb;
    sb.st_size = 0;
    fstat(fd, &sb);
    return (int)sb.st_size;
}

@end

