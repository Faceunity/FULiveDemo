//
//  FUVideoReader.m
//  AVAssetReader2
//
//  Created by L on 2018/6/13.
//  Copyright © 2018年 千山暮雪. All rights reserved.
//

#import "FUVideoReader.h"
#import <UIKit/UIKit.h>

@interface FUVideoReader ()
{
    BOOL isReadFirstFrame ;
    BOOL isReadLastFrame ;
    
    CMSampleBufferRef firstFrame ;
    
    CVPixelBufferRef renderTarget ;
}

@property (nonatomic, copy) NSString *destinationPath ;

// 读
@property (nonatomic, strong) AVAssetReader *assetReader ;
// 写
@property (nonatomic, strong) AVAssetWriter *assetWriter ;

// 音频输入
@property (nonatomic, strong) AVAssetWriterInput *audioInput;
// 音频输出
@property (nonatomic, strong) AVAssetReaderTrackOutput *audioOutput;
// 视频输入
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
// 视频输出
@property (nonatomic, strong) AVAssetReaderTrackOutput *videoOutput;
// 视频通道
@property (nonatomic, strong) AVAssetTrack *videoTrack ;
// 视频朝向
@property (nonatomic, assign, readwrite) FUVideoReaderOrientation videoOrientation ;

// 定时器
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) dispatch_semaphore_t finishSemaphore ;
@end

@implementation FUVideoReader

-(instancetype)initWithVideoURL:(NSURL *)videoRUL {
    self = [super init];
    if (self) {
        
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        if (@available(iOS 10.0, *)) {
            [_displayLink setPreferredFramesPerSecond:30];
        } else {
            [_displayLink setFrameInterval:2];
        }
        _displayLink.paused = YES;
        
        _videoURL = videoRUL ;
        
        isReadFirstFrame = NO ;
        isReadLastFrame = NO ;
    }
    return self ;
}

-(void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL ;
}

-(void)configAssetReader {
    AVAsset *asset = [AVAsset assetWithURL:_videoURL];
    self.assetReader = [[AVAssetReader alloc] initWithAsset:asset error:nil];
    
    // 视频通道
    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
    
    _videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    self.videoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:_videoTrack outputSettings:outputSettings];
    self.videoOutput.alwaysCopiesSampleData = NO;
    
    
    CGAffineTransform transform = self.videoTrack.preferredTransform ;
    
    if(transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0){
        
        self.videoOrientation = FUVideoReaderOrientationLandscapeRight ;
    }else if(transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0){
        
        self.videoOrientation = FUVideoReaderOrientationLandscapeLeft ;
    }else if(transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0){
        
        self.videoOrientation = FUVideoReaderOrientationPortrait ;
    }else if(transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0){
        
        self.videoOrientation = FUVideoReaderOrientationUpsideDown ;
    }
    
    if ([self.assetReader canAddOutput:self.videoOutput]) {
        [self.assetReader addOutput:self.videoOutput];
    }else{
        NSLog(@"配置视频输出失败 ~") ;
    }
    
    // 音频通道
    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    
    if (audioTracks.count > 0)  {
        
        AVAssetTrack *audioTrack = [audioTracks objectAtIndex:0];
        NSMutableDictionary *audioSettings = [NSMutableDictionary dictionary];
        [audioSettings setObject: [NSNumber numberWithInt:kAudioFormatLinearPCM]  forKey: (NSString*)AVFormatIDKey];
        
        self.audioOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:audioSettings];
        self.audioOutput.alwaysCopiesSampleData = NO;
        if ([self.assetReader canAddOutput:self.audioOutput]) {
            [self.assetReader addOutput:self.audioOutput];
        }else {
            NSLog(@"配置音频输出失败 ~");
        }
    }
}


