//
//  FUImageRenderViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/9.
//

#import "FUImageRenderViewModel.h"

@interface FUImageRenderViewModel ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSOperationQueue *renderOperationQueue;

@property (nonatomic, strong) UIImage *renderImage;

@end

@implementation FUImageRenderViewModel


#pragma mark - Initializer

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.rendering = YES;
        self.detectingParts = FUDetectingPartsFace;
        if (self.necessaryAIModelTypes & FUAIModelTypeFace) {
            [FURenderKitManager setFaceProcessorDetectMode:FUFaceProcessorDetectModeImage];
        }
        if (self.necessaryAIModelTypes & FUAIModelTypeHuman) {
            [FURenderKitManager setHumanProcessorDetectMode:FUHumanProcessorDetectModeVideo];
        }
        self.renderImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1)];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"FUImageRenderViewModel dealloc");
}

#pragma mark - Instance methods

- (void)start {
    [FURenderKitManager resetTrackedResult];
    if (!_displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.frameInterval = 10;
    }
    self.displayLink.paused = NO;
}

- (void)stop {
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self.renderOperationQueue cancelAllOperations];
}

#pragma mark - Event response

- (void)displayLinkAction {
    [self.renderOperationQueue addOperationWithBlock:^{
        [FURenderKitManager updateBeautyBlurEffect];
        @autoreleasepool {
            CVPixelBufferRef buffer = [FUImageHelper pixelBufferFromImage:self.renderImage];
            if (self.isRendering) {
                FURenderInput *input = [[FURenderInput alloc] init];
                switch (self.renderImage.imageOrientation) {
                    case UIImageOrientationUp:
                    case UIImageOrientationUpMirrored:
                        input.renderConfig.imageOrientation = FUImageOrientationUP;
                        break;
                    case UIImageOrientationLeft:
                    case UIImageOrientationLeftMirrored:
                        input.renderConfig.imageOrientation = FUImageOrientationRight;
                        break;
                    case UIImageOrientationDown:
                    case UIImageOrientationDownMirrored:
                        input.renderConfig.imageOrientation = FUImageOrientationDown;
                        break;
                    case UIImageOrientationRight:
                    case UIImageOrientationRightMirrored:
                        input.renderConfig.imageOrientation = FUImageOrientationLeft;
                        break;
                }
                input.pixelBuffer = buffer;
                FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
                [self processOutputResult:output.pixelBuffer];
            } else {
                // 原图
                [self processOutputResult:buffer];
            }
            CVPixelBufferRelease(buffer);
        }

        if (self.detectingParts != FUDetectingPartsNone) {
            // 需要检查人脸/人体/手势检测状态
            if (self.delegate && [self.delegate respondsToSelector:@selector(imageRenderShouldCheckDetectingStatus:)]) {
                [self.delegate imageRenderShouldCheckDetectingStatus:self.detectingParts];
            }
        }
    }];
}

- (void)processOutputResult:(CVPixelBufferRef)pixelBuffer {
    if (!pixelBuffer) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageRenderDidOutputPixelBuffer:)]) {
        [self.delegate imageRenderDidOutputPixelBuffer:pixelBuffer];
    }
    if (self.captureImageHandler) {
        // 保存图片
        UIImage *captureImage = [FUImageHelper imageFromPixelBuffer:pixelBuffer];
        self.captureImageHandler(captureImage);
        self.captureImageHandler = nil;
    }
}

#pragma mark - Getters

- (NSOperationQueue *)renderOperationQueue {
    if (!_renderOperationQueue) {
        _renderOperationQueue = [[NSOperationQueue alloc] init];
        _renderOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _renderOperationQueue;
}

#pragma mark - Overriding attributes

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace;
}

- (CGFloat)downloadButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(10);
}

@end
