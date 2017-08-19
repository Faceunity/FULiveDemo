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
#import "PhotoButton.h"
#import "FUOpenglView.h"
#import "FUManager.h"

@interface ViewController ()<FUAPIDemoBarDelegate,FUCameraDelegate, PhotoButtonDelegate>

@property (nonatomic, assign)     BOOL isAvatar;              /**判断当前加载的道具是否为avatar道具*/

@property (weak, nonatomic) IBOutlet FUAPIDemoBar *demoBar;//工具条

@property (nonatomic, strong) FUCamera *mCamera;//摄像头

@property (weak, nonatomic) IBOutlet UILabel *noTrackView;

@property (weak, nonatomic) IBOutlet PhotoButton *photoBtn;

@property (weak, nonatomic) IBOutlet UIButton *barBtn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIButton *changeCameraBtn;

@property (strong, nonatomic) IBOutlet FUOpenGLView *displayGLView;

@property (weak, nonatomic) IBOutlet FUOpenGLView *landmarksGlView;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addObserver];
    
    self.photoBtn.delegate = self ;
    
    [[FUManager shareManager] setUpFaceunity];
    
    [self.mCamera startCapture];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[FUManager shareManager] destoryFaceunityItems];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
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

/**
 Faceunity道具美颜工具条
 初始化 FUAPIDemoBar，设置初始美颜参数
 
 @param demoBar FUAPIDemoBar不是我们的交付内容，它的作用仅局限于我们的Demo演示，客户可以选择使用，但我们不会提供与之相关的技术支持或定制需求开发
 */
- (void)setDemoBar:(FUAPIDemoBar *)demoBar
{
    _demoBar = demoBar;
    _demoBar.delegate = self;
    
    _demoBar.itemsDataSource =  [FUManager shareManager].itemsDataSource;
    _demoBar.filtersDataSource = [FUManager shareManager].filtersDataSource;
    
    _demoBar.selectedItem = [FUManager shareManager].selectedItem;      /**选中的道具名称*/
    _demoBar.selectedFilter = [FUManager shareManager].selectedFilter;  /**选中的滤镜名称*/
    _demoBar.beautyLevel = [FUManager shareManager].beautyLevel;        /**美白 (0~1)*/
    _demoBar.redLevel = [FUManager shareManager].redLevel;              /**红润 (0~1)*/
    _demoBar.selectedBlur = [FUManager shareManager].selectedBlur;      /**磨皮(0、1、2、3、4、5、6)*/
    _demoBar.faceShape = [FUManager shareManager].faceShape;            /**美型类型 (0、1、2、3) 默认：3，女神：0，网红：1，自然：2*/
    _demoBar.faceShapeLevel = [FUManager shareManager].faceShapeLevel;  /**美型等级 (0~1)*/
    _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel;  /**大眼 (0~1)*/
    _demoBar.thinningLevel = [FUManager shareManager].thinningLevel;    /**瘦脸 (0~1)*/

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
    [[FUManager shareManager] onCameraChange];
}

#pragma -FUAPIDemoBarDelegate
- (void)demoBarDidSelectedItem:(NSString *)item
{
    
    //加载道具
    [[FUManager shareManager] loadItem:item];
    
    _isAvatar = [item isEqualToString:@"lixiaolong"];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.landmarksGlView.hidden = !_isAvatar;
    });
}

/**设置美颜参数*/
- (void)demoBarBeautyParamChanged
{
    [self syncBeautyParams];
}

- (void)syncBeautyParams
{
    [FUManager shareManager].selectedFilter = _demoBar.selectedFilter;
    [FUManager shareManager].selectedBlur = _demoBar.selectedBlur;
    [FUManager shareManager].beautyLevel = _demoBar.beautyLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].faceShape = _demoBar.faceShape;
    [FUManager shareManager].faceShapeLevel = _demoBar.faceShapeLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
}

#pragma -FUCameraDelegate
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    /*--------------------------------------以下展示人脸特征点逻辑--------------------------------------*/
    /**如果当前的道具是avatar道具，先将原始图像拷贝出来一份，
     等处理完原始图像并将其显示在屏幕上后，我们再将图像拷贝回去，用于界面左上角的人脸特征点显示*/
    void *copyData = NULL;
    if (self.isAvatar)
    {
        copyData = [self getCopyDataFromPixelBuffer:pixelBuffer];
    }
    /*--------------------------------------以上展示人脸特征点逻辑--------------------------------------*/
    
    
    
    /*---------------------------------处理pixelBuffer，并显示在屏幕上---------------------------------*/
    /**处理pixelBuffer*/
    [[FUManager shareManager] processPixelBuffer:pixelBuffer];
    
    /**执行完上一步骤，即可将pixelBuffer绘制到屏幕上或推流到服务器进行直播*/
    [self.displayGLView displayPixelBuffer:pixelBuffer];
    /*---------------------------------处理pixelBuffer，并显示在屏幕上---------------------------------*/
    
    
    
    /*--------------------------------------以下展示人脸特征点逻辑--------------------------------------*/
    /**将图像拷贝回去，用于界面左上角的人脸特征点显示*/
    if (self.isAvatar && copyData)
    {
        [self copyDataBackToPixelBuffer:pixelBuffer copyData:copyData];
        [self displayLandmarksWithPixelBuffer:pixelBuffer];
    }
    free(copyData);
    /*--------------------------------------以上展示人脸特征点逻辑--------------------------------------*/
    
    
    /**判断是否检测到人脸*/
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackView.hidden = [[FUManager shareManager] isTracking];
    });
}

/**
 显示lanmarks预览
 */
- (void)displayLandmarksWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    float landmarks[150];
    
    [[FUManager shareManager] getLandmarks:landmarks];
    
    [self.landmarksGlView displayPixelBuffer:pixelBuffer withLandmarks:landmarks count:150];
}


/*--------------------------------------以下展示人脸特征点逻辑--------------------------------------*/
- (void *)getCopyDataFromPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    size_t size = CVPixelBufferGetDataSize(pixelBuffer);
    void *bytes = (void *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    void *copyData = malloc(size);
    
    memcpy(copyData, bytes, size);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return copyData;
}

- (void)copyDataBackToPixelBuffer:(CVPixelBufferRef)pixelBuffer copyData:(void *)copyData
{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    size_t size = CVPixelBufferGetDataSize(pixelBuffer);
    void *bytes = (void *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    memcpy(bytes, copyData, size);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}
/*--------------------------------------以上展示人脸特征点逻辑--------------------------------------*/

@end