-(void)configAssetWriterWithPath:(NSString *)destinationPath {
    _destinationPath = destinationPath ;
    
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath: destinationPath] fileType:AVFileTypeQuickTimeMovie error:nil];
    //音频编码
    NSDictionary *audioInputSetting = [self configAudioInput];
    self.audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioInputSetting];
    if ([self.assetWriter canAddInput:self.audioInput]) {
        [self.assetWriter addInput:self.audioInput];
    } else {
        NSLog(@"配置音频输入失败 ~") ;
    }
    
    //视频编码
    NSDictionary *videoInputSetting = [self configVideoInput];
    self.videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoInputSetting];
    self.videoInput.expectsMediaDataInRealTime = YES;
    
    CGAffineTransform transform ;
    switch (self.videoOrientation) {
        case FUVideoReaderOrientationPortrait:
            transform = CGAffineTransformIdentity ;
            break;
        case FUVideoReaderOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI_2) ;
            break;
        case FUVideoReaderOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-M_PI_2) ;
            break ;
        case FUVideoReaderOrientationUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI) ;
            break ;
    }
    self.videoInput.transform = transform ;
    
    if ([self.assetWriter canAddInput:self.videoInput]) {
        [self.assetWriter addInput:self.videoInput];
    } else {
        NSLog(@"配置视频输入失败 ~") ;
    }
}

// 开始读
- (void)startReadWithDestinationPath:(NSString *)destinationPath {
    
    if (self.finishSemaphore == nil) {
        self.finishSemaphore = dispatch_semaphore_create(1) ;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil] ;
    }
    
    [self configAssetReader];
    [self configAssetWriterWithPath:destinationPath];
    
    if (self.assetReader.status != AVAssetReaderStatusReading) {
        [self.assetReader startReading];
    }
    if (self.assetWriter.status != AVAssetWriterStatusWriting) {
        [self.assetWriter startWriting];
    }
    
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    isReadFirstFrame = NO ;
    isReadLastFrame = NO ;
    _displayLink.paused = NO ;
    
}

- (void)displayLinkCallback:(CADisplayLink *)displatLink {
    
    if (isReadFirstFrame) {
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(firstFrame) ;
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0) ;
        
        int w0 = (int)CVPixelBufferGetWidth(pixelBuffer) ;
        int h0 = (int)CVPixelBufferGetHeight(pixelBuffer) ;
        void *byte0 = CVPixelBufferGetBaseAddress(pixelBuffer) ;
        
        if (!renderTarget) {
            [self createPixelBufferWithSize:CGSizeMake(w0, h0)];
        }
        
        CVPixelBufferLockBaseAddress(renderTarget, 0) ;
        
        int w1 = (int)CVPixelBufferGetWidth(renderTarget) ;
        int h1 = (int)CVPixelBufferGetHeight(renderTarget) ;
        
        if (w0 != w1 || h0 != h1) {
            [self createPixelBufferWithSize:CGSizeMake(w0, h0)];
        }
        
        void *byte1 = CVPixelBufferGetBaseAddress(renderTarget) ;
        
        memcpy(byte1, byte0, w0 * h0 * 4) ;
        
        CVPixelBufferUnlockBaseAddress(renderTarget, 0);
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0) ;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidReadVideoBuffer:)] && !self.displayLink.paused) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.delegate videoReaderDidReadVideoBuffer:renderTarget];
            });
        }
        [self.assetReader cancelReading];
        self.assetReader = nil;
        return ;
    }
    
    
    if (isReadLastFrame) {
        void *bytes = [self getCopyDataFromPixelBuffer:renderTarget];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidReadVideoBuffer:)] && !_displayLink.isPaused) {
            [self.delegate videoReaderDidReadVideoBuffer:renderTarget];
        }
        
        [self copyDataBackToPixelBuffer:renderTarget copyData:bytes];
        
        free(bytes) ;
        
        return ;
    }
    
    [self readAudioBuffer];
    
    [self readVideoBuffer];
}

