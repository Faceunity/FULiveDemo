//
//  FUCamera.h
//  FUAPIDemo
//
//  Created by liuyang on 2016/12/26.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol FUCameraDelegate <NSObject>

- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

@interface FUCamera : NSObject
@property (nonatomic, weak) id<FUCameraDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isFrontCamera;
@property (assign, nonatomic) int captureFormat; //采集格式
@property (copy  , nonatomic) dispatch_queue_t  videoCaptureQueue;//视频采集的队列
@property (copy  , nonatomic) dispatch_queue_t  audioCaptureQueue;//音频采集队列
@property (copy  , nonatomic) dispatch_queue_t  tmpCaptureQueue;//视频采集的队列

/**
 锁定焦距
 */
@property (assign, nonatomic) CGPoint focusPoint;

/**
 锁定曝光
 */
@property (assign, nonatomic) CGPoint exposurePoint;

/**
 * White balance mode. Default is: AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance
 */
@property (nonatomic) AVCaptureWhiteBalanceMode whiteBalanceMode;


- (instancetype)initWithCameraPosition:(AVCaptureDevicePosition)cameraPosition captureFormat:(int)captureFormat;

- (void)startCapture;

- (void)stopCapture;

- (void)changeCameraInputDeviceisFront:(BOOL)isFront;

- (void)takePhotoAndSave;

- (void)startRecord;

- (void)stopRecordWithCompletionHandler:(void (^)(NSString *videoPath))handler;

- (void)addAudio;

- (void)removeAudio;

/* 当前分辨率是否支持前后置 */
-(BOOL)supportsAVCaptureSessionPreset:(BOOL)isFront;

/**
 设置采集方向

 @param orientation 方向
 */
- (void)setCaptureVideoOrientation:(AVCaptureVideoOrientation)orientation;


/**
 设置曝光补偿

 @param value 一般 -8 ~ 8
 */
- (void)setExposureValue:(float)value ;

/**
 查询当前相机最大曝光补偿信息

 @param current 当前
 @param max 最大
 @param min 最小
 */
- (void)getCurrentExposureValue:(float *)current max:(float *)max min:(float *)min;

/**
 恢复以屏幕中心自动连续对焦和曝光
 */
- (void)resetFocusAndExposureModes;

/**
 修改采集分辨率

 @param sessionPreset string constants
 */
-(BOOL)changeSessionPreset:(AVCaptureSessionPreset)sessionPreset;


/**
 修改采集视频镜像关系

 @param videoMirrored  videoMirrore
 */
-(void)changeVideoMirrored:(BOOL)videoMirrored;

/**
 修改帧率
 
 在iOS上，使用AvCaptureDevice的setActiveFormat:和AvCaptureSession的setSessionPreset:是互斥的。
 如果 frameRate <= 30 setActiveFormat 则该设备所连接的会话将其预设更改为avCaptureSessionPresetinputPriority
 */
-(void)changeVideoFrameRate:(int)frameRate;


/**
 修改HDR

 @param videoHDREnabled 默认开启
 */
-(void)cameraVideoHDREnabled:(BOOL)videoHDREnabled;

/**
 ISO 设置

 @param value  0.0 - 1.0 光感度  46 -736
 */
-(void)cameraChangeISO:(CGFloat)value;



@end
