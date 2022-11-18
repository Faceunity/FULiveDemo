//
//  FUVideoWriter.m
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/9.
//

#import "FUVideoWriter.h"

@interface FUVideoWriter ()

@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic, strong) AVAssetWriterInput *audioInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *pixelBufferInput;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, strong) FUVideoWriterSettings *writerSettings;

@property (nonatomic, strong) dispatch_queue_t processQueue;

@end

@implementation FUVideoWriter {
    BOOL videoWritingFinished, audioWritingFinished;
    CMTime startWritingTime;
    
    dispatch_queue_t videoQueue, audioQueue;
}

#pragma mark - Initializer

- (instancetype)initWithVideoURL:(NSURL *)URL
                       videoSize:(CGSize)size {
    return [self initWithVideoURL:URL videoSize:size setting:[[FUVideoWriterSettings alloc] init]];
}

- (instancetype)initWithVideoURL:(NSURL *)URL videoSize:(CGSize)size setting:(FUVideoWriterSettings *)settings {
    self = [super init];
    if (self) {
        NSAssert(URL, @"URL cannot be nil!");
        NSAssert(!CGSizeEqualToSize(size, CGSizeZero), @"size cannot be 0!");
        
        self.videoURL = URL;
        self.videoSize = size;
        if (!settings) {
            settings = [[FUVideoWriterSettings alloc] init];
        }
        self.writerSettings = settings;
    }
    return self;
}

#pragma mark - Instance methods

- (void)start {
    // 如果文件已经存在，先删除旧文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoURL.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:self.videoURL error:nil];
    }
    self.writer = [self createWriter];
    if (![self.writer startWriting]) {
        NSLog(@"FUVideoWriter: Start writing failed!");
        return;
    }
    [self.writer startSessionAtSourceTime:kCMTimeZero];
    dispatch_async(self.processQueue, ^{
        [self requestForWritingData];
    });
}

- (void)stop {
    videoWritingFinished = YES;
    audioWritingFinished = YES;
    startWritingTime = kCMTimeInvalid;
    if (self.writer) {
        if (self.writer.status == AVAssetWriterStatusWriting) {
            [self.writer cancelWriting];
            _writer = nil;
        }
    }
}

/// 请求写入数据
- (void)requestForWritingData {
    if (self.videoInputReadyHandler) {
        videoQueue = dispatch_queue_create("com.faceunity.FUVideoWriter.videoQueue", DISPATCH_QUEUE_SERIAL);
        [self.videoInput requestMediaDataWhenReadyOnQueue:videoQueue usingBlock:^{
            while (self.videoInput.isReadyForMoreMediaData) {
                if (!self.videoInputReadyHandler() && !self->videoWritingFinished) {
                    // 标记视频输入完成
                    [self.videoInput markAsFinished];
                    self->videoWritingFinished = YES;
                }
            }
        }];
    }
    if (self.audioInputReadyHandler && self.writerSettings.needsAudioTrack) {
        audioQueue = dispatch_queue_create("com.faceunity.FUVideoWriter.audioQueue", DISPATCH_QUEUE_SERIAL);
        [self.audioInput requestMediaDataWhenReadyOnQueue:audioQueue usingBlock:^{
            while (self.audioInput.isReadyForMoreMediaData) {
                if (!self.audioInputReadyHandler() && !self->audioWritingFinished) {
                    // 标记音频输入完成
                    [self.audioInput markAsFinished];
                    self->audioWritingFinished = YES;
                }
            }
        }];
    }
}

