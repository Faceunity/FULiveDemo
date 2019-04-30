//
//  FUCamera.m
//  FULiveDemo
//
//  Created by liuyang on 2016/12/26.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "FUCamera.h"
#import <UIKit/UIKit.h>
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
    BOOL photoMirr ;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput       *backCameraInput;//后置摄像头输入
@property (strong, nonatomic) AVCaptureDeviceInput       *frontCameraInput;//前置摄像头输入
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureDevice *camera;

@property (assign, nonatomic) AVCaptureDevicePosition cameraPosition;

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
        runMode = CommonMode ;
        photoMirr = NO ;
    }
    return self;
}

- (void)startCapture{
    
    if (![self.captureSession isRunning] && !hasStarted) {
        hasStarted = YES;
        [self.captureSession startRunning];
        self.exposurePoint = CGPointMake(0.5, 0.5);
        self.focusPoint = CGPointMake(0.49, 0.5);
    }
}

- (void)stopCapture{
    hasStarted = NO;
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
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
        
        [self.videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        if (self.videoConnection.supportsVideoMirroring) {
            self.videoConnection.videoMirrored = NO;
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
//        self.videoConnection.videoMirrored = isFront && self.shouldMirror;
        self.videoConnection.videoMirrored = self.shouldMirror;
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
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
    }
    return _videoOutput;
}

//录制的队列
- (dispatch_queue_t)captureQueue {
    if (_captureQueue == nil) {
//        _captureQueue = dispatch_queue_create("com.faceunity.captureQueue", DISPATCH_QUEUE_SERIAL);
        _captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    }
    return _captureQueue;
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
    if([self.delegate respondsToSelector:@selector(didOutputVideoSampleBuffer:)])
    {
        [self.delegate didOutputVideoSampleBuffer:sampleBuffer];
    }
    
    switch (runMode) {
        case CommonMode:
            break;
        case PhotoTakeMode:{
            runMode = CommonMode;
            CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            UIImage *image = [self imageFromPixelBuffer:buffer mirr:photoMirr];
            photoMirr = NO ;
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
        }
            break ;
        case VideoRecordMode:{
        }
            break ;
        case VideoRecordEndMode:{
        }
            break ;
    }
}

- (void)takePhoto:(BOOL)mirr;
{
    photoMirr = mirr ;
    runMode = PhotoTakeMode;
}

- (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef mirr:(BOOL)mirr{
    
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
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(cropX, cropY, cropW, cropH)];
    
    UIImage *image ;
    if (mirr) {
        image = [UIImage imageWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationUpMirrored];
    }else {
        image = [UIImage imageWithCGImage:videoImage];
    }
    
    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    return image;
}

- (UIImage *)getSquareImageFromBuffer:(CVPixelBufferRef)pixelBufferRef {
    
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
    float width = CVPixelBufferGetWidth(pixelBufferRef);
    float height = CVPixelBufferGetHeight(pixelBufferRef);
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, width, height)];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    
    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    return image;
}



- (void)setCaptureVideoOrientation:(AVCaptureVideoOrientation) orientation {
    
    [self.videoConnection setVideoOrientation:orientation];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"图片已保存到相册"];
    }
}
@end
