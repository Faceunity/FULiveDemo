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
#import "authpack.h"
#import "PhotoButton.h"
#import "FUOpenglView.h"

@interface ViewController ()<FUAPIDemoBarDelegate,FUCameraDelegate, PhotoButtonDelegate>
{
    
    BOOL enableHeart;
    BOOL enableMaxFaces;
    
    //MARK: Faceunity
    int items[3];
    int frameID;
    
    BOOL isAvatar;
    // --------------- Faceunity ----------------
}
@property (weak, nonatomic) IBOutlet FUAPIDemoBar *demoBar;//工具条

@property (nonatomic, strong) FUCamera *mCamera;//摄像头

@property (nonatomic, strong) AVSampleBufferDisplayLayer *bufferDisplayer;

@property (weak, nonatomic) IBOutlet UILabel *noTrackView;

@property (weak, nonatomic) IBOutlet PhotoButton *photoBtn;

@property (weak, nonatomic) IBOutlet UIButton *barBtn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIButton *changeCameraBtn;

@property (weak, nonatomic) IBOutlet FUOpenGLView *glView;

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
    
    enableHeart = NO;
    enableMaxFaces = NO;
    
    self.photoBtn.delegate = self ;
    
    [self initFaceunity];
    
    [self.mCamera startCapture];
    
    self.bufferDisplayer.frame = self.view.bounds;
    
    self.glView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mCamera startCapture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mCamera stopCapture];
    
    [super viewWillDisappear:animated];
}

- (void)initFaceunity
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"v3.bundle" ofType:nil];
    
    /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
     还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
    [[FURenderer shareRenderer] setupWithDataPath:path authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
    
    /**加载普通道具*/
    [self reLoadItem];
    
    /**加载美颜道具*/
    [self loadFilter];
    
    /**开启手势识别*/
    if (enableHeart) {
        [self loadGesture];
    }
    
    /**开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内*/
    if (enableMaxFaces) {
        [FURenderer setMaxFaces:4];
    }
}

/**销毁全部道具*/
- (void)destoryFaceunityItems
{
    [FURenderer destroyAllItems];
    
    /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
    for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
        items[i] = 0;
    }
    
    /**销毁道具后，清除context缓存*/
    fuOnDeviceLost();
    
    /**销毁道具后，重置人脸检测*/
    [FURenderer onCameraChange];
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

/**
 Faceunity道具美颜工具条
 初始化 FUAPIDemoBar，设置初始美颜参数
 
 @param demoBar FUAPIDemoBar不是我们的交付内容，它的作用仅局限于我们的Demo演示，客户可以选择使用，但我们不会提供与之相关的技术支持或定制需求开发
 */
- (void)setDemoBar:(FUAPIDemoBar *)demoBar
{
    _demoBar = demoBar;
    
    _demoBar.itemsDataSource = @[@"noitem", @"EatRabbi", @"lixiaolong", @"mask_matianyu", @"Mood", @"yazui", @"yuguan"];
    _demoBar.selectedItem = _demoBar.itemsDataSource[1]; //贴纸道具
    
    _demoBar.filtersDataSource = @[@"nature", @"delta", @"electric", @"slowlived", @"tokyo", @"warm"];
    _demoBar.selectedFilter = _demoBar.filtersDataSource[0]; //滤镜效果
    
    _demoBar.selectedBlur = 6; //磨皮程度
    
    _demoBar.beautyLevel = 0.2; //美白程度
    
    _demoBar.redLevel = 0.5; //红润程度
    
    _demoBar.thinningLevel = 1.0; //瘦脸程度
    
    _demoBar.enlargingLevel = 0.5; //大眼程度
    
    _demoBar.faceShapeLevel = 0.5; //美型程度
    
    _demoBar.faceShape = 3; //美型类型
    
    _demoBar.delegate = self;
}

/**
 摄像头，默认前置摄像头，采集BGRA格式视频
 
 @return FUCamera
 */
- (FUCamera *)mCamera
{
    if (!_mCamera) {
        _mCamera = [[FUCamera alloc] init];
        
        _mCamera.delegate = self;
        
    }
    
    return _mCamera;
}

//显示摄像头画面
- (AVSampleBufferDisplayLayer *)bufferDisplayer
{
    if (!_bufferDisplayer) {
        
        _bufferDisplayer = [[AVSampleBufferDisplayLayer alloc] init];
        _bufferDisplayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _bufferDisplayer.frame = self.view.bounds;
            [self.view.layer insertSublayer:_bufferDisplayer atIndex:0];
        });
    }
    
    return _bufferDisplayer;
}


