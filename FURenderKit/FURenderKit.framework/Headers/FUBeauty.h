//
//  FUBeauty.m
//  FURenderKit
//
//  Created by 项林平 on 2023/5/16.
//

#import "FUItem.h"
#import "FUFilterDefineKey.h"
#import "FUBeautyPropertyModeDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeauty : FUItem

/// 磨皮是否使用 mask
@property (nonatomic, assign) BOOL blurUseMask;

/// 朦胧磨皮开关 0清晰磨皮 1朦胧磨皮
@property (nonatomic, assign) int heavyBlur;

/// 磨皮类型  0清晰磨皮 1朦胧磨皮 2精细磨皮 3均匀磨皮
/// @note 此属性优先级比 heavyBlur 低, 在使用时要将 heavyBlur 设为0
@property (nonatomic, assign) int blurType;

/// 将所有属性恢复到默认值
- (void)resetToDefault;

@end
 

@interface FUBeauty (Skin)

/// 皮肤分割（皮肤美白），YES开启，NO关闭，默认NO
/// @note 开启时美白效果仅支持皮肤区域，关闭时美白效果支持全局区域
/// @note 推荐非直播场景和 iPhoneXR 以上机型使用
@property (nonatomic, assign) BOOL enableSkinSegmentation;

/// 肤色检测开关 0为关, 1为开，默认值0.0
@property (nonatomic, assign) int skinDetect;

/// 肤色检测之后非肤色区域的融合程度 取值范围0.0-1.0，默认值0.0
@property (nonatomic, assign) int nonskinBlurScale;

/// 精细磨皮 取值范围0.0-6.0, 默认6.0
@property (nonatomic, assign) double blurLevel;

/// 祛斑痘，取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
/// @note 硬件支持原因，祛斑痘仅支持 iPhoneXR 及以上机型使用
@property (nonatomic, assign) double antiAcneSpot;

/// 美白 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double colorLevel;

/// 红润 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double redLevel;

/// 清晰 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double clarity;

/// 锐化 取值范围0.0-1.0, 默认0.0
@property (nonatomic, assign) double sharpen;

/// 五官立体 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double faceThreed;

/// 亮眼 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double eyeBright;

/// 美牙 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double toothWhiten;

/// 去黑眼圈 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double removePouchStrength;

/// 去法令纹 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double removeNasolabialFoldsStrength;

@end

@interface FUBeauty (Shape)

/// 变形取值 0女神变形 1网红变形 2自然变形 3默认变形 4精细变形
@property (nonatomic, assign) int faceShape;

/// 渐变所需要的帧数 0为关闭渐变, 大于0开启渐变
@property (nonatomic, assign) int changeFrames;

/// 变形程度 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值1.0
@property (nonatomic, assign) double faceShapeLevel;

/// v脸 0.0-1.0，默认0.0
@property (nonatomic, assign) double cheekV;

/// 瘦脸 0.0-1.0，默认0.0
@property (nonatomic, assign) double cheekThinning;

/// 长脸 0.0-1.0，默认0.0
@property (nonatomic, assign) double cheekLong;

/// 圆脸 0.0-1.0，默认0.0
@property (nonatomic, assign) double cheekCircle;

/// 窄脸 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double cheekNarrow;

/// 小脸 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double cheekSmall;

/// 短脸 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double cheekShort;

/// 瘦颧骨 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityCheekbones;

/// 瘦下颌骨 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityLowerJaw;

/// 大眼 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double eyeEnlarging;

/// 下巴 取值范围 0.0-1.0, 0.5-0是变小, 0.5-1是变大, 默认值0.5
@property (nonatomic, assign) double intensityChin;

/// 额头 取值范围 0.0-1.0, 0.5-0是变小, 0.5-1是变大, 默认值0.5
@property (nonatomic, assign) double intensityForehead;

/// 瘦鼻 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityNose;

