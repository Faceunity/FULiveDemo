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
@property (nonatomic, assign) id<FUCameraDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isFrontCamera;
@property (assign, nonatomic) CGPoint focusPoint;
@property (assign, nonatomic) CGPoint exposurePoint;
@property (assign, nonatomic) int captureFormat; //采集格式
@property (copy  , nonatomic) dispatch_queue_t  videoCaptureQueue;//视频采集的队列
@property (copy  , nonatomic) dispatch_queue_t  audioCaptureQueue;//音频采集队列

- (instancetype)initWithCameraPosition:(AVCaptureDevicePosition)cameraPosition captureFormat:(int)captureFormat;

- (void)startCapture;

- (void)stopCapture;

- (void)changeCameraInputDeviceisFront:(BOOL)isFront;

- (void)takePhotoAndSave;

- (void)startRecord;

- (void)stopRecord;

- (void)addAudio;

- (void)removeAudio;

// 设置采集方向
- (void)setCaptureVideoOrientation:(AVCaptureVideoOrientation)orientation;
@end
