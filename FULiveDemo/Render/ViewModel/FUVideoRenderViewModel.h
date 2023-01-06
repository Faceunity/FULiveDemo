//
//  FUVideoRenderViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kFUFinalPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"finalVideo.mp4"]

@protocol FUVideoRenderViewModelDelegate <NSObject>

- (void)videoRenderDidOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer;
// 单解码完成回调（视频播放）
- (void)videoRenderDidFinishReading;

- (void)videoRenderDidFinishProcessing;

@optional
// 解码编码程序进度回调
- (void)videoRenderProcessingProgress:(CGFloat)progress;

- (void)videoRenderShouldCheckDetectingStatus:(FUDetectingParts)parts;

@end

@interface FUVideoRenderViewModel : NSObject

/// 是否渲染，默认为YES
@property (nonatomic, assign, getter=isRendering) BOOL rendering;
/// 需要跟踪的部位，默认为FUDetectingPartsFace
@property (nonatomic, assign) FUDetectingParts detectingParts;

/// 是否正在播放视频
@property (nonatomic, assign, readonly) BOOL isReading;
/// 是否正在循环预览
@property (nonatomic, assign, readonly) BOOL isPreviewing;
/// 是否正在运行解码编码程序 (保存视频)
@property (nonatomic, assign, readonly) BOOL isProcessing;
/// 需要加载的AI模型，默认为FUAIModelTypeFace
@property (nonatomic, assign, readonly) FUAIModelType necessaryAIModelTypes;
/// 视频方向，默认为FUVideoOrientationPortrait
/// @discussion 开始视频解码后自动获取解码器的视频方向
@property (nonatomic, assign, readonly) FUVideoOrientation videoOrientation;

@property (nonatomic, strong, readonly) NSURL *videoURL;
/// 保存按钮到屏幕底部距离
@property (nonatomic, assign, readonly) CGFloat downloadButtonBottomConstant;

@property (nonatomic, weak) id<FUVideoRenderViewModelDelegate> delegate;

- (instancetype)initWithVideoURL:(NSURL *)videoURL;

// 开始视频首帧预览
- (void)startPreviewing;

// 停止预览
- (void)stopPreviewing;

/// 开始解码
- (void)startReading;

/// 停止解码
- (void)stopReading;

/// 开始解码编码程序
- (void)startProcessing;

/// 停止解码编码程序
- (void)stopProcessing;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
