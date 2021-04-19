//
//  FUPoster.h
//  FURenderKit
//
//  Created by Chen on 2021/1/8.
//

#import "FUItem.h"
#import <CoreGraphics/CGGeometry.h>
#import "FURenderIO.h"

@class FUPoster;

NS_ASSUME_NONNULL_BEGIN
@class UIImage, FUFaceRectInfo;

@protocol FUPosterProtocol <NSObject>

@optional
/**
 * 检测输入照片人脸结果异常调用， 用于处理异常提示 UI逻辑.
 * code: -1, 人脸异常（检测到人脸但是角度不对返回-1），0: 未检测到人脸
 */
- (void)poster:(FUPoster *)poster inputImageTrackErrorCode:(int)code;

/**
 * 检测海报模版背景图片人脸结果（异常调用）
 * code: -1, 人脸异常（检测到人脸但是角度不对返回-1） 0: 未检测到人脸
 */
- (void)poster:(FUPoster *)poster tempImageTrackErrorCode:(int)code;

/**
 * 输入照片检测到多张人脸回调此方法,用于UI层绘制多人脸 UI
 */
- (void)poster:(FUPoster *)poster trackedMultiFaceInfos:(NSArray <FUFaceRectInfo *> *)faceInfos;

/**
 *  inputImage 和 蒙板image 合成的结果回调
 *  data : 海报蒙板和照片合成之后的图片数据
 */

- (void)poster:(FUPoster *)poster didRenderToImage:(UIImage *)image;

/**
 * 设置模板弯曲度，需要外部传入
 * return double 对象
 */
- (NSNumber *)renderOfWarp;

@end

@interface FUPoster : FUItem
@property (nonatomic, weak) id<FUPosterProtocol>delegate;
/**
 * inputImage 需要替换包含人脸图片
 * templateImage 背景模板包含人脸的图片
 */
- (void)renderWithInputImage:(UIImage *)inputImage templateImage:(UIImage *)templateImage;

/**
 * 替换背景图片
 */
- (void)changeTempImage:(UIImage *)tempImage;

/**
 * 计算人脸区域
 */
+ (CGRect)cacluteRectWithIndex:(int)index height:(int)originHeight width:(int)orighnWidth;

/**
 * 选择某张具体的人脸，
 * faceId 通过 checkPosterWithFaceIds:rectsMap 获取
 */
- (void)chooseFaceID:(int)faceID;

@end
NS_ASSUME_NONNULL_END
