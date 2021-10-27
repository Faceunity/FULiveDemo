//
//  FUMakeup.h
//  FURenderKit
//
//  Created by Chen on 2021/1/6.
//

#import "FUItem.h"
#import <Foundation/Foundation.h>
#import <FURenderKit/FUStruct.h>
#import "FUMakeupValueDefine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 美妆
 */
@interface FUMakeup : FUItem
@property (nonatomic, assign) BOOL isMakeupOn; //美妆开关
@property (nonatomic, assign) BOOL isClearMakeup;//在解绑妆容时是否清空除口红以外的妆容，0表示不清空，1表示清空，口红可由强度进行设置
@property (nonatomic, assign) FUMakeupLipType lipType;//口红类型  0雾面 2润泽Ⅰ 3珠光 6高性能（不支持双色）7润泽Ⅱ
@property (nonatomic, assign) BOOL isLipHighlightOn;//是否开启口红高光，1为开 0为关
@property (nonatomic, assign) BOOL isTwoColor;//口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0
@property (nonatomic, assign) FUMakeupBrowWarpType browWarpType;//眉毛变形类型 0柳叶眉  1一字眉  2远山眉 3标准眉 4扶形眉  5日常风 6日系风
@property (nonatomic, assign) BOOL browWarp;//是否使用眉毛变形 ，1为开 0为关

@end

#pragma mark - 主题妆
/**
 * 主题妆
 */
@interface FUMakeup (Subject)

/**
 * 更新组合装时是否清除子妆
 * needCleanSubItem： YES 清除，NO 不清除
 */
- (void)updateMakeupPackage:(FUItem * __nullable)makeupPackage needCleanSubItem:(BOOL)needCleanSubItem;

//修改整体妆容程度值
@property (nonatomic, assign) double intensity;

//修改整体妆容滤镜程度值
@property (nonatomic, assign) double filterIntensity;

////组合装对象，内部包含当前组合装所有部位子妆
//@property (nonatomic, strong, nullable) FUItem *makeupPackage;

//局部妆容对象，属于组合装内部的具体部位（眉毛、眼镜、鼻子等）自定义设置
@property (nonatomic, strong, nullable) FUItem *subEyebrow;
@property (nonatomic, strong, nullable) FUItem *subEyeshadow;
@property (nonatomic, strong, nullable) FUItem *subPupil;
@property (nonatomic, strong, nullable) FUItem *subEyelash;
@property (nonatomic, strong, nullable) FUItem *subEyeliner;
@property (nonatomic, strong, nullable) FUItem *subBlusher;
@property (nonatomic, strong, nullable) FUItem *subFoundation;
@property (nonatomic, strong, nullable) FUItem *subHighlight;
@property (nonatomic, strong, nullable) FUItem *subShadow;
@property (nonatomic, strong, nullable) FUItem *subLip;
@end

#pragma mark - 图层混合模式
@interface FUMakeup (blend)
@property (nonatomic, assign) FUMakeupBlendType blendTypeEyeshadow1;
@property (nonatomic, assign) FUMakeupBlendType blendTypeEyeshadow2;
@property (nonatomic, assign) FUMakeupBlendType blendTypeEyeshadow3;
@property (nonatomic, assign) FUMakeupBlendType blendTypeEyeshadow4;
@property (nonatomic, assign) FUMakeupBlendType blendTypeEyelash;
@property (nonatomic, assign) FUMakeupBlendType blendTypeEyeliner;
@property (nonatomic, assign) FUMakeupBlendType blendTypeBlusher1;
@property (nonatomic, assign) FUMakeupBlendType blendTypeBlusher2;
@property (nonatomic, assign) FUMakeupBlendType blendTypePupil;
@end

#pragma mark - 子妆
@interface FUMakeup (intensity)

@property (nonatomic, assign) double intensityFoundation;//粉底
@property (nonatomic, assign) double intensityLip;//口红
@property (nonatomic, assign) double intensityLipHighlight;//口红高光（暂时只用于lipType=FUMakeupLipTypeMoisturizing的情况）
@property (nonatomic, assign) double intensityBlusher;//腮红
@property (nonatomic, assign) double intensityEyebrow;//眉毛
@property (nonatomic, assign) double intensityEyeshadow;//眼影
@property (nonatomic, assign) double intensityEyeliner;//眼线
@property (nonatomic, assign) double intensityEyelash;//睫毛
@property (nonatomic, assign) double intensityHighlight;//高光
@property (nonatomic, assign) double intensityShadow;//阴影
@property (nonatomic, assign) double intensityPupil;//美瞳
@end


@interface FUMakeup (Color)
@property (nonatomic, assign) FUColor foundationColor;//粉底
@property (nonatomic, assign) FUColor lipColor;//口红颜色
@property (nonatomic, assign) FUColor lipColor2;//口红2
@property (nonatomic, assign) FUColor lipColorV2;//口红颜色v2（暂时只用于lipType=FUMakeupLipTypeMoisturizing的情况）
@property (nonatomic, assign) FUColor blusherColor;//腮红
@property (nonatomic, assign) FUColor eyebrowColor;//眉毛
@property (nonatomic, assign) FUColor eyelinerColor;//眼线
@property (nonatomic, assign) FUColor eyelashColor;//睫毛
@property (nonatomic, assign) FUColor highlightColor;//高光
@property (nonatomic, assign) FUColor shadowColor;//阴影
@property (nonatomic, assign) FUColor pupilColor;//美瞳

/**
 * 眼影特殊处理
 * //如果is_two_color为1，会启用这个颜色，外圈颜色为makeup_lip_color2，内圈颜色为makeup_lip_color，如果makeup_lip_color2都为0，则外圈为透明，即为咬唇效果
 * makeup_eye_color:[0.0,0.0,0.0,0.0],//第一层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
 * makeup_eye_color2:[0.0,0.0,0.0,0.0],//第二层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
 * makeup_eye_color3:[0.0,0.0,0.0,0.0],//第三层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
 * makeup_eye_color4:[0.0,0.0,0.0,0.0],//第四层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
 */
- (void)setEyeColor:(FUColor)color
             color1:(FUColor)color1
             color2:(FUColor)color2
             color3:(FUColor)color3;
@end

@interface FUMakeup (landMark)
@property (nonatomic, assign) int isUserFix; //这个参数控制是否使用修改过得landmark点，如果设为1为使用，0为不使用
@property (nonatomic, assign) FULandMark fixMakeUpData;//这个参数为一个数组，需要客户端传递一个数组进去，传递的数组的长度为 150*人脸数，也就是将所有的点位信息存储的数组中传递进来。
@end
NS_ASSUME_NONNULL_END

