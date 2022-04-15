//
//  FURenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/12/7.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FURenderMediaViewController.h"

#import "FUVideoReader.h"

#import <SVProgressHUD.h>

#define kFUFinalPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"finalVideo.mp4"]

@interface FURenderMediaViewController ()<FUVideoReaderDelegate>

@property (nonatomic, strong) UIButton *playVideoButton;

@property (nonatomic, strong) UIButton *downloadButton;

@property (nonatomic, strong,) UILabel *trackTipLabel;
 
@property (nonatomic, strong) AVPlayer *audioReader;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) NSOperationQueue *renderOperationQueue;

@property (nonatomic, strong) FUGLDisplayView *displayView;

@property (nonatomic, strong) FUVideoReader *videoReader;

@property (nonatomic, assign) FURenderMediaType mediaType;

@property (nonatomic, strong) FUBaseViewControllerManager *baseManager;

@end

@implementation FURenderMediaViewController {
    FUImageBuffer currentImageBuffer;
    // 是否需要保存图片到相册
    BOOL needDownloadPicture;
}

@synthesize stopRendering, needTrack, trackType;

#pragma mark - Initializer

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        self.image = [UIImage imageWithData:imageData];
        self.mediaType = FURenderMediaTypeImage;
    }
    return self;
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [super init];
    if (self) {
        self.videoURL = videoURL;
        self.mediaType = FURenderMediaTypeVideo;
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseManager = [[FUBaseViewControllerManager alloc] init];
    [self.baseManager loadItem];
    [self.baseManager setFaceProcessorDetectMode:self.mediaType == FURenderMediaTypeImage ? FUFaceProcessorDetectModeImage : FUFaceProcessorDetectModeVideo];
    
    [self configureUI];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 最好判断Application状态
        [self start];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stop];
    
    [self.baseManager updateBeautyCache];
    [self.baseManager releaseItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    if (&currentImageBuffer) {
        [UIImage freeImageBuffer:&currentImageBuffer];
    }
}

#pragma mark - UI

- (void)configureUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.displayView];
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            if(iPhoneXStyle){
               make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50);
            }else{
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            }
        } else {
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.leading.equalTo(self.view.mas_leading).offset(10);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.downloadButton];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-69);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-69);
        }
        make.centerX.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(85, 85));
    }];
    
    self.downloadButton.hidden = self.mediaType == FURenderMediaTypeVideo;
    
    if (self.mediaType == FURenderMediaTypeVideo) {
        [self.view addSubview:self.playVideoButton];
        [self.playVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_offset(CGSizeMake(80, 80));
        }];
    }
    
    [self.view addSubview:self.trackTipLabel];
    [self.trackTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

#pragma mark - Override methods

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Instance methods

- (void)refreshDownloadButtonTransformWithHeight:(CGFloat)height show:(BOOL)shown {
    if (shown) {
        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, height * -0.8);
        CGAffineTransform photoTransform1 = CGAffineTransformMakeScale(0.9, 0.9);
        [UIView animateWithDuration:0.25 animations:^{
            self.downloadButton.transform = CGAffineTransformConcat(photoTransform0, photoTransform1) ;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.downloadButton.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)bringFunctionButtonToFront {
    [self.view bringSubviewToFront:self.downloadButton];
}

#pragma mark - Private methods

- (void)start {
    [self.baseManager setOnCameraChange];
    if (self.mediaType == FURenderMediaTypeImage) {
        if (!self.displayLink) {
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [self.displayLink setFrameInterval:10];
        }
        self.displayLink.paused = NO;
    } else {
        [self playVideoAction:self.playVideoButton];
    }
}

- (void)stop {
    if (self.mediaType == FURenderMediaTypeImage) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
        // 取消所有任务
        [self.renderOperationQueue cancelAllOperations];
    } else {
        [self.videoReader stopReading];
        [self.videoReader destory];
        self.videoReader = nil;
        [self.audioReader pause];
        self.audioReader = nil;
    }
}

- (void)startVideoReader {
    if (self.videoReader) {
        [self.videoReader setVideoURL:self.videoURL];
    }else {
        self.videoReader = [[FUVideoReader alloc] initWithVideoURL:self.videoURL];
        self.videoReader.delegate = self;
    }
    
    [self.videoReader startReadWithDestinationPath:kFUFinalPath];
    self.displayView.origintation = (int)self.videoReader.videoOrientation;
    
    self.audioReader = [AVPlayer playerWithURL:self.videoURL];
    self.audioReader.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [self.audioReader play];
}

/// 处理人脸/人体检测结果
- (void)resolveTrackResult {
    if (!self.isNeedTrack) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.trackTipLabel.hidden = YES;
        }];
    } else {
        if (self.trackType == FUTrackTypeFace) {
            if ([self.baseManager faceTrace]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.trackTipLabel.hidden = YES;
                }];
            } else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.trackTipLabel.text = FUNSLocalizedString(@"未识别到人脸", nil);
                    self.trackTipLabel.hidden = NO;
                }];
            }
        } else {
            if ([self.baseManager bodyTrace]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.trackTipLabel.hidden = YES;
                }];
            } else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.trackTipLabel.text = FUNSLocalizedString(@"未识别到人体", nil);
                    self.trackTipLabel.hidden = NO;
                }];
            }
        }
    }
}

#pragma mark - Event response

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playVideoAction:(UIButton *)sender {
    sender.selected = YES;
    sender.hidden = YES;
    self.downloadButton.hidden = YES;
    
    [self startVideoReader];
}

- (void)downloadAction:(UIButton *)sender {
    if (self.mediaType == FURenderMediaTypeImage) {
        // 需要保存图片到相册
        needDownloadPicture = YES;
    } else {
        // 保存视频到相册
        UISaveVideoAtPathToSavedPhotosAlbum(kFUFinalPath, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadButton.hidden = YES ;
        });
    }
}

