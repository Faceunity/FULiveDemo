//
//  FUVideoProcessor.m
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/27.
//

#import "FUVideoProcessor.h"
#import "FUVideoReader.h"
#import "FUVideoWriter.h"

@interface FUVideoProcessor ()<FUVideoReaderDelegate>

@property (nonatomic, strong) FUVideoReader *reader;
@property (nonatomic, strong) FUVideoWriter *writer;

@end

@implementation FUVideoProcessor

#pragma mark - Initializer

- (instancetype)initWithReadingURL:(NSURL *)readingURL writingURL:(NSURL *)writingURL {
    return [self initWithReadingURL:readingURL readerSettings:[[FUVideoReaderSettings alloc] init] writingURL:writingURL writerSettings:[[FUVideoWriterSettings alloc] init]];
}

- (instancetype)initWithReadingURL:(NSURL *)readingURL readerSettings:(FUVideoReaderSettings *)readerSettings writingURL:(NSURL *)writingURL writerSettings:(FUVideoWriterSettings *)writerSettings {
    self = [super init];
    if (self) {
        if (!readerSettings) {
            readerSettings = [[FUVideoReaderSettings alloc] init];
        }
        if (!writerSettings) {
            writerSettings = [[FUVideoWriterSettings alloc] init];
        }
        if (!readerSettings.needsAudioTrack && writerSettings.needsAudioTrack) {
            // 解码设置没有音频轨道时强制删除编码音频轨道
            writerSettings.needsAudioTrack = NO;
        }
        self.reader = [[FUVideoReader alloc] initWithURL:readingURL settings:readerSettings];
        if (!self.reader.containAudioTrack && readerSettings.needsAudioTrack) {
            // 源文件中本来就不包含音频轨道时强制删除解码和编码的音频轨道
            readerSettings.needsAudioTrack = NO;
            self.reader.readerSettings = readerSettings;
            writerSettings.needsAudioTrack = NO;
        }
        if (self.reader.videoOrientation != writerSettings.videoOrientation) {
            writerSettings.videoOrientation = self.reader.videoOrientation;
        }
        self.reader.delegate = self;
        self.writer = [[FUVideoWriter alloc] initWithVideoURL:writingURL videoSize:self.reader.videoSize setting:writerSettings];
    }
    return self;
}

#pragma mark - Instance methods

- (void)startProcessing {
    @weakify(self)
    [self.reader startWithCompletion:^(BOOL success) {
        if (success) {
            self.writer.videoInputReadyHandler = ^BOOL{
                @strongify(self)
                return [self.reader readNextVideoBuffer];
            };
            self.writer.audioInputReadyHandler = ^BOOL{
                @strongify(self)
                return [self.reader readNextAudioBuffer];
            };
            [self.writer start];
        }
    }];
}

- (void)cancelProcessing {
    [self.writer cancel];
    self.writer = nil;
    [self.reader cancel];
    self.reader = nil;
}

#pragma mark - FUVideoReaderDelegate

- (void)videoReaderDidOutputVideoSampleBuffer:(CMSampleBufferRef)videoSampleBuffer {
    if (self.processingVideoBufferHandler) {
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer);
        CMTime timeStamp = CMSampleBufferGetPresentationTimeStamp(videoSampleBuffer);
        pixelBuffer = self.processingVideoBufferHandler(pixelBuffer);
        if (self.writer.videoInput.isReadyForMoreMediaData) {
            [self.writer appendPixelBuffer:pixelBuffer time:timeStamp];
        }
    } else {
        if (self.writer.videoInput.isReadyForMoreMediaData) {
            [self.writer appendVideoSampleBuffer:videoSampleBuffer];
        }
    }
    CMSampleBufferInvalidate(videoSampleBuffer);
    CFRelease(videoSampleBuffer);
}

- (void)videoReaderDidOutputAudioSampleBuffer:(CMSampleBufferRef)audioSampleBuffer {
    if (self.processingAudioBufferHandler) {
        audioSampleBuffer = self.processingAudioBufferHandler(audioSampleBuffer);
    }
    if (self.writer.audioInput.isReadyForMoreMediaData) {
        [self.writer appendAudioSampleBuffer:audioSampleBuffer];
    }
    CMSampleBufferInvalidate(audioSampleBuffer);
    CFRelease(audioSampleBuffer);
}

- (void)videoReaderDidFinishVideoReading {
    self.writer.videoInputReadyHandler = ^BOOL{
        return NO;
    };
}

- (void)videoReaderDidFinishAudioReading {
    self.writer.audioInputReadyHandler = ^BOOL{
        return NO;
    };
}

- (void)videoReaderDidFinishReading {
    [self.writer finishWritingWithCompletion:nil];
    if (self.processingFinishedHandler) {
        self.processingFinishedHandler();
    }
}

@end
