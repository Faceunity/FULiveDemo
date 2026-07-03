//
//  FUStyleDefine.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/8.
//

#import <AVFoundation/AVFoundation.h>

#ifndef FUStyleDefine_h
#define FUStyleDefine_h

typedef NS_ENUM(NSUInteger, FUStyleCustomizingSkinType) {
    FUStyleCustomizingSkinTypeBlurLevel = 0,
    FUStyleCustomizingSkinTypeColorLevel,
    FUStyleCustomizingSkinTypeRedLevel,
    FUStyleCustomizingSkinTypeSharpen,
    FUStyleCustomizingSkinTypeFaceThreed,
    FUStyleCustomizingSkinTypeEyeBright,
    FUStyleCustomizingSkinTypeToothWhiten,
    FUStyleCustomizingSkinTypeRemovePouchStrength,
    FUStyleCustomizingSkinTypeRemoveNasolabialFoldsStrength,
    FUStyleCustomizingSkinTypeAntiAcneSpot,
    FUStyleCustomizingSkinTypeClarity,
    FUStyleCustomizingSkinTypeBodyBlurLevel,    // 全身磨皮，SDK key: body_blur_level，范围 0.0-6.0，仅 4 级机型
    FUStyleCustomizingSkinTypeFacialPlump       // 面部丰盈，SDK key: facial_plump，范围 0.0-1.0，高端机
};

typedef NS_ENUM(NSUInteger, FUStyleCustomizingShapeType) {
    FUStyleCustomizingShapeTypeCheekThinning = 0,
    FUStyleCustomizingShapeTypeCheekV,
    FUStyleCustomizingShapeTypeCheekNarrow,
    FUStyleCustomizingShapeTypeCheekShort,
    FUStyleCustomizingShapeTypeCheekSmall,
    FUStyleCustomizingShapeTypeCheekbones,
    FUStyleCustomizingShapeTypeLowerJaw,
    FUStyleCustomizingShapeTypeEyeEnlarging,
    FUStyleCustomizingShapeTypeEyeCircle,
    FUStyleCustomizingShapeTypeChin,
    FUStyleCustomizingShapeTypeForehead,
    FUStyleCustomizingShapeTypeNose,
    FUStyleCustomizingShapeTypeMouth,
    FUStyleCustomizingShapeTypeLipThick,
    FUStyleCustomizingShapeTypeEyeHeight,
    FUStyleCustomizingShapeTypeCanthus,
    FUStyleCustomizingShapeTypeEyeLid,
    FUStyleCustomizingShapeTypeEyeSpace,
    FUStyleCustomizingShapeTypeEyeRotate,
    FUStyleCustomizingShapeTypeLongNose,
    FUStyleCustomizingShapeTypePhiltrum,
    FUStyleCustomizingShapeTypeSmile,
    FUStyleCustomizingShapeTypeBrowHeight,
    FUStyleCustomizingShapeTypeBrowSpace,
    FUStyleCustomizingShapeTypeBrowThick,
    FUStyleCustomizingShapeTypeEyePupil         // 瞳孔大小，SDK key: intensity_eye_pupil，范围 0.0-1.0，双向滑杆，全机型
};


#endif /* FUStyleDefine_h */
