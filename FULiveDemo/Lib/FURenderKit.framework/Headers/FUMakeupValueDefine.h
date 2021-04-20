//
//  FUMakeupValueDefine.h
//  FURenderKit
//
//  Created by Chen on 2021/3/4.
//

#ifndef FUMakeupValueDefine_h
#define FUMakeupValueDefine_h

typedef NS_ENUM(NSUInteger, FUMakeupLipType) {
    FUMakeupLipTypeFOG = 0, //雾面
    FUMakeupLipTypeGlossy = 2, //润泽
    FUMakeupLipTypePearlyLustre = 3, //珠光
    FUMakeupLipTypeHightPerformance = 6 //高性能
};

typedef NS_ENUM(NSUInteger, FUMakeupBrowWarpType) {
    FUMakeupBrowWarpTypeArch = 0, //柳叶眉
    FUMakeupBrowWarpTypeSynophridia, //一字眉
    FUMakeupBrowWarpTypeDistantMountains, //远山眉
    FUMakeupBrowWarpTypeStandard, //标准眉
    FUMakeupBrowWarpTypeHelpShape, //扶形眉
    FUMakeupBrowWarpTypeDaily, //日常风
    FUMakeupBrowWarpTypeJapanese //日系风
};

typedef NS_ENUM(NSInteger, FUMakeupBlendType) {
    FUMakeupBlendTypeInvalid = -1, //默认无效
    FUMakeupBlendTypeMultiply = 0, //正片叠底
    FUMakeupBlendTypeNormal, //正常混合
    FUMakeupBlendTypeOverlay, //叠加
    FUMakeupBlendTypeSoftLight, //柔光模式
};


#endif /* FUMakeupValueDefine_h */
