//
//  FUVideoRenderViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/9.
//

#import "FUVideoRenderViewModel.h"
#import <FURenderKit/FUVideoReader.h>
#import <FURenderKit/FUVideoProcessor.h>

@interface FUVideoRenderViewModel ()<FUVideoReaderDelegate>

@property (nonatomic, assign) FUVideoOrientation videoOrientation;

@property (nonatomic, strong) NSURL *videoURL;
/// 保存时需要Processor边读边写
@property (nonatomic, strong) FUVideoProcessor *videoProcessor;
/// 播放时只需要Reader
@property (nonatomic, strong) FUVideoReader *videoReader;

@property (nonatomic, strong) AVPlayer *audioReader;

@property (nonatomic, assign) BOOL isDestroyed;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSOperationQueue *previewQueue;

@end

@implementation FUVideoRenderViewModel {
    // 缓存的预览帧
    CVPixelBufferRef previewBuffer;
}

#pragma mark - Initializer

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [super init];
    if (self) {
        self.rendering = YES;
        self.detectingParts = FUDetectingPartsFace;
        
        if (self.necessaryAIModelTypes & FUAIModelTypeFace) {
            [FURenderKitManager setFaceProcessorDetectMode:FUFaceProcessorDetectModeVideo];
        }
        if (self.necessaryAIModelTypes & FUAIModelTypeHuman) {
            [FURenderKitManager setHumanProcessorDetectMode:FUHumanProcessorDetectModeVideo];
        }
        self.videoURL = videoURL;
        self.previewQueue = [[NSOperationQueue alloc] init];
        self.previewQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)dealloc {
    if (previewBuffer != NULL) {
        CVPixelBufferRelease(previewBuffer);
        previewBuffer = NULL;
    }
}

#pragma mark - Instance methods

- (void)startPreviewing {
    if (previewBuffer == NULL) {
        UIImage *previewImage = [FUUtility previewImageFromVideoURL:self.videoURL preferredTrackTransform:NO];
        previewBuffer = [FUImageHelper pixelBufferFromImage:previewImage];
    }
    if (!_displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.frameInterval = 4;
    }
    self.displayLink.paused = NO;
}

- (void)stopPreviewing {
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self.previewQueue cancelAllOperations];
    if (previewBuffer != NULL) {
        CVPixelBufferRelease(previewBuffer);
        previewBuffer = NULL;
    }
}

- (void)startReading {
    [self stopPreviewing];
    // 视频解码
    [self.videoReader start];
    // 播放音频
    [self.audioReader play];
}

- (void)stopReading {
    if (_videoReader) {
        [self.videoReader stop];
    }
    if (_audioReader) {
        [self.audioReader pause];
        _audioReader = nil;
    }
}

- (void)startProcessing {
    [self stopPreviewing];
    self.videoProcessor = [[FUVideoProcessor alloc] initWithReadingURL:self.videoURL  writingURL:[NSURL fileURLWithPath:kFUFinalPath]];
    @FUWeakify(self)
    self.videoProcessor.processingVideoBufferHandler = ^CVPixelBufferRef _Nonnull(CVPixelBufferRef  _Nonnull videoPixelBuffer, CGFloat time) {
        @FUStrongify(self)
        videoPixelBuffer = [self processVideoPixelBuffer:videoPixelBuffer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRenderProcessingProgress:)]) {
            if (time >= 0 && self.videoProcessor.reader.duration > 0) {
                // 计算进度
                CGFloat progress = time / self.videoProcessor.reader.duration;
                [self.delegate videoRenderProcessingProgress:progress];
            }
        }
        return videoPixelBuffer;
    };

    self.videoProcessor.processingFinishedHandler = ^{
        @FUStrongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRenderDidFinishProcessing)]) {
            [self.delegate videoRenderDidFinishProcessing];
        }
    };

    [self.videoProcessor startProcessing];
}

- (void)stopProcessing {
    if (self.videoProcessor) {
        [self.videoProcessor cancelProcessing];
        self.videoProcessor = nil;
    }
}

- (void)destroy {
    [self stopReading];
    [self stopPreviewing];
    [self stopProcessing];
    self.isDestroyed = YES;
}

#pragma mark - Event response

- (void)displayLinkAction {
    [self.previewQueue addOperationWithBlock:^{
        CVPixelBufferRetain(self->previewBuffer);
        [self renderVideoPixelBuffer:self->previewBuffer];
        CVPixelBufferRelease(self->previewBuffer);
    }];
}

#pragma mark - Private methods

