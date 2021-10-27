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

@property (nonatomic, strong) UIImage *backgroundImage; // 背景图片

@property (nonatomic, strong, nullable) UIImage *safeAreaImage; // 安全区域图片

@property (nonatomic, copy) NSString *videoPath; // 背景视频

/**
 * 根据传入的图进和点位进行取色，获取到的颜色需要生效直接设置 self.keyColor
 */
+ (UIColor *)pixelColorWithImage:(UIImage *)originImage point:(CGPoint)point;

/**
 * 根据传入的CVPixelBufferRef和点位进行取色
 */
+ (UIColor *)pixelColorWithPixelBuffer:(CVPixelBufferRef)buffer point:(CGPoint)point;

/**
 * 开始视频播放
 */
- (void)startVideoDecode;

/**
 * 取消视频播放
 */
- (void)stopVideoDecode;


///**
//  * 滑动手势的在View上的点
// */
//- (void)handlePanGestureRecognizer:(CGPoint)point;
//
//
///**
// * 捏合手势的scale, 内部处理之后外面调用层需要把捏合手势对象的scale设置1
// */
//- (void)handlePinchGesture:(CGFloat)scale;

@property (nonatomic, assign) FUColor keyColor; //默认值为[0,255,0],取值范围[0-255,0-255,0-255],选取的颜色RGB,默认绿色可根据实际颜色进行调整
@property (nonatomic, assign) double chromaThres; //默认值为0.518,取值范围0.0-1.0，相似度：色度最大容差，色度最大容差值越大，更多幕景被抠除
@property (nonatomic, assign) double chromaThrest; //默认值为0.22,取值范围0.0-1.0，平滑：色度最小限差，值越大，更多幕景被扣除
@property (nonatomic, assign) double alphal; //默认值为0.0,取值范围0.0-1.0，透明度：图像前后景透明度过度，值越大，两者边缘处透明过度更平滑

@property (nonatomic, assign) CGPoint center; //包含start_x和start_y
@property (nonatomic, assign) float scale;

@property (nonatomic, assign) int isBgra; //internal

//@property (nonatomic, strong) UIImage *bgImage;

/**
 * 当前是否正在进行抠图,抠图就停止绿慕渲染
 */
@property (nonatomic, assign) BOOL cutouting;


@property (nonatomic, assign) BOOL pause;
@end


NS_ASSUME_NONNULL_END
