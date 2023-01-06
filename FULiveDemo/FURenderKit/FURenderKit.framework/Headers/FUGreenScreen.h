//
//  FUGreenTent.h
//  FURenderKit
//
//  Created by Chen on 2021/1/15.
//

#import "FUItem.h"
#import "FUStruct.h"
NS_ASSUME_NONNULL_BEGIN
@interface FUGreenScreen : FUItem

/// 背景图片
@property (nonatomic, strong, nullable) UIImage *backgroundImage;

/// 背景视频URLString
/// @note 设置之后自动开始播放，若设置为nil，自动停止
@property (nonatomic, copy, nullable) NSString *videoPath;

/// 安全区域图片
@property (nonatomic, strong, nullable) UIImage *safeAreaImage;

/// 关键颜色
/// 默认值为[0,255,0]，取值范围[0-255,0-255,0-255]
/// @note 设置关键颜色后会自动改变相似度、平滑度和祛色度的值
@property (nonatomic, assign) FUColor keyColor;

/// 相似度：色度最大容差
/// 取值范围0.0-1.0，色度最大，容差值越大，更多幕景被抠除
/// @note 值跟随关键颜色变化
@property (nonatomic, assign) double chromaThres;

/// 平滑度：色度最小限差，
/// 取值范围0.0-1.0，值越大，更多幕景被扣除
/// @note 值跟随关键颜色变化
@property (nonatomic, assign) double chromaThrest;

/// 祛色度：图像前后景祛色度过度
/// 取值范围0.0-1.0，值越大，两者边缘处透明过度更平滑
/// @note 值跟随关键颜色变化
@property (nonatomic, assign) double alphal;

/// 中心点
@property (nonatomic, assign) CGPoint center;

/// 缩放比例
@property (nonatomic, assign) float scale;

/// 当前是否正在进行抠图，抠图就停止绿慕渲染
@property (nonatomic, assign) BOOL cutouting;

/// 背景视频播放是否暂停
@property (nonatomic, assign) BOOL pause;

/// 开始播放背景视频
- (void)startVideoDecode;

/// 取消播放背景视频
- (void)stopVideoDecode;

@end


NS_ASSUME_NONNULL_END
