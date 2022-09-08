//
//  FUVideoReader.m
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/9.
//

#import "FUVideoReader.h"

/// 默认解码每帧间隔时间
const float kFUReaderFrameDuration = (1.0/30);

@interface FUVideoReader ()

@property (nonatomic, assign) BOOL isReading;

@property (nonatomic, strong) AVAssetReader *reader;
@property (nonatomic, strong) AVAssetReaderOutput *videoOutput;
@property (nonatomic, strong) AVAssetReaderOutput *audioOutput;
@property (nonatomic, strong) AVAssetTrack *videoTrack;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) dispatch_queue_t readingQueue;
@property (nonatomic, copy) void (^completionHandler)(BOOL success);

@end


@implementation FUVideoReader {
    BOOL videoReadingFinished, audioReadingFinished;
    // 是否保存了视频第一帧
    BOOL savedFirstSampleBuffer;
    // 上一帧保存的时间
    CFAbsoluteTime lastFrameAbsoluteTime;
    // 上一帧保存的时间戳
    CMTime lastFrameTimeStamp;

    CMSampleBufferRef firstVideoSampleBuffer, lastVideoSampleBuffer;
    
    void *readingQueueKey;
}

#pragma mark - Initializer

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL settings:[[FUVideoReaderSettings alloc] init]];
}

- (instancetype)initWithURL:(NSURL *)URL settings:(FUVideoReaderSettings *)settings {
    NSAssert(URL, @"URL cannot be nil!");
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey : @YES};
    return [self initWithAsset:[[AVURLAsset alloc] initWithURL:URL options:options] settings:settings];
}

- (instancetype)initWithAsset:(AVAsset *)asset {
    return [self initWithAsset:asset settings:[[FUVideoReaderSettings alloc] init]];
}

- (instancetype)initWithAsset:(AVAsset *)asset settings:(FUVideoReaderSettings *)settings {
    self = [super init];
    if (self) {
        NSAssert(asset, @"Asset cannot be nil!");
        self.asset = asset;
        if (!settings) {
            self.readerSettings = [[FUVideoReaderSettings alloc] init];
        } else {
            self.readerSettings = settings;
        }
    }
    return self;
}

#pragma mark - Instance methods

- (void)startWithCompletion:(void (^)(BOOL))completionHandler {
    self.completionHandler = completionHandler;
    videoReadingFinished = NO;
    audioReadingFinished = NO;
    savedFirstSampleBuffer = NO;
    
    [self.asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [self.asset statusOfValueForKey:@"tracks" error:&error];
        if (tracksStatus != AVKeyValueStatusLoaded) {
            return;
        }
        [self asynchronousBlockOnReadingQueue:^{
            [self process];
        }];
    }];
}

- (void)process {
    self.reader = [self createReader];
    for (AVAssetReaderOutput *output in self.reader.outputs) {
        if ([output.mediaType isEqualToString:AVMediaTypeVideo]) {
            self.videoOutput = output;
        } else if ([output.mediaType isEqualToString:AVMediaTypeAudio]) {
            self.audioOutput = output;
        }
    }
    self.isReading = [self.reader startReading];
    if (!self.isReading) {
        NSLog(@"FUVideoComponent: Start reading failed!");
        !self.completionHandler ?: self.completionHandler(NO);
    } else {
        !self.completionHandler ?: self.completionHandler(YES);
        if (self.readerSettings.readingAutomatically) {
            // 自动开始解码
            while (self.reader.status == AVAssetReaderStatusReading && self.isReading) {
                if (!self->videoReadingFinished) {
                    [self readNextVideoBuffer];
                }
                if (self.readerSettings.needsAudioTrack && !self->audioReadingFinished) {
                    [self readNextAudioBuffer];
                }
            }
            [self finish];
        }
    }
}

- (void)cancel {
    videoReadingFinished = YES;
    audioReadingFinished = YES;
    self.isReading = NO;
    if (self.reader) {
        [self.reader cancelReading];
        _reader = nil;
    }
}