static BOOL isAudioFirst = YES ;
- (void)readAudioBuffer {
    
    if ([self.audioInput isReadyForMoreMediaData] && self.assetReader.status == AVAssetReaderStatusReading) {
        
        if (isAudioFirst) {
            isAudioFirst = NO;
            return ;
        }
        
        CMSampleBufferRef nextSampleBuffer = [self.audioOutput copyNextSampleBuffer];
        
        if (nextSampleBuffer) {
            [self.audioInput appendSampleBuffer:nextSampleBuffer];
            
            CMSampleBufferInvalidate(nextSampleBuffer);
            CFRelease(nextSampleBuffer);
        } else {
            [self.audioInput markAsFinished];
            
            if (dispatch_semaphore_wait(self.finishSemaphore, DISPATCH_TIME_NOW) != 0) {
                [self readVideoFinished];
            }
        }
    }
}

static BOOL isVideoFirst = YES ;
- (void)readVideoBuffer {
    
    if ([self.videoInput isReadyForMoreMediaData] && self.assetReader.status == AVAssetReaderStatusReading) {
        
        if (isVideoFirst) {
            isVideoFirst = NO;
            return ;
        }
        
        CMSampleBufferRef nextSampleBuffer = [self.videoOutput copyNextSampleBuffer];
        
        if (nextSampleBuffer) {
            
            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(nextSampleBuffer) ;
            
            // 数据保存到 renderTarget
            CVPixelBufferLockBaseAddress(pixelBuffer, 0) ;
            
            int w0 = (int)CVPixelBufferGetWidth(pixelBuffer) ;
            int h0 = (int)CVPixelBufferGetHeight(pixelBuffer) ;
            void *byte0 = CVPixelBufferGetBaseAddress(pixelBuffer) ;
            
            if (!renderTarget) {
                [self createPixelBufferWithSize:CGSizeMake(w0, h0)];
            }
            
            CVPixelBufferLockBaseAddress(renderTarget, 0) ;
            
            int w1 = (int)CVPixelBufferGetWidth(renderTarget) ;
            int h1 = (int)CVPixelBufferGetHeight(renderTarget) ;
            
            if (w0 != w1 || h0 != h1) {
                [self createPixelBufferWithSize:CGSizeMake(w0, h0)];
            }
            
            void *byte1 = CVPixelBufferGetBaseAddress(renderTarget) ;
            
            memcpy(byte1, byte0, w0 * h0 * 4) ;
            
            CVPixelBufferUnlockBaseAddress(renderTarget, 0);
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0) ;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidReadVideoBuffer:)] && !self.displayLink.paused) {
                CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(nextSampleBuffer) ;
                [self.delegate videoReaderDidReadVideoBuffer:pixelBuffer];
            }
            
            [self.videoInput appendSampleBuffer:nextSampleBuffer];
            
            CMSampleBufferInvalidate(nextSampleBuffer);
            CFRelease(nextSampleBuffer);
        }else {
            [self.videoInput markAsFinished];
            
            if (dispatch_semaphore_wait(self.finishSemaphore, DISPATCH_TIME_NOW) != 0) {
                [self readVideoFinished];
            }
        }
    }
}

- (void)readVideoFinished {
    
    dispatch_semaphore_signal(self.finishSemaphore) ;
    [self stopReading];
    self.finishSemaphore = nil ;
    
    if (self.assetWriter.status == AVAssetWriterStatusWriting) {
        
        [self.assetWriter finishWritingWithCompletionHandler:^{
            
            AVAssetWriterStatus status = self.assetWriter.status;
            BOOL success ;
            if (status == AVAssetWriterStatusCompleted) {
                success = YES ;
                NSLog(@"finsished");
            } else {
                success = NO ;
                NSLog(@"failure %ld",(long)status);
            }
            self.displayLink.paused = YES ;
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidFinishReadSuccess:)]) {
                [self.delegate videoReaderDidFinishReadSuccess:success];
            }
        }];
    }
}

