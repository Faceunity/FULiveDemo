//
//  FUCamera.m
//  FULiveDemo
//
//  Created by liuyang on 2016/12/26.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "FUCamera.h"
#import <UIKit/UIKit.h>
#import "FURecordEncoder.h"
#import "WCLRecordEncoder.h"
#import <SVProgressHUD/SVProgressHUD.h>

typedef enum : NSUInteger {
    CommonMode,
    PhotoTakeMode,
    VideoRecordMode,
    VideoRecordEndMode,
} RunMode;


@interface FUCamera()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    RunMode runMode;
    
    BOOL hasStarted;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput       *backCameraInput;//后置摄像头输入
@property (strong, nonatomic) AVCaptureDeviceInput       *frontCameraInput;//前置摄像头输入
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureDevice *camera;

@property (assign, nonatomic) AVCaptureDevicePosition cameraPosition;

//@property (strong, nonatomic) FUrecordEncoder          *recordEncoder;//录制编码
@property (strong, nonatomic) WCLRecordEncoder          *recordEncoder2;//录制编码


@property (nonatomic, strong) AVCaptureDeviceInput      *audioMicInput;//麦克风输入
@property (nonatomic, strong) AVCaptureAudioDataOutput  *audioOutput;//音频输出

@end

@implementation FUCamera

- (instancetype)initWithCameraPosition:(AVCaptureDevicePosition)cameraPosition captureFormat:(int)captureFormat
{
    if (self = [super init]) {
        self.cameraPosition = cameraPosition;
        self.captureFormat = captureFormat;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.cameraPosition = AVCaptureDevicePositionFront;
        self.captureFormat = kCVPixelFormatType_32BGRA;
    }
    return self;
}

- (void)startCapture{
    
    if (![self.captureSession isRunning] && !hasStarted) {
        hasStarted = YES;
        [self.captureSession startRunning];
        self.exposurePoint = CGPointMake(0.49, 0.5);
        self.focusPoint = CGPointMake(0.49, 0.5);
    }
}

- (void)stopCapture{
    hasStarted = NO;
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

- (void)addAudio    {
    if ([_captureSession canAddOutput:self.audioOutput]) {
        [_captureSession addOutput:self.audioOutput];
    }
}

- (void)removeAudio {
    [_captureSession removeOutput:self.audioOutput];
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
        
        AVCaptureDeviceInput *deviceInput = self.isFrontCamera ? self.frontCameraInput:self.backCameraInput;
        
        if ([_captureSession canAddInput: deviceInput]) {
            [_captureSession addInput: deviceInput];
        }
        
        if ([_captureSession canAddOutput:self.videoOutput]) {
            [_captureSession addOutput:self.videoOutput];
        }
        
        if ([_captureSession canAddInput:self.audioMicInput]) {
            [_captureSession addInput:self.audioMicInput];
        }
        
        [self addAudio];
        
        [self.videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        if (self.videoConnection.supportsVideoMirroring && self.isFrontCamera) {
            self.videoConnection.videoMirrored = YES;
        }
        
        [_captureSession beginConfiguration]; // the session to which the receiver's AVCaptureDeviceInput is added.
        if ( [deviceInput.device lockForConfiguration:NULL] ) {
            [deviceInput.device setActiveVideoMinFrameDuration:CMTimeMake(1, 30)];
            [deviceInput.device unlockForConfiguration];
        }
        [_captureSession commitConfiguration]; //
    }
    return _captureSession;
}

//后置摄像头输入
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        if (error) {
            NSLog(@"获取后置摄像头失败~");
        }
    }
    self.camera = _backCameraInput.device;
    return _backCameraInput;
}

//前置摄像头输入
- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        if (error) {
            NSLog(@"获取前置摄像头失败~");
        }
    }
    self.camera = _frontCameraInput.device;
    return _frontCameraInput;
}

- (AVCaptureDeviceInput *)audioMicInput
{
    if (!_audioMicInput) {
        //添加后置麦克风的输出
        
        AVCaptureDevice *mic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioMicInput = [AVCaptureDeviceInput deviceInputWithDevice:mic error:&error];
        if (error) {
            NSLog(@"获取麦克风失败~");
        }
    }
    return _audioMicInput;
}

- (AVCaptureAudioDataOutput *)audioOutput
{
    if (!_audioOutput) {
        //添加音频输出
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:self.audioCaptureQueue];
    }
    
    return _audioOutput;
}


//返回前置摄像头
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

//返回后置摄像头
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

//切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront {
    
    [self.captureSession stopRunning];
    if (isFront) {
        [self.captureSession removeInput:self.backCameraInput];
        if ([self.captureSession canAddInput:self.frontCameraInput]) {
            [self.captureSession addInput:self.frontCameraInput];
        }
        self.cameraPosition = AVCaptureDevicePositionFront;
    }else {
        [self.captureSession removeInput:self.frontCameraInput];
        if ([self.captureSession canAddInput:self.backCameraInput]) {
            [self.captureSession addInput:self.backCameraInput];
        }
        self.cameraPosition = AVCaptureDevicePositionBack;
    }
    
    AVCaptureDeviceInput *deviceInput = isFront ? self.frontCameraInput:self.backCameraInput;
    
    [self.captureSession beginConfiguration]; // the session to which the receiver's AVCaptureDeviceInput is added.
    if ( [deviceInput.device lockForConfiguration:NULL] ) {
        [deviceInput.device setActiveVideoMinFrameDuration:CMTimeMake(1, 30)];
        [deviceInput.device unlockForConfiguration];
    }
    [self.captureSession commitConfiguration];
    
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    if (self.videoConnection.supportsVideoMirroring) {
        self.videoConnection.videoMirrored = isFront;
    }
    [self.captureSession startRunning];
}