/// 嘴型 取值范围 0.0-1.0, 0.5-0.0是变大, 0.5-1.0是变小, 默认值0.5
@property (nonatomic, assign) double intensityMouth;

/// 嘴唇厚度 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变薄, 0.5-1是变厚, 默认值0.5
@property (nonatomic, assign) double intensityLipThick;

/// 眼睛位置 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变低, 0.5-1是变高, 默认值0.5
@property (nonatomic, assign) double intensityEyeHeight;

/// 开眼角 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityCanthus;

/// 眼睑下至 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityEyeLid;

/// 眼距 取值范围 0.0-1.0, 0.5-0.0是变大, 0.5-1.0是变小, 默认值0.5
@property (nonatomic, assign) double intensityEyeSpace;

/// 眼睛角度 取值范围 0.0-1.0, 0.5-0.0逆时针旋转, 0.5-1.0顺时针旋转, 默认值0.5
@property (nonatomic, assign) double intensityEyeRotate;

/// 长鼻 取值范围 0.0-1.0, 0.5-0.0是变长, 0.5-1.0是变短, 默认值0.5
@property (nonatomic, assign) double intensityLongNose;

/// 缩人中 取值范围 0.0-1.0, 0.5-0.0是变短, 0.5-1.0是变长, 默认值0.5
@property (nonatomic, assign) double intensityPhiltrum;

/// 微笑嘴角 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensitySmile;

/// 圆眼 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityEyeCircle;

/// 眉毛上下 取值范围 0.0-1.0, 0.5-0是向上, 0.5-1是向下, 默认值0.5
@property (nonatomic, assign) double intensityBrowHeight;

/// 眉间距 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变小, 0.5-1是变大, 默认值0.5
@property (nonatomic, assign) double intensityBrowSpace;

/// 眉毛粗细 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变细, 0.5-1是变粗, 默认值0.5
@property (nonatomic, assign) double intensityBrowThick;

@end

@interface FUBeauty (Filter)

/// 滤镜名称 字符串类型，默认值为 "origin" , 即为使用原图效果
/// @see FUFilter
@property (nonatomic, strong) FUFilter filterName;

/// 滤镜程度值 取值范围 0.0-1.0，0.0为无效果, 1.0为最大效果, 默认值1.0
@property (nonatomic, assign) double filterLevel;

/// 获取指定滤镜的程度值
/// - Parameter filterForKey: 滤镜名称
- (double)filterValueForKey:(NSString *)filterForKey;

/// 所有支持的滤镜名称字符串数组
- (NSArray *)allFilterKeys;

@end

@interface FUBeauty (Mode)

/**
 * 设置部分美颜属性的mode, 不同mode会有主观上会有不同效果
 * 必须在设置美颜各个属性值之前调用该接口
 * key和mode说明
 | key      |   属性   |  支持的mode                                                        |
 | ------------- | -------- | ------------------------------------------------------------ |
 | color_level    |   美白  | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.2.0)        |
 | remove_pouch_strength     |   去黑眼圈    | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.2.0, 高性能设备推荐)    |
 | remove_nasolabial_folds_strength     |    去法令纹   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.2.0, 高性能设备推荐)        |
 | cheek_thinning    |  瘦脸   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.3.0)     |
 | cheek_narrow    |  窄脸   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)     |
 | cheek_small  |  小脸   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)    |
 | eye_enlarging    | 大眼  | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0), FUBeautyPropertyMode3(v8.2.0, 高性能设备推荐)        |
 | intensity_chin    | 下巴  | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.4.0)   |
 | intensity_forehead    |   额头   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)     |
 | intensity_nose  |   瘦鼻   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)    |
 | intensity_mouth    |   嘴型   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0), FUBeautyPropertyMode3(v8.2.0, 高性能设备推荐)       |
**/
- (void)addPropertyMode:(FUBeautyPropertyMode)mode forKey:(FUModeKey)key;

@end

NS_ASSUME_NONNULL_END
