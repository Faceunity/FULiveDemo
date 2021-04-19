//
//  FUAISegmentItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/28.
//

#import <FURenderKit/FURenderKit.h>
NS_ASSUME_NONNULL_BEGIN
/**
 * 人像分割道具
 */
@interface FUAISegment : FUSticker
//摄像机切换前后需要设置
@property (nonatomic, assign) int cameraMode;

@property (nonatomic, assign) double lineGap;

@property (nonatomic, assign) double lineSize;

@property (nonatomic, assign) FUColor lineColor;
/**
 * 开始视频播放
 */
- (void)startVideoDecode;

/**
 * 取消视频播放
 */
- (void)stopVideoDecode;

//视频解析获取第一帧图片
- (UIImage *)readFirstFrame;

@property (nonatomic, strong) UIImage *backgroundImage; // 背景图片

//NSURL or NSString
@property (nonatomic, copy) id videoPath; // 背景视频

@property (nonatomic, assign) BOOL pause;
@end

NS_ASSUME_NONNULL_END
