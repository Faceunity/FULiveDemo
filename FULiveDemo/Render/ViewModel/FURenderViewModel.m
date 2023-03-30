//
//  FURenderViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/15.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FURenderViewModel.h"

@interface FURenderViewModel ()<FURenderKitDelegate, FUCaptureCameraDataSource>

/// 缓存渲染线程的人脸中心点
@property (nonatomic, assign) CGPoint faceCenter;
@property (nonatomic, assign) BOOL trackedCompleteFace;
@property (nonatomic, assign) CGFloat inputBufferWidth;
@property (nonatomic, assign) CGFloat inputBufferHeight;

@end

@implementation FURenderViewModel {
    // 计算帧率相关变量
    CFAbsoluteTime startTime, lastCalculateTime;
    int rate;
    NSTimeInterval currentCalculateTime;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rendering = YES;
        self.maxFaceNumber = 4;
        self.maxHumanNumber = 4;
        self.detectingParts = FUDetectingPartsFace;
        
        [FURenderKit shareRenderKit].delegate = self;
        [FURenderKit shareRenderKit].captureCamera.dataSource = self;
        
        if ((self.necessaryAIModelTypes & FUAIModelTypeFace) && self.loadAIModelAutomatically) {
            // 加载人脸AI模型
            [FURenderKitManager loadFaceAIModel];
        }
        if ((self.necessaryAIModelTypes & FUAIModelTypeHuman) && self.loadAIModelAutomatically) {
            // 加载人体AI模型
            [FURenderKitManager loadHumanAIModel:FUHumanSegmentationModeCPUCommon];
        }
        if ((self.necessaryAIModelTypes & FUAIModelTypeHand) && self.loadAIModelAutomatically) {
            // 加载手势AI模型
            [FURenderKitManager loadHandAIModel];
            // 设置未跟踪到手势时每次检测的间隔帧数为3
            [FUAIKit setHandDetectEveryFramesWhenNoHand:3];
        }
        // 设置设备性能相关细项
        [[FURenderKitManager sharedManager] setDevicePerformanceDetails];
    }
    return self;
}

#pragma mark - Instance methods

- (void)startCameraWithRenderView:(FUGLDisplayView *)renderView {
    // 需要音频轨道
    [FURenderKit shareRenderKit].internalCameraSetting.needsAudioTrack = YES;
    [[FURenderKit shareRenderKit] startInternalCamera];
    [FURenderKit shareRenderKit].glDisplayView = renderView;
}

- (void)stopCamera {
    [[FURenderKit shareRenderKit] stopInternalCamera];
    [FURenderKit shareRenderKit].glDisplayView = nil;
}

- (void)switchCameraOutputFormat {
    OSType format = [FURenderKit shareRenderKit].internalCameraSetting.format == kCVPixelFormatType_32BGRA ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange : kCVPixelFormatType_32BGRA;
    [FURenderKit shareRenderKit].internalCameraSetting.format = format;
}

- (void)switchCapturePreset:(AVCaptureSessionPreset)preset unsupportedPresetHandler:(void (^)(void))handler {
    if (![FURenderKit shareRenderKit].captureCamera) {
        return;
    }
    FUCaptureCamera *camera = [FURenderKit shareRenderKit].captureCamera;
    if ([camera changeSessionPreset:preset]) {
        [FURenderKit shareRenderKit].internalCameraSetting.sessionPreset = preset;
    } else {
        // 硬件不支持该分辨率
        if (handler) {
            handler();
        }
    }
}

- (void)switchCameraBetweenFrontAndRear:(BOOL)front unsupportedPresetHandler:(void (^)(void))handler {
    if (![FURenderKit shareRenderKit].captureCamera) {
        return;
    }
    FUCaptureCamera *camera = [FURenderKit shareRenderKit].captureCamera;
    if (![camera supportsAVCaptureSessionPreset:front]) {
        // 硬件不支持分辨率
        if (handler) {
            handler();
        }
    } else {
        [FURenderKit shareRenderKit].internalCameraSetting.position = front ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    }
}

- (void)switchCameraFocusMode:(FUCaptureCameraFocusMode)mode {
    if (![FURenderKit shareRenderKit].captureCamera) {
        return;
    }
    [[FURenderKit shareRenderKit].captureCamera cameraChangeMode:mode];
}

- (void)setCameraFocusPoint:(CGPoint)point {
    if (![FURenderKit shareRenderKit].captureCamera) {
        return;
    }
    [[FURenderKit shareRenderKit].captureCamera focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:point monitorSubjectAreaChange:YES];
}

- (void)setCameraExposureValue:(CGFloat)value {
    if (![FURenderKit shareRenderKit].captureCamera) {
        return;
    }
    [[FURenderKit shareRenderKit].captureCamera setExposureValue:value];
}

- (void)resetCameraFocusAndExposureMode {
    if (![FURenderKit shareRenderKit].captureCamera) {
        return;
    }
    [[FURenderKit shareRenderKit].captureCamera resetFocusAndExposureModes];
}

- (void)resetCameraSettings {
    [FURenderKit shareRenderKit].internalCameraSetting.sessionPreset = AVCaptureSessionPreset1280x720;
    [FURenderKit shareRenderKit].internalCameraSetting.position = AVCaptureDevicePositionFront;
    [FURenderKit shareRenderKit].internalCameraSetting.format = kCVPixelFormatType_32BGRA;
}

#pragma mark - Private methods

- (void)updateFaceCenterPoint {
    CGPoint center = CGPointMake(0.5, 0.5);
    if ([FURenderKitManager faceTracked] && [FURenderKit shareRenderKit].captureCamera) {
        center = [self trackedFaceCenter];
        if ([FURenderKit shareRenderKit].captureCamera.isFrontCamera) {
            center = CGPointMake(center.y, center.x);
        } else {
            center = CGPointMake(center.y, 1 - center.x);
        }
    }
    self.faceCenter = center;
}

