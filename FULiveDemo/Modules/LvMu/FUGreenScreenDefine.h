//
//  FUGreenScreenDefine.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#ifndef FUGreenScreenDefine_h
#define FUGreenScreenDefine_h

typedef NS_ENUM(NSUInteger, GREENSCREENTYPE) {
    GREENSCREENTYPE_keyColor, //颜色
    GREENSCREENTYPE_chromaThres, //色度最大容差
    GREENSCREENTYPE_chromaThresT, //色度最小限差
    GREENSCREENTYPE_alphaL, //透明度
    GREENSCREENTYPE_Max
};

#endif /* FUGreenScreenDefine_h */
