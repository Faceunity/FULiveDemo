//
//  FUBeauty-Deprecated.h
//  FURenderKit
//
//  Created by 项林平 on 2022/3/29.
//

#import "FUBeauty.h"

@interface FUBeauty (Deprecated)

@property (nonatomic, assign) double cheekNarrowV2 DEPRECATED_MSG_ATTRIBUTE("use cheekNarrow instead");//窄脸 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0
@property (nonatomic, assign) double cheekSmallV2 DEPRECATED_MSG_ATTRIBUTE("use cheekSmall instead");//小脸 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0
@property (nonatomic, assign) double eyeEnlargingV2 DEPRECATED_MSG_ATTRIBUTE("use eyeEnlarging instead");//大眼 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0
@property (nonatomic, assign) double intensityForeheadV2 DEPRECATED_MSG_ATTRIBUTE("use intensityForehead instead");//额头 取值范围 0.0-1.0,  0.5-0.0是变小，0.5-1.0是变大，默认值0.5
@property (nonatomic, assign) double intensityNoseV2 DEPRECATED_MSG_ATTRIBUTE("use intensityNose instead");//瘦鼻 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0
@property (nonatomic, assign) double intensityMouthV2 DEPRECATED_MSG_ATTRIBUTE("use intensityMouth instead");//嘴型 取值范围 0.0-1.0,  0.5-0.0是变大，0.5-1.0是变小，默认值0.5

@end