- (BOOL)readNextVideoBuffer {
    if (self.reader.status == AVAssetReaderStatusReading && !videoReadingFinished && self.isReading) {
        CMSampleBufferRef sampleBuffer = [self.videoOutput copyNextSampleBuffer];
        if (sampleBuffer != NULL) {
            if (!savedFirstSampleBuffer) {
                if (firstVideoSampleBuffer != NULL) {
                    CMSampleBufferInvalidate(firstVideoSampleBuffer);
                    CFRelease(firstVideoSampleBuffer);
                }
                // 保存第一帧
                CMSampleBufferCreateCopy(kCFAllocatorDefault, sampleBuffer, &firstVideoSampleBuffer);
                savedFirstSampleBuffer = YES;
            } else {
                if (lastVideoSampleBuffer != NULL) {
                    CMSampleBufferInvalidate(lastVideoSampleBuffer);
                    CFRelease(lastVideoSampleBuffer);
                }
                // 保存帧
                CMSampleBufferCreateCopy(kCFAllocatorDefault, sampleBuffer, &lastVideoSampleBuffer);
            }
            // 当前帧与上一帧时间差（实际循环一次时间）
            CGFloat difference = CFAbsoluteTimeGetCurrent() - lastFrameAbsoluteTime;
            if (self.readerSettings.readAtVideoRate) {
                // 当前帧的时间戳
                CMTime presentationTimeStamp = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
                // 当前帧与上一帧的时间戳差
                CMTime timeStampDifference = CMTimeSubtract(presentationTimeStamp, lastFrameTimeStamp);
                // 获取秒级时间差
                CGFloat secondsTimeDifference =  CMTimeGetSeconds(timeStampDifference);

                if (secondsTimeDifference > difference) {
                    // 需要sleep等待
                    usleep(1000000 * (secondsTimeDifference - difference));
                }
                // 保存时间和时间戳
                lastFrameTimeStamp = presentationTimeStamp;
                lastFrameAbsoluteTime = CFAbsoluteTimeGetCurrent();
            } else {
                // 默认速度读取设置固定时间间隔
                if (kFUReaderFrameDuration > difference) {
                    usleep(1000000 * (kFUReaderFrameDuration - difference));
                }
                lastFrameAbsoluteTime = CFAbsoluteTimeGetCurrent();
            }
            if (self.isReading && self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidOutputVideoSampleBuffer:)]) {
                [self.delegate videoReaderDidOutputVideoSampleBuffer:sampleBuffer];
            }
            return YES;
        } else {
            // 视频解码完成
            videoReadingFinished = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidFinishVideoReading)]) {
                [self.delegate videoReaderDidFinishVideoReading];
            }
            if (!self.readerSettings.readingAutomatically) {
                [self finish];
            }
        }
    }
    return NO;
}

- (BOOL)readNextAudioBuffer {
    if (self.reader.status == AVAssetReaderStatusReading && !audioReadingFinished && self.isReading) {
        CMSampleBufferRef sampleBuffer = [self.audioOutput copyNextSampleBuffer];
        if (sampleBuffer != NULL) {
            if (self.isReading && self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidOutputAudioSampleBuffer:)]) {
                [self.delegate videoReaderDidOutputAudioSampleBuffer:sampleBuffer];
            }
            return YES;
        } else {
            // 音频解码完成
            audioReadingFinished = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidFinishAudioReading)]) {
                [self.delegate videoReaderDidFinishAudioReading];
            }
            if (!self.readerSettings.readingAutomatically) {
                [self finish];
            }
        }
    }
    return NO;
}

- (CMSampleBufferRef)firstVideoSampleBuffer {
    return firstVideoSampleBuffer;
}

- (CMSampleBufferRef)lastVideoSampleBuffer {
    if (lastVideoSampleBuffer == NULL || !videoReadingFinished) {
        return NULL;
    }
    return lastVideoSampleBuffer;
}

#pragma mark - Private methods

- (void)synchronousBlockOnReadingQueue:(void (^)(void))block {
    if (dispatch_get_specific(readingQueueKey)) {
        block();
    } else {
        dispatch_sync(self.readingQueue, ^{
            block();
        });
    }
}

