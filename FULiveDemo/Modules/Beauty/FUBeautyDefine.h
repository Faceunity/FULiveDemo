//
//  FUBeautyDefine.h
//  FUSDKDemo
//
//  Created by Chen on 2020/11/23.
//  Copyright © 2020 liu. All rights reserved.
//

#ifndef FUBeautyDefine_h
#define FUBeautyDefine_h

typedef NS_ENUM(NSUInteger, FUBeautyDefine) {
    FUBeautyDefineSkin = 0, //美肤
    FUBeautyDefineShape = 1, //美型
    FUBeautyDefineFilter = 2, //滤镜
    FUBeautyDefineStyle = 3 //风格化
};

typedef NS_ENUM(NSUInteger, FUBeautifyShape) {
    FUBeautifyShapeCheekThinning, //"cheek_thinning",
    FUBeautifyShapeCheekV, //"cheek_v",
    FUBeautifyShapeCheekNarrow, //"cheek_narrow",
    FUBeautifyShapeCheekSmall, //"cheek_small",
    FUBeautifyShapeIntensityCheekbones, //"intensity_cheekbones",
    FUBeautifyShapeIntensityLowerJaw, //"intensity_lower_jaw",
    FUBeautifyShapeEyeEnlarging, //"eye_enlarging",
    FUBeautifyShapeEyeCircle, //eye_circle
    FUBeautifyShapeIntensityChin, //"intensity_chin",
    FUBeautifyShapeIntensityForehead, //"intensity_forehead",
    FUBeautifyShapeIntensityNose, //"intensity_nose",
    FUBeautifyShapeIntensityMouth, //"intensity_mouth",
    FUBeautifyShapeIntensityCanthus, //"intensity_canthus",
    FUBeautifyShapeIntensityEyeSpace, //"intensity_eye_space",
    FUBeautifyShapeIntensityEyeRotate, //"intensity_eye_rotate",
    FUBeautifyShapeIntensityLongNose, //"intensity_long_nose",
    FUBeautifyShapeIntensityPhiltrum, //"intensity_philtrum",
    FUBeautifyShapeIntensitySmile, //"intensity_smile",
    FUBeautifyShapeMax = 18
};


typedef NS_ENUM(NSUInteger, FUBeautifySkin) {
    FUBeautifySkinBlurLevel, //"blur_level",
    FUBeautifySkinColorLevel, //"color_level",
    FUBeautifySkinRedLevel, //"red_level",
    FUBeautifySkinSharpen, //"sharpen",
    FUBeautifySkinEyeBright, //"eye_bright",
    FUBeautifySkinToothWhiten, //"tooth_whiten",
    FUBeautifySkinRemovePouchStrength, //"remove_pouch_strength",
    FUBeautifySkinRemoveNasolabialFoldsStrength, //"remove_nasolabial_folds_strength"
    FUBeautifySkinMax
};

typedef NS_ENUM(NSUInteger, FUBeautyStyleType) {
    FUBeautyStyleTypeNone = 0,
    FUBeautyStyleType1,
    FUBeautyStyleType2,
    FUBeautyStyleType3,
    FUBeautyStyleType4,
    FUBeautyStyleType5,
    FUBeautyStyleType6,
    FUBeautyStyleType7,

    FUBeautyStyleMax
};
#endif /* FUBeautyDefine_h */
