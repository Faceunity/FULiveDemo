//
//  FURenderMediaViewController.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/12/7.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FUBaseViewControllerManager.h"

typedef NS_ENUM(NSUInteger, FURenderMediaType) {
    FURenderMediaTypeImage,
    FURenderMediaTypeVideo
};

typedef NS_ENUM(NSUInteger, FUTrackType) {
    FUTrackTypeFace,
    FUTrackTypeBody
};

NS_ASSUME_NONNULL_BEGIN

@protocol FURenderMediaProtocol <NSObject>

/// 是否需要检测
@property (nonatomic, assign, getter=isNeedTrack) BOOL needTrack;

@optional

/// 是否停止渲染流程（出原图）
@property (nonatomic, assign) BOOL stopRendering;

/// 检测类型（人脸/人体）
@property (nonatomic, assign) FUTrackType trackType;

/// 输出单帧视频数据
- (void)renderMediaDidOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/// 输出图片数据
- (void)renderMediaDidOutputImage:(UIImage *)image;

@end

@interface FURenderMediaViewController : UIViewController<FURenderMediaProtocol>

@property (nonatomic, strong, readonly) FUGLDisplayView *displayView;

@property (nonatomic, assign, readonly) FURenderMediaType mediaType;

@property (nonatomic, strong, readonly) FUBaseViewControllerManager *baseManager;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithImage:(UIImage *)image;

- (instancetype)initWithVideoURL:(NSURL *)videoURL;

- (void)refreshDownloadButtonTransformWithHeight:(CGFloat)height show:(BOOL)shown;

- (void)bringFunctionButtonToFront;

@end

NS_ASSUME_NONNULL_END