- (void)finishWritingWithCompletion:(void (^)(void))completion {
    if (self.writer.status == AVAssetWriterStatusCompleted || self.writer.status == AVAssetWriterStatusCancelled || self.writer.status == AVAssetWriterStatusUnknown) {
        NSLog(@"FUVideoWriter: Completion!");
        if (completion) {
            completion();
        }
        return;
    }
    if (self.writer.status == AVAssetWriterStatusWriting) {
        if (!videoWritingFinished) {
            // 标记视频输入完成
            [self.videoInput markAsFinished];
            videoWritingFinished = YES;
        }
        if (self.writerSettings.needsAudioTrack && !audioWritingFinished) {
            // 标记音频输入完成
            [self.audioInput markAsFinished];
            audioWritingFinished = YES;
        }
        [self.writer finishWritingWithCompletionHandler:^{
            NSLog(@"FUVideoWriter: Completion!");
            [self stop];
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!self.videoInput.isReadyForMoreMediaData || videoWritingFinished) {
        NSLog(@"FUVideoWriter: video input is not ready");
        return;
    }
    if (self.writer.status == AVAssetWriterStatusWriting) {
        if (![self.videoInput appendSampleBuffer:sampleBuffer]) {
            NSLog(@"FUVideoWriter: Append video sample buffer failed!");
        }
    } else {
        NSLog(@"FUVideoWriter: Could not write video sample buffer");
    }
}

- (void)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer time:(CMTime)timeStamp {
    if (!self.videoInput.isReadyForMoreMediaData || videoWritingFinished) {
        NSLog(@"FUVideoWriter: video input is not ready");
        return;
    }
    if (self.writer.status == AVAssetWriterStatusWriting) {
        if (![self.pixelBufferInput appendPixelBuffer:pixelBuffer withPresentationTime:timeStamp]) {
            NSLog(@"FUVideoWriter: Append pixel buffer failed!");
        }
    } else {
        NSLog(@"FUVideoWriter: Could not write pixel buffer");
    }
}

- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!self.writerSettings.needsAudioTrack) {
        NSLog(@"FUVideoWriter: needsWriteAudio is NO");
        return;
    }
    if (!self.audioInput.isReadyForMoreMediaData || audioWritingFinished) {
        NSLog(@"FUVideoWriter: audio input is not ready");
        return;
    }
    if (self.writer.status == AVAssetWriterStatusWriting) {
        if (![self.audioInput appendSampleBuffer:sampleBuffer]) {
            NSLog(@"FUVideoWriter: Append audio sample buffer failed!");
        }
    } else {
        NSLog(@"FUVideoWriter: Could not write audio sample buffer");
    }
}

#pragma mark - Getters

- (BOOL)isWriting {
    return self.writer.status == AVAssetWriterStatusWriting;
}

- (AVAssetWriter *)createWriter {
    NSError *error = nil;
    AVAssetWriter *assetWriter = [[AVAssetWriter alloc] initWithURL:self.videoURL fileType:self.writerSettings.fileType error:&error];
    assetWriter.shouldOptimizeForNetworkUse = YES;
    NSAssert(error == nil, @"Create writer failed!");
    // 默认录制时间为10s，大于10s时需要设置为kCMTimeInvalid
    assetWriter.movieFragmentInterval = kCMTimeInvalid;
    self.videoInput= [self createVideoInput];
    if ([assetWriter canAddInput:self.videoInput]) {
        [assetWriter addInput:self.videoInput];
    }
    NSDictionary *pixelBufferAttributes = @{
        (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
        (id)kCVPixelBufferWidthKey : @(self.videoSize.width),
        (id)kCVPixelBufferHeightKey : @(self.videoSize.height),
    };
    self.pixelBufferInput = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.videoInput sourcePixelBufferAttributes:pixelBufferAttributes];
    if (self.writerSettings.needsAudioTrack) {
        self.audioInput = [self createAudioInput];
        if ([assetWriter canAddInput:self.audioInput]) {
            [assetWriter addInput:self.audioInput];
        }
    }
    return assetWriter;
}

- (AVAssetWriterInput *)createVideoInput {
    NSDictionary *videoSettings = @{
        (id)AVVideoCodecKey : self.writerSettings.videoInputFormat,
        (id)AVVideoWidthKey : @(self.videoSize.width),
        (id)AVVideoHeightKey : @(self.videoSize.height)
    };
    AVAssetWriterInput *input = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    // 视频文件编码是否需要实时处理
    input.expectsMediaDataInRealTime = self.writerSettings.isRealTimeData;
    CGAffineTransform transform;
    switch (self.writerSettings.videoOrientation) {
        case FUVideoOrientationPortrait:
            transform = CGAffineTransformIdentity;
            break;
        case FUVideoOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case FUVideoOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case FUVideoOrientationUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI);
            break;
    }
    input.transform = transform;
    return input;
}

- (AVAssetWriterInput *)createAudioInput {
    NSDictionary *settings = @{
        (id)AVFormatIDKey : @(self.writerSettings.audioInputFormat),
        (id)AVSampleRateKey : @(self.writerSettings.audioRate),  // 码率
        (id)AVNumberOfChannelsKey : @(self.writerSettings.audioChannels) //声道
    };
    // 使用默认设置
    AVAssetWriterInput *input = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
    // 音频文件编码是否需要实时处理
    input.expectsMediaDataInRealTime = self.writerSettings.isRealTimeData;
    return input;
}

- (dispatch_queue_t)processQueue {
    if (!_processQueue) {
        _processQueue = dispatch_queue_create("com.faceunity.FUVideoWriter.processQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _processQueue;
}

@end