- (CGPoint)trackedFaceCenter {
    // 获取人脸信息
    float rect[4];
    [FUAIKit getFaceInfo:0 name:@"face_rect" pret:rect number:4];
    CGFloat minX = rect[0];
    CGFloat minY = rect[1];
    CGFloat maxX = rect[2];
    CGFloat maxY = rect[3];
    // 判断人脸是否完整
    if (minX < 0 || minY < 0 || maxX > self.inputBufferWidth || maxY > self.inputBufferHeight) {
        self.trackedCompleteFace = NO;
    } else {
        self.trackedCompleteFace = YES;
    }
    // 计算中心点的坐标
    CGFloat centerX = (minX + maxX) * 0.5;
    CGFloat centerY = (minY + maxY) * 0.5;
    // 转换坐标
    centerX = centerX / self.inputBufferWidth;
    centerY = centerY / self.inputBufferHeight;
    return CGPointMake(centerX, centerY);
}

#pragma mark - FURenderKitDelegate

- (BOOL)renderKitShouldDoRender {
    return self.rendering;
}

- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput {
    if (renderInput.pixelBuffer != NULL) {
        CVPixelBufferLockBaseAddress(renderInput.pixelBuffer, 0);
        self.inputBufferWidth = CVPixelBufferGetWidth(renderInput.pixelBuffer);
        self.inputBufferHeight = CVPixelBufferGetHeight(renderInput.pixelBuffer);
        CVPixelBufferUnlockBaseAddress(renderInput.pixelBuffer, 0);
    }
    [FURenderKitManager updateBeautyBlurEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(renderWillInputPixelBuffer:)]) {
        [self.delegate renderWillInputPixelBuffer:renderInput.pixelBuffer];
    }
    startTime = CFAbsoluteTimeGetCurrent();
}

- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput {
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    // 加一帧占用时间
    currentCalculateTime += (endTime - startTime);
    // 加帧数
    rate += 1;
    if (endTime - lastCalculateTime >= 1) {
        // 一秒钟计算一次
        int width = (int)CVPixelBufferGetWidth(renderOutput.pixelBuffer);
        int height = (int)CVPixelBufferGetHeight(renderOutput.pixelBuffer);
        NSString *debugString = [NSString stringWithFormat:@"resolution:\n%dx%d\nfps: %d\nrender time:\n%.0fms", width, height, rate, currentCalculateTime * 1000 / rate];
        if (self.delegate && [self.delegate respondsToSelector:@selector(renderDidOutputDebugInformations:)]) {
            [self.delegate renderDidOutputDebugInformations:debugString];
        }
        // 恢复计算数据
        lastCalculateTime = endTime;
        currentCalculateTime = 0;
        rate = 0;
    }
    
    // 更新人脸中心点
    [self updateFaceCenterPoint];
    
    if (self.detectingParts != FUDetectingPartsNone) {
        // 需要检查人脸/人体/手势检测状态
        if (self.delegate && [self.delegate respondsToSelector:@selector(renderShouldCheckDetectingStatus:)]) {
            [self.delegate renderShouldCheckDetectingStatus:self.detectingParts];
        }
    }
}

#pragma mark - FUCaptureCameraDataSource

- (CGPoint)fuCaptureFaceCenterInImage:(FUCaptureCamera *)camera {
    return self.faceCenter;
}

#pragma mark - Setters

- (void)setMaxFaceNumber:(NSInteger)maxFaceNumber {
    if (_maxFaceNumber == maxFaceNumber) {
        return;
    }
    _maxFaceNumber = maxFaceNumber;
    [FURenderKitManager setMaxFaceNumber:maxFaceNumber];
}

- (void)setMaxHumanNumber:(NSInteger)maxHumanNumber {
    if (_maxHumanNumber == maxHumanNumber) {
        return;
    }
    _maxHumanNumber = maxHumanNumber;
    [FURenderKitManager setMaxHumanNumber:maxHumanNumber];
}

#pragma mark - Overriding attributes

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace;
}

- (BOOL)loadAIModelAutomatically {
    return YES;
}

- (BOOL)supportCaptureAndRecording {
    return YES;
}

- (BOOL)supportMediaRendering {
    return NO;
}

- (BOOL)supportPresetSelection {
    return NO;
}

- (BOOL)supportSwitchingOutputFormat {
    return YES;
}

- (BOOL)supportVideoRecording {
    return YES;
}

- (NSArray<AVCaptureSessionPreset> *)presets {
    return @[AVCaptureSessionPreset640x480, AVCaptureSessionPreset1280x720, AVCaptureSessionPreset1920x1080];
}

- (NSArray<NSString *> *)presetTitles {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (AVCaptureSessionPreset preset in self.presets) {
        if (preset == AVCaptureSessionPreset640x480) {
            [titles addObject:@"480x640"];
        } else if (preset == AVCaptureSessionPreset1280x720) {
            [titles addObject:@"720x1280"];
        } else if (preset == AVCaptureSessionPreset1920x1080) {
            [titles addObject:@"1080x1920"];
        }
    }
    return [titles copy];
}

- (BOOL)needsLoadingBeauty {
    return YES;
}

- (CGFloat)captureButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(10);
}

#pragma mark - Getters

- (AVCaptureSessionPreset)capturePreset {
    return [FURenderKit shareRenderKit].internalCameraSetting.sessionPreset;
}

- (AVCaptureDevicePosition)captureDevicePostion {
    return [FURenderKit shareRenderKit].internalCameraSetting.position;
}

@end