- (void)willResignActive
{
    [_mCamera stopCapture];
}

- (void)willEnterForeground
{
    [_mCamera startCapture];
}

- (void)didBecomeActive
{
    [_mCamera startCapture];
}

-(void)takePhoto {
    
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

-(void)startRecord {
    self.barBtn.enabled = NO;
    self.segment.enabled = NO;
    self.changeCameraBtn.enabled = NO;
    [self.mCamera startRecord];
}

-(void)stopRecord {
    
    self.barBtn.enabled = YES;
    self.segment.enabled = YES;
    self.changeCameraBtn.enabled = YES;
    [self.mCamera stopRecord];
}

#pragma -显示工具栏
- (IBAction)filterBtnClick:(UIButton *)sender {
    self.barBtn.hidden = YES;
    self.photoBtn.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.demoBar.transform = CGAffineTransformMakeTranslation(0, -self.demoBar.frame.size.height);
    }];
}

#pragma -隐藏工具栏
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

#pragma -BGRA/YUV切换
- (IBAction)changeCaptureFormat:(UISegmentedControl *)sender {
    
    _mCamera.captureFormat = _mCamera.captureFormat == kCVPixelFormatType_32BGRA ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:kCVPixelFormatType_32BGRA;
    
}

#pragma -摄像头切换
- (IBAction)changeCamera:(UIButton *)sender {
    
    [_mCamera changeCameraInputDeviceisFront:!_mCamera.isFrontCamera];
    
    /**切换摄像头要调用此函数*/
    [FURenderer onCameraChange];
}


#pragma -FUAPIDemoBarDelegate
- (void)demoBarDidSelectedItem:(NSString *)item
{
    if ([_demoBar.selectedItem isEqual: @"noitem"] || _demoBar.selectedItem == nil)
    {
        if (items[0] != 0) {
            
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[0]];
            
            /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[0]设为0*/
            items[0] = 0;
        }
        return;
    }
    
    //异步加载道具
    [self reLoadItem];
}

#pragma -FUCameraDelegate
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    if (isAvatar)/**avatar绘制模式*/
    {
        [self renderAvatarToPixelBuffer:pixelBuffer];
    }
    else/**普通模式*/
    {
        /*设置美颜效果（滤镜、磨皮、美白、红润、瘦脸、大眼....）*/
        [FURenderer itemSetParam:items[1] withName:@"filter_name" value:_demoBar.selectedFilter]; //滤镜名称
        [FURenderer itemSetParam:items[1] withName:@"blur_level" value:@(self.demoBar.selectedBlur)]; //磨皮 (0、1、2、3、4、5、6)
        [FURenderer itemSetParam:items[1] withName:@"color_level" value:@(self.demoBar.beautyLevel)]; //美白 (0~1)
        [FURenderer itemSetParam:items[1] withName:@"red_level" value:@(self.demoBar.redLevel)]; //红润 (0~1)
        [FURenderer itemSetParam:items[1] withName:@"face_shape" value:@(self.demoBar.faceShape)]; //美型类型 (0、1、2、3) 默认：3，女神：0，网红：1，自然：2
        [FURenderer itemSetParam:items[1] withName:@"face_shape_level" value:@(self.demoBar.faceShapeLevel)]; //美型等级 (0~1)
        [FURenderer itemSetParam:items[1] withName:@"eye_enlarging" value:@(self.demoBar.enlargingLevel)]; //大眼 (0~1)
        [FURenderer itemSetParam:items[1] withName:@"cheek_thinning" value:@(self.demoBar.thinningLevel)]; //瘦脸 (0~1)
        
        /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/
        [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:3 flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
        frameID += 1;
    }
    
    /**执行完上一步骤，即可将pixelBuffer绘制到屏幕上或推流到服务器进行直播
     由于我们直接修改了pixelBuffer，相当于sampleBuffer也被修改了，下面我们直接通过sampleBuffer进行本地预览*/
    [self disPlaySampleBuffer:sampleBuffer];
    
    //判断是否检测到人脸
    int curTrack = [FURenderer isTracking];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackView.hidden = curTrack > 0;
    });
}

/**
 画面预览
 */