- (void)renderVideoPixelBuffer:(CVPixelBufferRef)videoPixelBuffer {
    [FURenderKitManager updateBeautyBlurEffect];
    @autoreleasepool {
        if (self.isRendering) {
            FURenderInput *input = [[FURenderInput alloc] init];
            input.pixelBuffer = videoPixelBuffer;
            input.renderConfig.imageOrientation = FUImageOrientationUP;
            switch (self.videoReader.videoOrientation) {
                case FUVideoOrientationPortrait:
                    input.renderConfig.imageOrientation = FUImageOrientationUP;
                    break;
                case FUVideoOrientationLandscapeRight:
                    input.renderConfig.imageOrientation = FUImageOrientationLeft;
                    break;
                case FUVideoOrientationUpsideDown:
                    input.renderConfig.imageOrientation = FUImageOrientationDown;
                    break;
                case FUVideoOrientationLandscapeLeft:
                    input.renderConfig.imageOrientation = FUImageOrientationRight;
                    break;
            }
            FURenderOutput *output =  [[FURenderKit shareRenderKit] renderWithInput:input];
            videoPixelBuffer = output.pixelBuffer;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRenderDidOutputPixelBuffer:)]) {
            [self.delegate videoRenderDidOutputPixelBuffer:videoPixelBuffer];
        }
        if (self.detectingParts != FUDetectingPartsNone) {
            // 需要检查人脸/人体/手势检测状态
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoRenderShouldCheckDetectingStatus:)]) {
                [self.delegate videoRenderShouldCheckDetectingStatus:self.detectingParts];
            }
        }
    }
}

- (CVPixelBufferRef)processVideoPixelBuffer:(CVPixelBufferRef)videoPixelBuffer {
    @autoreleasepool {
        FURenderInput *input = [[FURenderInput alloc] init];
        input.pixelBuffer = videoPixelBuffer;
        input.renderConfig.imageOrientation = FUImageOrientationUP;
        switch (self.videoProcessor.reader.videoOrientation) {
            case FUVideoOrientationPortrait:
                input.renderConfig.imageOrientation = FUImageOrientationUP;
                break;
            case FUVideoOrientationLandscapeRight:
                input.renderConfig.imageOrientation = FUImageOrientationLeft;
                break;
            case FUVideoOrientationUpsideDown:
                input.renderConfig.imageOrientation = FUImageOrientationDown;
                break;
            case FUVideoOrientationLandscapeLeft:
                input.renderConfig.imageOrientation = FUImageOrientationRight;
                break;
        }
        FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
        videoPixelBuffer = output.pixelBuffer;
    }
    return videoPixelBuffer;
}

#pragma mark - FUVideoReaderDelegate

- (void)videoReaderDidOutputVideoSampleBuffer:(CMSampleBufferRef)videoSampleBuffer {
    CVPixelBufferRef videoBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer);
    [self renderVideoPixelBuffer:videoBuffer];
    CMSampleBufferInvalidate(videoSampleBuffer);
    CFRelease(videoSampleBuffer);
}

- (void)videoReaderDidFinishReading {
    [self stopReading];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoRenderDidFinishReading)]) {
        [self.delegate videoRenderDidFinishReading];
    }
    // 获取最后视频帧，需要循环render预览
    UIImage *lastImage = [FUUtility lastFrameImageFromVideoURL:self.videoURL preferredTrackTransform:NO];
    previewBuffer = [FUImageHelper pixelBufferFromImage:lastImage];
    if (!self.isDestroyed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startPreviewing];
        });
    }
}

#pragma mark - Getters

- (FUVideoReader *)videoReader {
    if (!_videoReader) {
        FUVideoReaderSettings *settings = [[FUVideoReaderSettings alloc] init];
        settings.readingAutomatically = YES;
        settings.videoOutputFormat = kCVPixelFormatType_32BGRA;
        _videoReader = [[FUVideoReader alloc] initWithURL:self.videoURL settings:settings];
        _videoReader.delegate = self;
    }
    return _videoReader;
}

- (AVPlayer *)audioReader {
    if (!_audioReader) {
        _audioReader = [AVPlayer playerWithURL:self.videoURL];
        _audioReader.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }
    return _audioReader;
}

- (BOOL)isReading {
    if (_videoReader) {
        return self.videoReader.isReading;
    }
    return NO;
}

- (BOOL)isProcessing {
    if (_videoProcessor) {
        return self.videoProcessor.reader.isReading || self.videoProcessor.writer.isWriting;
    }
    return NO;
}

- (FUVideoOrientation)videoOrientation {
    return self.videoReader.videoOrientation;
}

#pragma mark - Overriding

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace;
}

- (CGFloat)downloadButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(10);
}

@end
