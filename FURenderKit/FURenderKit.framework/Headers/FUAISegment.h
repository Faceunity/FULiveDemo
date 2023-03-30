//
//  FUAISegmentItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/28.
//

#import "FUSticker.h"
#import "FUStruct.h"
#import "UIImage+FURenderKit.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 人像分割道具
 */
@interface FUAISegment : FUSticker

/// 摄像机切换前后需要设置
@property (nonatomic, assign) int cameraMode;

/// 轮廓分割线和人体的间距
@property (nonatomic, assign) double lineGap;

/// 轮廓分割线宽度
@property (nonatomic, assign) double lineSize;

/// 轮廓分割线颜色
/// @note 忽略alpha
@property (nonatomic, assign) FUColor lineColor;

/// 自定义背景图片
@property (nonatomic, strong) UIImage *backgroundImage;

/// 自定义背景视频
/// @note NSURL or NSString，设置以后自动开始播放
@property (nonatomic, copy) id videoPath; // 背景视频

/// 背景视频是否播放
@property (nonatomic, assign) BOOL pause;

/// 开始背景视频播放
- (void)startVideoDecode;

/// 取消背景视频播放
- (void)stopVideoDecode;

@end

NS_ASSUME_NONNULL_END
