//
//  FUImageRenderViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUImageRenderViewModelDelegate <NSObject>

- (void)imageRenderDidOutputPixelBuffer:(CVPixelBufferRef)imageBuffer;

@optional
/// 跟踪状态
- (void)imageRenderShouldCheckDetectingStatus:(FUDetectingParts)parts;

@end

@interface FUImageRenderViewModel : NSObject

/// 是否渲染，默认为YES
@property (nonatomic, assign, getter=isRendering) BOOL rendering;
/// 需要跟踪的部位，默认为FUDetectingPartsFace
@property (nonatomic, assign) FUDetectingParts detectingParts;

/// 需要加载的AI模型，默认为FUAIModelTypeFace
@property (nonatomic, assign, readonly) FUAIModelType necessaryAIModelTypes;
/// 保存按钮到屏幕底部距离
@property (nonatomic, assign, readonly) CGFloat downloadButtonBottomConstant;

@property (nonatomic, weak) id<FUImageRenderViewModelDelegate> delegate;

@property (nonatomic, copy, nullable) void (^captureImageHandler)(UIImage *image);

- (instancetype)initWithImage:(UIImage *)image;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
