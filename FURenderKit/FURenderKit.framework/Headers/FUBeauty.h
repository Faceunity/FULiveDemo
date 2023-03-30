//
//  FUBeautiItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/4.
//

#import "FUItem.h"
#import "FUFilterDefineKey.h"
#import "FUBeautyPropertyModeDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeauty : FUItem

@property (nonatomic, assign) BOOL blurUseMask;//blur是否使用mask
@property (nonatomic, assign) int heavyBlur;//朦胧磨皮开关, 0为清晰磨皮, 1为朦胧磨皮
@property (nonatomic, assign) int blurType;//此参数优先级比heavyBlur低, 在使用时要将heavy_blur设为0, 0清晰磨皮 1朦胧磨皮 2精细磨皮 3均匀磨皮

/// 将参数恢复到默认值
- (void)resetToDefault;

@end
 

@interface FUBeauty (Skin)
@property (nonatomic, assign) int skinDetect;//肤色检测开关, 0为关, 1为开 默认值0.0
@property (nonatomic, assign) int nonskinBlurScale;//肤色检测之后非肤色区域的融合程度, 取值范围0.0-1.0, 默认值0.0
@property (nonatomic, assign) double blurLevel;//精细磨皮 取值范围0.0-6.0, 默认6.0
@property (nonatomic, assign) double colorLevel;//美白 取值范围 0.0-1.0,0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double redLevel;//红润 取值范围 0.0-1.0,0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double sharpen;//锐化 取值范围0.0-1.0, 默认0.0
@property (nonatomic, assign) double faceThreed;//五官立体 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double eyeBright;//亮眼 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double toothWhiten;//美牙 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double removePouchStrength;//去黑眼圈 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double removeNasolabialFoldsStrength;//去法令纹 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@end

@interface FUBeauty (Shap)
@property (nonatomic, assign) int faceShape;//变形取值 0:女神变形 1:网红变形 2:自然变形 3:默认变形 4:精细变形
@property (nonatomic, assign) int changeFrames; //0为关闭 , 大于0开启渐变, 值为渐变所需要的帧数
@property (nonatomic, assign) double faceShapeLevel; //变形程度 取值范围 0.0-1.0,0.0为无效果, 1.0为最大效果, 默认值1.0

/// 脸型相关属性, 程度范围0.0-1.0 默认0.0
@property (nonatomic, assign) double cheekV;//v脸
@property (nonatomic, assign) double cheekThinning;//瘦脸
@property (nonatomic, assign) double cheekLong;//长脸
@property (nonatomic, assign) double cheekCircle;//圆脸

/// 其他普通属性
@property (nonatomic, assign) double cheekNarrow;//窄脸 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double cheekSmall;//小脸 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double cheekShort;//短脸 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityCheekbones;//瘦颧骨 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityLowerJaw;//瘦下颌骨 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double eyeEnlarging;//大眼 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityChin;//下巴 取值范围 0.0-1.0, 0.5-0是变小, 0.5-1是变大, 默认值0.5
@property (nonatomic, assign) double intensityForehead;//额头 取值范围 0.0-1.0, 0.5-0是变小, 0.5-1是变大, 默认值0.5
@property (nonatomic, assign) double intensityNose;//瘦鼻 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityMouth;//嘴型 取值范围 0.0-1.0, 0.5-0.0是变大, 0.5-1.0是变小, 默认值0.5
@property (nonatomic, assign) double intensityLipThick;//嘴唇厚度 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变薄, 0.5-1是变厚, 默认值0.5
@property (nonatomic, assign) double intensityEyeHeight;//眼睛位置 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变低, 0.5-1是变高, 默认值0.5
@property (nonatomic, assign) double intensityCanthus;//开眼角 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityEyeLid;//眼睑下至 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityEyeSpace;//眼距 取值范围 0.0-1.0, 0.5-0.0是变大, 0.5-1.0是变小, 默认值0.5
@property (nonatomic, assign) double intensityEyeRotate;//眼睛角度 取值范围 0.0-1.0, 0.5-0.0逆时针旋转, 0.5-1.0顺时针旋转, 默认值0.5
@property (nonatomic, assign) double intensityLongNose;//长鼻 取值范围 0.0-1.0, 0.5-0.0是变长, 0.5-1.0是变短, 默认值0.5
@property (nonatomic, assign) double intensityPhiltrum;//缩人中 取值范围 0.0-1.0, 0.5-0.0是变短, 0.5-1.0是变长, 默认值0.5
@property (nonatomic, assign) double intensitySmile;//微笑嘴角 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityEyeCircle;//圆眼 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0
@property (nonatomic, assign) double intensityBrowHeight;//眉毛上下 取值范围 0.0-1.0, 0.5-0是向上, 0.5-1是向下, 默认值0.5
@property (nonatomic, assign) double intensityBrowSpace;//眉间距 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变小, 0.5-1是变大, 默认值0.5
@property (nonatomic, assign) double intensityBrowThick;//眉毛粗细 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变细, 0.5-1是变粗, 默认值0.5

@end

@interface FUBeauty (Filter)

@property (nonatomic, strong) FUFilter filterName;//取值为一个字符串, 默认值为 “origin” , origin即为使用原图效果
@property (nonatomic, assign) double filterLevel; //取值范围 0.0-1.0,0.0为无效果, 1.0为最大效果, 默认值1.0

- (double)filterValueForKey:(NSString *)filterForKey;

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