- (void)disPlaySampleBuffer:(CMSampleBufferRef)sampleBuffer
{
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

/**
 avatar模式绘制方法
 */
- (void)renderAvatarToPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    OSType type = CVPixelBufferGetPixelFormatType(pixelBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    if (type == kCVPixelFormatType_32BGRA)
    {
        int h = (int)CVPixelBufferGetHeight(pixelBuffer);
        int stride = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
        int* bytes = (int*)CVPixelBufferGetBaseAddress(pixelBuffer);
        
        [FURenderer trackFace:FU_FORMAT_BGRA_BUFFER inputData:bytes width:stride / 4 height:h];
    
        [self displayLandmarksWithPixelBuffer:pixelBuffer];
        
        [self getAvatarInfo:^(TAvatarInfo info) {
            [[FURenderer shareRenderer] setUpCurrentContext];
            fuRenderItemsEx(FU_FORMAT_BGRA_BUFFER, bytes, FU_FORMAT_AVATAR_INFO, &info, stride / 4, h, frameID, items, 1);
            [[FURenderer shareRenderer] setBackCurrentContext];
        }];
        
    }else{
        
        int h = (int)CVPixelBufferGetHeight(pixelBuffer);
        int w = (int)CVPixelBufferGetWidth(pixelBuffer);
        int strideY = (int)CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer,0);
        int strideUV = (int)CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer,1);
        int* imgY = (int*)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer,0);
        int* imgUV = (int*)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer,1);
        
        __block TNV12Buffer nv12;
        nv12.p_Y = imgY;
        nv12.p_CbCr = imgUV;
        nv12.stride_Y = strideY;
        nv12.stride_CbCr = strideUV;
        
        [FURenderer trackFace:FU_FORMAT_NV12_BUFFER inputData:&nv12 width:w height:h];
        
        [self displayLandmarksWithPixelBuffer:pixelBuffer];
        
        [self getAvatarInfo:^(TAvatarInfo info) {
            [[FURenderer shareRenderer] setUpCurrentContext];
            fuRenderItemsEx(FU_FORMAT_NV12_BUFFER, &nv12, FU_FORMAT_AVATAR_INFO, &info, w, h, frameID, items, 1);
            [[FURenderer shareRenderer] setBackCurrentContext];
        }];
        
    }
    frameID += 1;
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

/**
 显示lanmarks预览
 */
- (void)displayLandmarksWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    float landmarks[150];
    int ret = fuGetFaceInfo(0, "landmarks", landmarks, 150);
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
    
    [self.glView displayPixelBuffer:pixelBuffer withLandmarks:landmarks count:150];
}

/**
 获取人脸信息
 */
- (void)getAvatarInfo:(void (^)(TAvatarInfo info))result
{
    float expression[46];
    if (fuGetFaceInfo(0, "expression", expression, 46) == 0)
    {
        memset(expression, 0, sizeof(float)*46);
    }
    
    float translation[3];
    if (fuGetFaceInfo(0, "translation", translation, 3) == 0 ){
        memset(translation, 0, sizeof(float)*3);
    }
    
    float rotation[4];
    if (fuGetFaceInfo(0, "rotation", rotation, 4) == 0 ){
        memset(rotation, 0, sizeof(float)*4);
    }
    
    float rotation_mode[1];
    if (fuGetFaceInfo(0, "rotation_mode", rotation_mode, 1) == 0 ){
        memset(rotation_mode, 0, sizeof(float)*1);
    }
    
    float pupil_pos[2];
    if (fuGetFaceInfo(0, "pupil_pos", pupil_pos, 2) == 0 ){
        memset(pupil_pos, 0, sizeof(float)*2);
    }
    
    TAvatarInfo info;
    info.p_rotation = rotation;
    info.p_expression = expression;
    info.rotation_mode = rotation_mode;
    info.p_translation = translation;
    info.pupil_pos = pupil_pos;
    info.is_valid = fuIsTracking();

    result(info);
}

#pragma -Faceunity Load Data
/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)reLoadItem
{
    NSString *itemName = _demoBar.selectedItem;
    
    /**先创建道具句柄*/
    NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
    int itemHandle = [FURenderer itemWithContentsOfFile:path];
    
    /**销毁老的道具句柄*/
    if (items[0] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[0]];
    }
    
    /**将刚刚创建的句柄存放在items[0]中*/
    items[0] = itemHandle;
    
    NSLog(@"faceunity: load item");
    
    isAvatar = [itemName isEqualToString:@"lixiaolong"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.glView.hidden = !isAvatar;
    });
}

/**加载美颜道具*/
- (void)loadFilter
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
    
    items[1] = [FURenderer itemWithContentsOfFile:path];
}

/**加载手势识别道具，默认未不加载*/
- (void)loadGesture
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"heart_v2.bundle" ofType:nil];
    
    items[2] = [FURenderer itemWithContentsOfFile:path];
}

@end