// 只读 第一帧
- (void)startReadForFirstFrame {
    
    self.assetReader = nil ;
    
    [self configAssetReader];
    
    [self.assetReader startReading];
    
    isReadFirstFrame = YES ;
    isReadLastFrame = NO ;
    firstFrame = [self.videoOutput copyNextSampleBuffer];
    self.displayLink.paused = NO ;
}
// 只读 最后一帧
- (void)startReadForLastFrame {
    
    isReadFirstFrame = NO ;
    isReadLastFrame = YES ;
    self.displayLink.paused = NO ;
}


// 停止
- (void)stopReading {
    
    isReadFirstFrame = NO ;
    isReadLastFrame = NO ;
    _displayLink.paused = YES;
}

- (void)destory {
    
    _displayLink.paused = YES;
    [_displayLink invalidate];
    _displayLink = nil ;
    
    [self.assetReader cancelReading];
    [self.assetWriter cancelWriting];
    
    self.assetWriter = nil;
    self.assetReader = nil;
    
    [self destorySemaphore];
}

- (void)destorySemaphore {
    if (self.finishSemaphore) {
        
        do {
            if (dispatch_semaphore_wait(self.finishSemaphore, DISPATCH_TIME_NOW) != 0) {
                dispatch_semaphore_signal(self.finishSemaphore) ;
                self.finishSemaphore = nil ;
            }
        } while (self.finishSemaphore);
    }
}

/** 编码音频 */
- (NSDictionary *)configAudioInput  {
    AudioChannelLayout channelLayout = {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
        .mChannelBitmap = kAudioChannelBit_Left,
        .mNumberChannelDescriptions = 0
    };
    NSData *channelLayoutData = [NSData dataWithBytes:&channelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    NSDictionary *audioInputSetting = @{
                                        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                        AVSampleRateKey: @(44100),
                                        AVNumberOfChannelsKey: @(2),
                                        AVChannelLayoutKey:channelLayoutData
                                        };
    return audioInputSetting;
}

/** 编码视频 */
- (NSDictionary *)configVideoInput  {
    
    CGSize videoSize = self.videoTrack.naturalSize ;
    
    NSDictionary *videoInputSetting = @{
                                        AVVideoCodecKey:AVVideoCodecH264,
                                        AVVideoWidthKey: @(videoSize.width),
                                        AVVideoHeightKey: @(videoSize.height),
                                        };
    return videoInputSetting;
}

- (void)createPixelBufferWithSize:(CGSize)size  {
    
    if (!renderTarget) {
        NSDictionary* pixelBufferOptions = @{ (NSString*) kCVPixelBufferPixelFormatTypeKey :
                                                  @(kCVPixelFormatType_32BGRA),
                                              (NSString*) kCVPixelBufferWidthKey : @(size.width),
                                              (NSString*) kCVPixelBufferHeightKey : @(size.height),
                                              (NSString*) kCVPixelBufferOpenGLESCompatibilityKey : @YES,
                                              (NSString*) kCVPixelBufferIOSurfacePropertiesKey : @{}};
        
        CVPixelBufferCreate(kCFAllocatorDefault,
                            size.width, size.height,
                            kCVPixelFormatType_32BGRA,
                            (__bridge CFDictionaryRef)pixelBufferOptions,
                            &renderTarget);
    }
}

- (void *)getCopyDataFromPixelBuffer:(CVPixelBufferRef)pixelBuffer  {
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    size_t size = CVPixelBufferGetDataSize(pixelBuffer);
    void *bytes = (void *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    void *copyData = malloc(size);
    
    memcpy(copyData, bytes, size);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return copyData;
}

- (void)copyDataBackToPixelBuffer:(CVPixelBufferRef)pixelBuffer copyData:(void *)copyData   {
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    size_t size = CVPixelBufferGetDataSize(pixelBuffer);
    void *bytes = (void *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    memcpy(bytes, copyData, size);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

- (void)dealloc{
    NSLog(@"FUVideoReader dealloc");
    if (renderTarget) {
        CVPixelBufferRelease(renderTarget);
    }
    
    if (firstFrame) {
        CFRelease(firstFrame);
    }
}

@end