//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)camera
{
    if (!_camera) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == self.cameraPosition)
            {
                _camera = device;
            }
        }
    }
    return _camera;
}

- (AVCaptureVideoDataOutput *)videoOutput
{
    if (!_videoOutput) {
        //输出
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
        [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_captureFormat] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        [_videoOutput setSampleBufferDelegate:self queue:self.videoCaptureQueue];
    }
    return _videoOutput;
}

//视频采集队列
- (dispatch_queue_t)videoCaptureQueue {
    if (_videoCaptureQueue == nil) {
        _videoCaptureQueue = dispatch_queue_create("com.faceunity.videoCaptureQueue", NULL);
    }
    return _videoCaptureQueue;
}

//音频采集队列
- (dispatch_queue_t)audioCaptureQueue {
    if (_audioCaptureQueue == nil) {
        _audioCaptureQueue = dispatch_queue_create("com.faceunity.audioCaptureQueue", NULL);
    }
    return _audioCaptureQueue;
}

//视频连接
- (AVCaptureConnection *)videoConnection {
    _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    _videoConnection.automaticallyAdjustsVideoMirroring =  NO;
    
    return _videoConnection;
}

//设置采集格式
- (void)setCaptureFormat:(int)captureFormat
{
    if (_captureFormat == captureFormat) {
        return;
    }
    
    _captureFormat = captureFormat;
    
    if (((NSNumber *)[[_videoOutput videoSettings] objectForKey:(id)kCVPixelBufferPixelFormatTypeKey]).intValue != captureFormat) {
        
        [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_captureFormat] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    }
}


- (void)setFocusPoint:(CGPoint)focusPoint
{
    if (!self.focusPointSupported) {
        return;
    }
    
    NSError *error = nil;
    if (![self.camera lockForConfiguration:&error]) {
        NSLog(@"XBFilteredCameraView: Failed to set focus point: %@", [error localizedDescription]);
        return;
    }
    
    self.camera.focusPointOfInterest = focusPoint;
    self.camera.focusMode = AVCaptureFocusModeAutoFocus;
    [self.camera unlockForConfiguration];
}

- (BOOL)focusPointSupported
{
    return self.camera.focusPointOfInterestSupported;
}

- (void)setExposurePoint:(CGPoint)exposurePoint
{
    if (!self.exposurePointSupported) {
        return;
    }
    
    NSError *error = nil;
    if (![self.camera lockForConfiguration:&error]) {
        NSLog(@"XBFilteredCameraView: Failed to set exposure point: %@", [error localizedDescription]);
        return;
    }
    self.camera.exposureMode = AVCaptureExposureModeLocked;
    self.camera.exposurePointOfInterest = exposurePoint;
    self.camera.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    
    [self.camera unlockForConfiguration];
}

- (BOOL)exposurePointSupported
{
    return self.camera.exposurePointOfInterestSupported;
}


- (BOOL)isFrontCamera
{
    return self.cameraPosition == AVCaptureDevicePositionFront;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (captureOutput == self.audioOutput) {
        
        if (runMode == VideoRecordMode) {
            
            if (self.recordEncoder2 == nil) {
                return ;
            }
            CFRetain(sampleBuffer);
            // 进行数据编码
            [self.recordEncoder2 encodeFrame:sampleBuffer pixelBuffer:nil isVideo:NO];

            CFRelease(sampleBuffer);
        }
        return ;
    }
    
    if([self.delegate respondsToSelector:@selector(didOutputVideoSampleBuffer:)])
    {
        [self.delegate didOutputVideoSampleBuffer:sampleBuffer];
    }
    
    switch (runMode) {
        case CommonMode:
            
            break;
            
        case PhotoTakeMode:
        {
            runMode = CommonMode;
            CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            UIImage *image = [self imageFromPixelBuffer:buffer];
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
        }
            break;
            
        case VideoRecordMode:

            if (self.recordEncoder2 == nil) {

                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
                NSString *dateString = [dateFormatter stringFromDate:currentDate];
                NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateString]];

                CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                float frameWidth = CVPixelBufferGetWidth(buffer);
                float frameHeight = CVPixelBufferGetHeight(buffer);

                if (frameWidth != 0 && frameHeight != 0) {

//                    self.recordEncoder2 = [FUrecordEncoder2 encoderForPath:videoPath Height:frameHeight width:frameWidth];
                    self.recordEncoder2 = [WCLRecordEncoder encoderForPath:videoPath Height:frameHeight width:frameWidth channels:1 samples:44100];
                    return ;
                }
            }
            CFRetain(sampleBuffer);
            // 进行数据编码
            [self.recordEncoder2 encodeFrame:sampleBuffer pixelBuffer:CMSampleBufferGetImageBuffer(sampleBuffer) isVideo:YES];
            CFRelease(sampleBuffer);
            break;
        case VideoRecordEndMode:
        {
            runMode = CommonMode;
            
            if (self.recordEncoder2.writer.status == AVAssetWriterStatusUnknown) {
                self.recordEncoder2 = nil;
            }else{
                
                [self.recordEncoder2 finishWithCompletionHandler:^{
                    
                    NSString *path = self.recordEncoder2.path;
                    self.recordEncoder2 = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
                    });
                    
                }];
            }
        }
        break;
        default:
            break;
    }
}

- (void)takePhotoAndSave
{
    runMode = PhotoTakeMode;
}

//开始录像
- (void)startRecord
{
    runMode = VideoRecordMode;
}

//停止录像
- (void)stopRecord
{
    runMode = VideoRecordEndMode;
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

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
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

- (void)setCaptureVideoOrientation:(AVCaptureVideoOrientation) orientation {
    
    [self.videoConnection setVideoOrientation:orientation];
}

@end