- (void)displayLinkAction {
    [self.renderOperationQueue addOperationWithBlock:^{
        [self.baseManager updateBeautyBlurEffect];
        @autoreleasepool {//防止大图片，内存峰值过高
            currentImageBuffer = [self.image getImageBuffer];
            if (!self.stopRendering) {
                FURenderInput *input = [[FURenderInput alloc] init];
                input.renderConfig.imageOrientation = FUImageOrientationUP;
                switch (_image.imageOrientation) {
                    case UIImageOrientationUp:
                        input.renderConfig.imageOrientation = FUImageOrientationUP;
                        break;
                    case UIImageOrientationLeft:
                        input.renderConfig.imageOrientation = FUImageOrientationRight;
                        break;
                    case UIImageOrientationDown:
                        input.renderConfig.imageOrientation = FUImageOrientationDown;
                        break;
                    case UIImageOrientationRight:
                        input.renderConfig.imageOrientation = FUImageOrientationLeft;
                        break;
                    default:
                        input.renderConfig.imageOrientation = FUImageOrientationUP;
                        break;
                }
                input.imageBuffer = currentImageBuffer;
                FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
                currentImageBuffer = output.imageBuffer;
            }
            if (needDownloadPicture) {
                // 保存图片到相册
                UIImage *saveImage = [UIImage imageWithRGBAImageBuffer:&currentImageBuffer autoFreeBuffer:NO];
                needDownloadPicture = NO;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
            [self.displayView displayImageData:currentImageBuffer.buffer0 withSize:currentImageBuffer.size];
            if ([self conformsToProtocol:@protocol(FURenderMediaProtocol)] && [self respondsToSelector:@selector(renderMediaDidOutputImage:)]) {
                [self renderMediaDidOutputImage:[UIImage imageWithRGBAImageBuffer:&currentImageBuffer autoFreeBuffer:NO]];
            }
            [UIImage freeImageBuffer:&currentImageBuffer];
        }
        
        [self resolveTrackResult];
    }];
}

- (void)applicationWillResignActive {
    [self stop];
}

- (void)applicationDidBecomeActive {
    [self start];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:FUNSLocalizedString(@"保存图片失败", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"图片已保存到相册", nil)];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:FUNSLocalizedString(@"保存视频失败", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"视频已保存到相册", nil)];
    }
}

#pragma mark - FURenderMediaProtocol

- (BOOL)isNeedTrack {
    return NO;
}

#pragma mark - FUVideoReaderDelegate

- (CVPixelBufferRef)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer {
    if (!self.stopRendering) {
        FURenderInput *input = [[FURenderInput alloc] init];
        input.pixelBuffer = pixelBuffer;
        input.renderConfig.imageOrientation = 0;
        switch (self.videoReader.videoOrientation) {
            case FUVideoReaderOrientationPortrait:
                input.renderConfig.imageOrientation = FUImageOrientationUP;
                break;
            case FUVideoReaderOrientationLandscapeRight:
                input.renderConfig.imageOrientation = FUImageOrientationLeft;
                break;
            case FUVideoReaderOrientationUpsideDown:
                input.renderConfig.imageOrientation = FUImageOrientationDown;
                break;
            case FUVideoReaderOrientationLandscapeLeft:
                input.renderConfig.imageOrientation = FUImageOrientationRight;
                break;
            default:
                input.renderConfig.imageOrientation = FUImageOrientationUP;
                break;
        }
        FURenderOutput *output =  [[FURenderKit shareRenderKit] renderWithInput:input];
        pixelBuffer = output.pixelBuffer;
    }
    [self.displayView displayPixelBuffer:pixelBuffer];
    if ([self conformsToProtocol:@protocol(FURenderMediaProtocol)] && [self respondsToSelector:@selector(renderMediaDidOutputPixelBuffer:)]) {
        [self renderMediaDidOutputPixelBuffer:pixelBuffer];
    }
    [self resolveTrackResult];
    return pixelBuffer;
}

- (void)videoReaderDidFinishReadSuccess:(BOOL)success {
    [self.videoReader startReadForLastFrame];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadButton.hidden = NO;
        self.playVideoButton.hidden = NO;
    });
}

#pragma mark - Getters

- (UIButton *)playVideoButton {
    if (!_playVideoButton) {
        _playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playVideoButton setBackgroundImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
        [_playVideoButton setBackgroundImage:[UIImage imageNamed:@"Replay_icon"] forState:UIControlStateSelected];
        _playVideoButton.hidden = YES;
        [_playVideoButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playVideoButton;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.backgroundColor = [UIColor whiteColor];
        _downloadButton.layer.cornerRadius = 42.5;
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"demo_icon_save1"] forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

- (UILabel *)trackTipLabel {
    if (!_trackTipLabel) {
        _trackTipLabel = [[UILabel alloc] init];
        _trackTipLabel.textColor = [UIColor whiteColor];
        _trackTipLabel.font = [UIFont systemFontOfSize:17];
        _trackTipLabel.text = FUNSLocalizedString(@"No_Face_Tracking", @"未检测到人脸");
        _trackTipLabel.hidden = YES;
    }
    return _trackTipLabel;
}

- (FUGLDisplayView *)displayView {
    if (!_displayView) {
        _displayView = [[FUGLDisplayView alloc] initWithFrame:self.view.bounds];
        _displayView.contentMode = FUGLDisplayViewContentModeScaleAspectFit;
    }
    return _displayView;
}

- (NSOperationQueue *)renderOperationQueue {
    if (!_renderOperationQueue) {
        _renderOperationQueue = [[NSOperationQueue alloc] init];
        _renderOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _renderOperationQueue;
}

@end
