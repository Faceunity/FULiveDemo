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

@implementation FUImageRenderViewModel {
    FUImageBuffer currentImageBuffer;
}

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
    if (&currentImageBuffer != NULL) {
        [UIImage freeImageBuffer:&currentImageBuffer];
    }
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
            self->currentImageBuffer = [self.renderImage getImageBuffer];
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
                input.imageBuffer = self->currentImageBuffer;
                FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
                self->currentImageBuffer = output.imageBuffer;
            }
            if (self.captureImageHandler) {
                UIImage *captureImage = [UIImage imageWithRGBAImageBuffer:&self->currentImageBuffer autoFreeBuffer:NO];
                self.captureImageHandler(captureImage);
                self.captureImageHandler = nil;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(imageRenderDidOutputImageBuffer:)]) {
                [self.delegate imageRenderDidOutputImageBuffer:self->currentImageBuffer];
            }
            // 释放内存
            [UIImage freeImageBuffer:&self->currentImageBuffer];
        }
        
        if (self.detectingParts != FUDetectingPartsNone) {
            // 需要检查人脸/人体/手势检测状态
            if (self.delegate && [self.delegate respondsToSelector:@selector(imageRenderShouldCheckDetectingStatus:)]) {
                [self.delegate imageRenderShouldCheckDetectingStatus:self.detectingParts];
            }
        }
    }];
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
