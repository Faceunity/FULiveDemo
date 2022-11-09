//
//  FUVideoRenderViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/9.
//

#import "FUVideoRenderViewModel.h"

@interface FUVideoRenderViewModel ()

@property (nonatomic, assign) FUVideoOrientation videoOrientation;

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) FUVideoProcessor *videoProcessor;

@property (nonatomic, strong) AVPlayer *audioReader;

@property (nonatomic, assign) BOOL isPreviewing;

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

- (void)start {
    [self stopPreviewing];
    if (self.videoProcessor) {
        [self.videoProcessor cancelProcessing];
        self.videoProcessor = nil;
    }
    self.videoProcessor = [[FUVideoProcessor alloc] initWithReadingURL:self.videoURL  writingURL:[NSURL fileURLWithPath:kFUFinalPath]];
    @FUWeakify(self)
    self.videoProcessor.processingVideoBufferHandler = ^CVPixelBufferRef _Nonnull(CVPixelBufferRef  _Nonnull videoPixelBuffer, CGFloat time) {
        @FUStrongify(self)
        videoPixelBuffer = [self renderVideoPixelBuffer:videoPixelBuffer];
        return videoPixelBuffer;
    };
    
    self.videoProcessor.processingFinishedHandler = ^{
        @FUStrongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRenderDidFinishProcessing)]) {
            [self.delegate videoRenderDidFinishProcessing];
        }
        [self startPreviewing];
    };
    
    [self.videoProcessor startProcessing];
    self.videoOrientation = self.videoProcessor.reader.videoOrientation;
    
    // 播放音频
    self.audioReader = [AVPlayer playerWithURL:self.videoURL];
    self.audioReader.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [self.audioReader play];
}

- (void)stop {
    if (self.isPreviewing) {
        self.isPreviewing = NO;
    }
    [self.videoProcessor cancelProcessing];
    self.videoProcessor = nil;
    [self.audioReader pause];
    self.audioReader = nil;
}

#pragma mark - Private methods

- (void)startPreviewing {
    // 获取最后视频帧，需要循环render预览
    self.isPreviewing = YES;
    UIImage *lastImage = [FUUtility lastFrameImageFromVideoURL:self.videoURL preferredTrackTransform:NO];
    previewBuffer = [FUImageHelper pixelBufferFromImage:lastImage];
    [self.previewQueue addOperationWithBlock:^{
        while (self.isPreviewing && self->previewBuffer != NULL) {
            CVPixelBufferRetain(self->previewBuffer);
            [self renderVideoPixelBuffer:self->previewBuffer];
            CVPixelBufferRelease(self->previewBuffer);
            // 设置render时间间隔
            usleep(1000000*0.033);
        }
    }];
}

- (void)stopPreviewing {
    if (self.isPreviewing) {
        self.isPreviewing = NO;
        [self.previewQueue cancelAllOperations];
    }
    if (previewBuffer != NULL) {
        CVPixelBufferRelease(previewBuffer);
        previewBuffer = NULL;
    }
}

- (CVPixelBufferRef)renderVideoPixelBuffer:(CVPixelBufferRef)videoPixelBuffer {
    @autoreleasepool {
        if (self.isRendering) {
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
    return videoPixelBuffer;
}


#pragma mark - Overriding

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace;
}

@end
