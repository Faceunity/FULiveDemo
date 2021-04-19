//
//  FUBeautiItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/4.
//

#import "FUItem.h"
#import "FUFilterDefineKey.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeauty : FUItem

@property (nonatomic, assign) BOOL blurUseMask;//blur是否使用mask
@property (nonatomic, assign) int heavyBlur;//朦胧磨皮开关，0为清晰磨皮，1为朦胧磨皮
@property (nonatomic, assign) int blurType;//此参数优先级比heavyBlur低，在使用时要将heavy_blur设为0，0 清晰磨皮  1 朦胧磨皮  2精细磨皮

/// 将参数恢复到默认值
- (void)resetToDefault;

@end
 

@interface FUBeauty (Skin)
@property (nonatomic, assign) int skinDetect;//肤色检测开关，0为关，1为开 默认0
@property (nonatomic, assign) int nonskinBlurScale;//肤色检测之后非肤色区域的融合程度，取值范围0.0-1.0，默认0.0
@property (nonatomic, assign) double blurLevel;//精细磨皮,磨皮程度，取值范围0.0-6.0，默认6.0
@property (nonatomic, assign) double colorLevel;//美白 取值范围 0.0-1.0,0.0为无效果，1.0为最大效果，默认值0.2
@property (nonatomic, assign) double redLevel;//红润 取值范围 0.0-1.0,0.0为无效果，1.0为最大效果，默认值0.5
@property (nonatomic, assign) double sharpen;//锐化 锐化程度，取值范围0.0-1.0，默认0.2
@property (nonatomic, assign) double eyeBright;//亮眼 0.0-1.0, 0.0为无效果，1.0为最大效果，默认值1.0
@property (nonatomic, assign) double toothWhiten;//美牙 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值1.0
@property (nonatomic, assign) double removePouchStrength;//去黑眼圈
@property (nonatomic, assign) double removeNasolabialFoldsStrength;//去法令纹
@end

@interface FUBeauty (Shap)
@property (nonatomic, assign) int faceShape;//变形取值 0:女神变形 1:网红变形 2:自然变形 3:默认变形 4:精细变形
@property (nonatomic, assign) int changeFrames; //0为关闭 ，大于0开启渐变，值为渐变所需要的帧数
@property (nonatomic, assign) double faceShapeLevel; //取值范围 0.0-1.0,0.0为无效果，1.0为最大效果，默认值1.0
@property (nonatomic, assign) double cheekThinning;//瘦脸 瘦脸程度范围0.0-1.0 默认0.5
@property (nonatomic, assign) double cheekV;//v脸
@property (nonatomic, assign) double cheekNarrow;//窄脸
@property (nonatomic, assign) double cheekSmall;//小脸
@property (nonatomic, assign) double intensityCheekbones;//瘦颧骨
@property (nonatomic, assign) double intensityLowerJaw;//瘦下颌骨
@property (nonatomic, assign) double eyeEnlarging;//大眼
@property (nonatomic, assign) double intensityChin;//下巴
@property (nonatomic, assign) double intensityForehead;//额头
@property (nonatomic, assign) double intensityNose;//瘦鼻
@property (nonatomic, assign) double intensityMouth;//嘴型
@property (nonatomic, assign) double intensityCanthus;//开眼角
@property (nonatomic, assign) double intensityEyeSpace;//眼距
@property (nonatomic, assign) double intensityEyeRotate;//眼角
@property (nonatomic, assign) double intensityLongNose;//长鼻
@property (nonatomic, assign) double intensityPhiltrum;//缩人中
@property (nonatomic, assign) double intensitySmile;//微笑嘴角
@property (nonatomic, assign) double intensityEyeCircle;//圆眼
@end

@interface FUBeauty (Filter)
@property (nonatomic, strong) FUFilter filterName;//取值为一个字符串，默认值为 “origin” ，origin即为使用原图效果
@property (nonatomic, assign) double filterLevel; //取值范围 0.0-1.0,0.0为无效果，1.0为最大效果，默认值1.0
//- (void)setFilterValue:(double)value forKey:(FUFilter)filterKey;

- (double)filterValueForKey:(NSString *)filterForKey;

- (NSArray *)allFilterKeys;

//- (NSArray<NSNumber *> *)allFilterValues;
@end

NS_ASSUME_NONNULL_END