- (void)asynchronousBlockOnReadingQueue:(void (^)(void))block {
    if (dispatch_get_specific(readingQueueKey)) {
        block();
    } else {
        dispatch_async(self.readingQueue, ^{
            block();
        });
    }
}

- (void)finish {
    BOOL finished = NO;
    if (self.reader.status == AVAssetReaderStatusCompleted) {
        if ((self.readerSettings.needsAudioTrack && videoReadingFinished && audioReadingFinished) || (!self.readerSettings.needsAudioTrack && videoReadingFinished)) {
            finished = YES;
        }
    }
    if (finished) {
        [self cancel];
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidFinishReading)]) {
            [self.delegate videoReaderDidFinishReading];
        }
        if (self.readerSettings.needsRepeat) {
            // 从头开始读取
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startWithCompletion:self.completionHandler];
            });
        }
    }
}

#pragma mark - Getters

- (AVAssetReader *)createReader {
    NSError *error = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:self.asset error:&error];
    NSAssert(error == nil, @"Create reader failed!");
    
    NSDictionary *settings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(self.readerSettings.videoOutputFormat)};
    AVAssetReaderTrackOutput *videoTrackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:self.videoTrack outputSettings:settings];
    videoTrackOutput.alwaysCopiesSampleData = NO;
    [reader addOutput:videoTrackOutput];
    
    if (self.readerSettings.needsAudioTrack) {
        // Audio track
        NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
        NSAssert(audioTracks.count > 0, @"Does not contain an audio track, please set 'needsAudioTrack' to NO");
        AVAssetTrack *audioTrack = audioTracks[0];
        NSDictionary *audioOutputSettings = @{(id)AVFormatIDKey : @(self.readerSettings.audioOutputFormat)};
        AVAssetReaderTrackOutput *audioTrackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:audioOutputSettings];
        audioTrackOutput.alwaysCopiesSampleData = NO;
        [reader addOutput:audioTrackOutput];
    }
    return reader;
}

- (CGSize)videoSize {
    return self.videoTrack.naturalSize;
}

- (FUVideoOrientation)videoOrientation {
    FUVideoOrientation orientation = FUVideoOrientationPortrait;
    CGAffineTransform transform = self.videoTrack.preferredTransform;
    if(transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0) {
        orientation = FUVideoOrientationLandscapeRight ;
    }else if(transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0){
        orientation = FUVideoOrientationLandscapeLeft;
    }else if(transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0){
        orientation = FUVideoOrientationPortrait;
    }else if(transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0){
        orientation = FUVideoOrientationUpsideDown;
    }
    return orientation;
}

- (BOOL)containAudioTrack {
    return [self.asset tracksWithMediaType:AVMediaTypeAudio].count > 0;
}

- (AVAssetTrack *)videoTrack {
    if (!_videoTrack) {
        NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
        NSAssert(videoTracks.count > 0, @"Does not contain an video track");
        _videoTrack = videoTracks[0];
    }
    return _videoTrack;
}

- (dispatch_queue_t)readingQueue {
    if (_readingQueue == NULL) {
        readingQueueKey = &readingQueueKey;
        _readingQueue = dispatch_queue_create("com.faceunity.FUVideoComponent.readingQueue", DISPATCH_QUEUE_SERIAL);
#if OS_OBJECT_USE_OBJC
        dispatch_queue_set_specific(_readingQueue, readingQueueKey, (__bridge void *)self, NULL);
#endif
    }
    return _readingQueue;
}

#pragma mark - Dealloc

- (void)dealloc {
    if (firstVideoSampleBuffer != NULL) {
        CMSampleBufferInvalidate(firstVideoSampleBuffer);
        CFRelease(firstVideoSampleBuffer);
    }
    if (lastVideoSampleBuffer != NULL) {
        CMSampleBufferInvalidate(lastVideoSampleBuffer);
        CFRelease(lastVideoSampleBuffer);
    }
}

@end
