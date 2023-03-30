//
//  FUMakeup.h
//  FURenderKit
//
//  Created by Chen on 2021/1/6.
//

#import "FUItem.h"
#import <Foundation/Foundation.h>
#import "FUStruct.h"
#import "FUMakeupValueDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUMakeup : FUItem

/// 美妆开关，默认为YES
@property (nonatomic, assign) BOOL isMakeupOn;

/// 在解绑妆容时是否清空除口红以外的妆容，NO表示不清空，YES表示清空，口红可由强度进行设置
@property (nonatomic, assign) BOOL isClearMakeup;

/// 美妆分割，YES为开，NO为关，默认NO
/// @note 建议在高端机型中使用
@property (nonatomic, assign) BOOL makeupSegmentation;

/// 口红类型
/// @see FUMakeupLipType
@property (nonatomic, assign) FUMakeupLipType lipType;

/// 是否开启口红高光，YES为开，NO为关
@property (nonatomic, assign) BOOL isLipHighlightOn;

/// 口红双色开关，NO为关闭，YES为开启
/// @note 如果想使用咬唇，需要开启双色开关，并且将makeup_lip_color2的值都设置为0
@property (nonatomic, assign) BOOL isTwoColor;

/// 眉毛变形类型
/// @see FUMakeupBrowWarpType
/// @note 如果browWarp为NO，眉毛变形类型设置失效
@property (nonatomic, assign) FUMakeupBrowWarpType browWarpType;

/// 是否使用眉毛变形 YES为开 NO为关，默认为NO
@property (nonatomic, assign) BOOL browWarp;

@end

#pragma mark - 主题妆

@interface FUMakeup (Subject)

/// 更新组合装
/// @param makeupPackage 子妆
/// @param needCleanSubItem 是否清除老子妆
- (void)updateMakeupPackage:(FUItem * __nullable)makeupPackage needCleanSubItem:(BOOL)needCleanSubItem;

/// 整体妆容程度值
@property (nonatomic, assign) double intensity;

/// 整体妆容滤镜程度值
@property (nonatomic, assign) double filterIntensity;

/// 局部妆容对象，属于组合装内部的具体部位（眉毛、眼镜、鼻子等）自定义设置
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

#pragma mark - 子妆程度值

@interface FUMakeup (intensity)

/// 粉底程度值
@property (nonatomic, assign) double intensityFoundation;

/// 口红程度值
@property (nonatomic, assign) double intensityLip;

/// 口红高光程度值
/// @note 暂时只用于lipType=FUMakeupLipTypeMoisturizing的情况
@property (nonatomic, assign) double intensityLipHighlight;

/// 腮红程度值
@property (nonatomic, assign) double intensityBlusher;

/// 眉毛程度值
@property (nonatomic, assign) double intensityEyebrow;

/// 眼影程度值
@property (nonatomic, assign) double intensityEyeshadow;

/// 眼线程度值
@property (nonatomic, assign) double intensityEyeliner;

/// 睫毛程度值
@property (nonatomic, assign) double intensityEyelash;

/// 高光程度值
@property (nonatomic, assign) double intensityHighlight;

/// 阴影程度值
@property (nonatomic, assign) double intensityShadow;

/// 美瞳程度值
@property (nonatomic, assign) double intensityPupil;

@end

#pragma mark - 子妆颜色

@interface FUMakeup (Color)

/// 粉底颜色
@property (nonatomic, assign) FUColor foundationColor;

/// 口红颜色
@property (nonatomic, assign) FUColor lipColor;

/// 口红颜色2
@property (nonatomic, assign) FUColor lipColor2;

/// 腮红颜色
@property (nonatomic, assign) FUColor blusherColor;

/// 眉毛颜色
@property (nonatomic, assign) FUColor eyebrowColor;

/// 眼线颜色
@property (nonatomic, assign) FUColor eyelinerColor;

/// 睫毛颜色
@property (nonatomic, assign) FUColor eyelashColor;

/// 高光颜色
@property (nonatomic, assign) FUColor highlightColor;

/// 阴影颜色
@property (nonatomic, assign) FUColor shadowColor;

/// 美瞳颜色
@property (nonatomic, assign) FUColor pupilColor;

/// 眼影特殊处理
/// @note 如果is_two_color为1，会启用这个颜色，外圈颜色为color2，内圈颜色为color，如果color都为0，则外圈为透明，即为咬唇效果
/// - Parameters:
///   - color: 第一层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
///   - color1: 第二层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启，内部暂时未处理，使用color2和color3
///   - color2: 第三层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
///   - color3: 第四层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
- (void)setEyeColor:(FUColor)color
             color1:(FUColor)color1
             color2:(FUColor)color2
             color3:(FUColor)color3;

@end

@interface FUMakeup (landMark)

/// 这个参数控制是否使用修改过得landmark点，1为使用，0为不使用
@property (nonatomic, assign) int isUserFix;

/// 这个参数为一个数组，需要客户端传递一个数组进去
/// @note 传递的数组的长度为 150*人脸数，也就是将所有的点位信息存储的数组中传递进来
@property (nonatomic, assign) FULandMark fixMakeUpData;

@end

NS_ASSUME_NONNULL_END

