//
//  FURenderViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/15.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FURenderViewModelDelegate <NSObject>

@optional
- (void)renderWillInputPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)renderDidOutputDebugInformations:(NSString *)informations;
/// 跟踪状态
- (void)renderShouldCheckDetectingStatus:(FUDetectingParts)parts;

@end

@interface FURenderViewModel : NSObject

/// 是否渲染，默认为YES
@property (nonatomic, assign, getter=isRendering) BOOL rendering;
/// 最大支持人脸数量，默认为4
@property (nonatomic, assign) NSInteger maxFaceNumber;
/// 最大支持人体数量，默认为4
@property (nonatomic, assign) NSInteger maxHumanNumber;
/// 需要跟踪的部位，默认为FUDetectingPartsFace
@property (nonatomic, assign) FUDetectingParts detectingParts;

/// 模块
@property (nonatomic, assign, readonly) FUModule module;
/// 需要加载的AI模型，默认为FUAIModelTypeFace
@property (nonatomic, assign, readonly) FUAIModelType necessaryAIModelTypes;
/// 是否自动加载AI模型，默认为YES
@property (nonatomic, assign, readonly) BOOL loadAIModelAutomatically;
/// 是否支持拍照和视频录制，默认YES
@property (nonatomic, assign, readonly) BOOL supportCaptureAndRecording;
/// 是否支持图片或者视频渲染，默认为NO
@property (nonatomic, assign, readonly) BOOL supportMediaRendering;
/// 是否支持分辨率选择，默认为NO
@property (nonatomic, assign, readonly) BOOL supportPresetSelection;
/// 是否支持切换相机输出格式，默认为YES
@property (nonatomic, assign, readonly) BOOL supportSwitchingOutputFormat;
/// 相机分辨率
@property (nonatomic, copy, readonly) AVCaptureSessionPreset capturePreset;
/// 相机前后置摄像头
@property (nonatomic, assign, readonly) AVCaptureDevicePosition captureDevicePostion;
/// 支持的分辨率
@property (nonatomic, copy, readonly) NSArray<AVCaptureSessionPreset> *presets;
/// 显示的分辨率数组
@property (nonatomic, copy, readonly) NSArray<NSString *> *presetTitles;
/// 是否支持10秒视频录制，默认为YES
@property (nonatomic, assign, readonly) BOOL supportVideoRecording;
/// 是否需要加载美颜，默认为YES
@property (nonatomic, assign, readonly) BOOL needsLoadingBeauty;
/// 人脸是否完整（临时处理海报换脸问题）
@property (nonatomic, assign, readonly) BOOL trackedCompleteFace;
/// 输入buffer宽度
@property (nonatomic, assign, readonly) CGFloat inputBufferWidth;
/// 输入buffer高度
@property (nonatomic, assign, readonly) CGFloat inputBufferHeight;
/// 拍照和录制视频按钮到屏幕底部距离
@property (nonatomic, assign, readonly) CGFloat captureButtonBottomConstant;

@property (nonatomic, weak) id<FURenderViewModelDelegate> delegate;

/// 开始相机采集渲染
/// @param renderView GLView
- (void)startCameraWithRenderView:(FUGLDisplayView *)renderView;

/// 停止相机
- (void)stopCamera;

/// 切换相机输出格式
- (void)switchCameraOutputFormat;

/// 切换相机分辨率
/// @param preset 分辨率
/// @param handler 硬件不支持分辨率回调
- (void)switchCapturePreset:(AVCaptureSessionPreset)preset unsupportedPresetHandler:(nullable void (^)(void))handler;

/// 切换相机前后置摄像头
/// @param front 是否前置
/// @param handler 硬件不支持当前分辨率回调
- (void)switchCameraBetweenFrontAndRear:(BOOL)front unsupportedPresetHandler:(nullable void (^)(void))handler;

/// 切换相机对焦模式
/// @param mode 对焦模式
- (void)switchCameraFocusMode:(FUCaptureCameraFocusMode)mode;

/// 相机对焦
/// @param point 对焦点
- (void)setCameraFocusPoint:(CGPoint)point;

/// 设置相机曝光度
/// @param value 曝光度
- (void)setCameraExposureValue:(CGFloat)value;

/// 恢复相机对焦和曝光模式
- (void)resetCameraFocusAndExposureMode;

/// 相机恢复默认设置
- (void)resetCameraSettings;

@end

NS_ASSUME_NONNULL_END
