//
//  FUVideoReader.m
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/9.
//

#import "FUVideoReader.h"

/// 默认解码每帧间隔时间
const float kFUReaderFrameDuration = (1.0/120);

@interface FUVideoReader ()

@property (nonatomic, strong) AVAssetReader *reader;
@property (nonatomic, strong) AVAssetReaderOutput *videoOutput;
@property (nonatomic, strong) AVAssetReaderOutput *audioOutput;
@property (nonatomic, strong) AVAssetTrack *videoTrack;
@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) dispatch_queue_t processQueue;

@end


@implementation FUVideoReader {
    BOOL videoReadingFinished, audioReadingFinished;
    // 上一帧保存的时间
    CFAbsoluteTime lastFrameAbsoluteTime;
    // 上一帧保存的时间戳
    CMTime lastFrameTimeStamp;
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

- (void)start {
    self->videoReadingFinished = NO;
    self->audioReadingFinished = NO;
    self.reader = [self createReader];
    if (![self.reader startReading]) {
        NSLog(@"FUVideoReader: Start reading failed!");
    } else {
        if (self.readerSettings.readingAutomatically) {
            dispatch_async(self.processQueue, ^{
                // 自动开始异步解码
                while (self.reader.status == AVAssetReaderStatusReading) {
                    if (!self->videoReadingFinished) {
                        [self readNextVideoBuffer];
                    }
                    if (self.readerSettings.needsAudioTrack && !self->audioReadingFinished) {
                        [self readNextAudioBuffer];
                    }
                }
                [self finish];
            });
        }
    }
}

- (void)stop {
    videoReadingFinished = YES;
    audioReadingFinished = YES;
    if (self.reader) {
        [self.reader cancelReading];
        self->_reader = nil;
    }
}

- (BOOL)readNextVideoBuffer {
    if (self.reader.status == AVAssetReaderStatusReading && !videoReadingFinished) {
        CMSampleBufferRef sampleBuffer = [self.videoOutput copyNextSampleBuffer];
        if (sampleBuffer != NULL) {
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidOutputVideoSampleBuffer:)]) {
                [self.delegate videoReaderDidOutputVideoSampleBuffer:sampleBuffer];
            } else {
                CMSampleBufferInvalidate(sampleBuffer);
                CFRelease(sampleBuffer);
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
    if (self.reader.status == AVAssetReaderStatusReading && !audioReadingFinished) {
        CMSampleBufferRef sampleBuffer = [self.audioOutput copyNextSampleBuffer];
        if (sampleBuffer != NULL) {
            if (self.isReading && self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidOutputAudioSampleBuffer:)]) {
                [self.delegate videoReaderDidOutputAudioSampleBuffer:sampleBuffer];
            } else {
                CMSampleBufferInvalidate(sampleBuffer);
                CFRelease(sampleBuffer);
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

#pragma mark - Private methods

- (void)finish {
    BOOL finished = NO;
    if (self.reader.status == AVAssetReaderStatusCompleted) {
        if ((self.readerSettings.needsAudioTrack && videoReadingFinished && audioReadingFinished) || (!self.readerSettings.needsAudioTrack && videoReadingFinished)) {
            finished = YES;
        }
    }
    if (finished) {
        [self stop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoReaderDidFinishReading)]) {
            [self.delegate videoReaderDidFinishReading];
        }
        if (self.readerSettings.needsRepeat) {
            // 从头开始读取
            dispatch_async(dispatch_get_main_queue(), ^{
                [self start];
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
    self.videoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:self.videoTrack outputSettings:settings];
    self.videoOutput.alwaysCopiesSampleData = NO;
    [reader addOutput:self.videoOutput];
    
    if (self.readerSettings.needsAudioTrack) {
        NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
        if (audioTracks.count == 0) {
            NSLog(@"FUVideoReader: the asset does not contain an audio track");
            self.readerSettings.needsAudioTrack = NO;
        }
    }
    
    if (self.readerSettings.needsAudioTrack) {
        // Audio track
        NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack *audioTrack = audioTracks[0];
        NSDictionary *audioOutputSettings = @{(id)AVFormatIDKey : @(self.readerSettings.audioOutputFormat)};
        self.audioOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:audioOutputSettings];
        self.audioOutput.alwaysCopiesSampleData = NO;
        [reader addOutput:self.audioOutput];
    }
    return reader;
}

- (BOOL)isReading {
    return self.reader.status == AVAssetReaderStatusReading;
}

- (CGSize)videoSize {
    return self.videoTrack.naturalSize;
}

- (FUVideoOrientation)videoOrientation {
    FUVideoOrientation orientation = FUVideoOrientationPortrait;
    CGAffineTransform transform = self.videoTrack.preferredTransform;
    if(transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0) {
        orientation = FUVideoOrientationLandscapeRight;
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

- (CGFloat)duration {
    return CMTimeGetSeconds(self.asset.duration);
}

- (dispatch_queue_t)processQueue {
    if (!_processQueue) {
        _processQueue = dispatch_queue_create("com.faceunity.FUVideoReader.processQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _processQueue;
}

@end
