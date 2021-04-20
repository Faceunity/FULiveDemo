//
//  FUMakeUpDefine.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/2.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#ifndef FUMakeUpDefine_h
#define FUMakeUpDefine_h
typedef NS_ENUM(NSUInteger, MAKEUPTYPE) {
    MAKEUPTYPE_Lip, //口红
    MAKEUPTYPE_blusher, //腮红
    MAKEUPTYPE_eyeBrow, //眉毛
    MAKEUPTYPE_eyeShadow, //眼影
    MAKEUPTYPE_eyeLiner, //眼线
    MAKEUPTYPE_eyelash, //睫毛
    MAKEUPTYPE_pupil, //美瞳
    MAKEUPTYPE_foundation, // 粉底
    MAKEUPTYPE_highlight, //高光
    MAKEUPTYPE_shadow, //阴影
    MAKEUPTYPE_Max
};

//具体子妆bundle枚举
typedef NS_ENUM(NSUInteger, SUBMAKEUPTYPE) {
    SUBMAKEUPTYPE_foundation = 0, //粉底
    SUBMAKEUPTYPE_blusher, //腮红
    SUBMAKEUPTYPE_eyeBrow, //眉毛
    SUBMAKEUPTYPE_eyeShadow, //眼影
    SUBMAKEUPTYPE_eyeLiner, //眼线
    SUBMAKEUPTYPE_eyeLash, //睫毛
    SUBMAKEUPTYPE_highlight, //高光
    SUBMAKEUPTYPE_shadow, //阴影
    SUBMAKEUPTYPE_pupil = 8, //美瞳

};

//当前操作UI的类型：强度、颜色、
typedef NS_ENUM(NSUInteger, UIMAKEUITYPE) {
    UIMAKEUITYPE_intensity = 0, //强度设置
    UIMAKEUITYPE_color, //颜色设置
    UIMAKEUITYPE_pattern, //样式设置
};

//轻美妆图片枚举
typedef NS_ENUM(NSUInteger, LIGHTMAKEUPIMAGETYPE) {
    LIGHTMAKEUPIMAGETYPE_texBrow, //眉毛
    LIGHTMAKEUPIMAGETYPE_texEye, //眼影
    LIGHTMAKEUPIMAGETYPE_pupil, //美瞳
    LIGHTMAKEUPIMAGETYPE_eyeLash, //睫毛
    LIGHTMAKEUPIMAGETYPE_HightLight, //高光
    LIGHTMAKEUPIMAGETYPE_eyeLiner, //眼线
    LIGHTMAKEUPIMAGETYPE_blusher = 6 //腮红
};

//轻美妆UI操作类型，图片，强度
typedef NS_ENUM(NSUInteger, UILIGHTMAKEUPTYPE) {
    UILIGHTMAKEUPTYPE_IMAGE, //图片
    UILIGHTMAKEUPTYPE_intensity //强度
};
#endif /* FUMakeUpDefine_h */
