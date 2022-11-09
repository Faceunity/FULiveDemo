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

- (void)videoRenderDidFinishProcessing;
@optional
- (void)videoRenderShouldCheckDetectingStatus:(FUDetectingParts)parts;

@end

@interface FUVideoRenderViewModel : NSObject

/// 是否渲染，默认为YES
@property (nonatomic, assign, getter=isRendering) BOOL rendering;
/// 需要跟踪的部位，默认为FUDetectingPartsFace
@property (nonatomic, assign) FUDetectingParts detectingParts;

/// 需要加载的AI模型，默认为FUAIModelTypeFace
@property (nonatomic, assign, readonly) FUAIModelType necessaryAIModelTypes;
/// 视频方向，默认为FUVideoOrientationPortrait
/// @discussion 开始视频解码后自动获取解码器的视频方向
@property (nonatomic, assign, readonly) FUVideoOrientation videoOrientation;

@property (nonatomic, weak) id<FUVideoRenderViewModelDelegate> delegate;

- (instancetype)initWithVideoURL:(NSURL *)videoURL;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
