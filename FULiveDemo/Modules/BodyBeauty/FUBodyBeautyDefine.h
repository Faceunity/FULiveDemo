//
//  FUBodyBeautyDefine.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#ifndef FUBodyBeautyDefine_h
#define FUBodyBeautyDefine_h

typedef NS_ENUM(NSUInteger, BODYBEAUTYTYPE) {
    BODYBEAUTYTYPE_bodySlimStrength, //瘦身
    BODYBEAUTYTYPE_legSlimStrength, //长腿
    BODYBEAUTYTYPE_waistSlimStrength, //瘦腰:
    BODYBEAUTYTYPE_shoulderSlimStrength, //美肩
    BODYBEAUTYTYPE_hipSlimStrength, //美臀
    BODYBEAUTYTYPE_headSlim, //小头
    BODYBEAUTYTYPE_legSlim, //瘦腿
    BODYBEAUTYTYPE_debug, //是否开启debug点位
    BODYBEAUTYTYPE_clearSlim //重置:清空所有的美体效果，恢复为默认值
};
#endif /* FUBodyBeautyDefine_h */
