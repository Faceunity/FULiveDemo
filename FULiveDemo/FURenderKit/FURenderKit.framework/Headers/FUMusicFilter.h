//
//  FUMusicFilter.h
//  FURenderKit
//
//  Created by Chen on 2021/1/28.
//

#import "FUSticker.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 音乐滤镜
 */
@interface FUMusicFilter : FUSticker
/**
 * 设置音乐文件路径，但不播放，等到乐滤镜在底层库渲染时自动播放音乐
 * 同步音乐和渲染效果
 */
@property (nonatomic, strong) NSString *musicPath;
/**
 * 播放当前已经设置的音乐文件
 */
- (void)play;

/**
 * 继续播放
 */
- (void)resume;
/**
 * 停止播放
 */
- (void)stop;
/**
 * 暂停
 */
- (void)pause;
/**
 * 获取播放进度
 */
- (float)playProgress;
/**
 * 获取当前媒体播放时间
 */
- (NSTimeInterval)currentTime;
@end

NS_ASSUME_NONNULL_END
