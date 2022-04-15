//
//  FUMakeupDefine.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/2.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#ifndef FUMakeupDefine_h
#define FUMakeupDefine_h

/// 单个妆容类型
typedef NS_ENUM(NSUInteger, FUSingleMakeupType) {
    FUSingleMakeupTypeFoundation,   // 粉底
    FUSingleMakeupTypeLip,          // 口红
    FUSingleMakeupTypeBlusher,      // 腮红
    FUSingleMakeupTypeEyebrow,      // 眉毛
    FUSingleMakeupTypeEyeshadow,    // 眼影
    FUSingleMakeupTypeEyeliner,     // 眼线
    FUSingleMakeupTypeEyelash,      // 睫毛
    FUSingleMakeupTypeHighlight,    // 高光
    FUSingleMakeupTypeShadow,       // 阴影
    FUSingleMakeupTypePupil         // 美瞳
};

#endif /* FUMakeupDefine_h */
