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
    FUStyleCustomizingSkinTypeRemoveNasolabialFoldsStrength
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
    FUStyleCustomizingShapeTypeBrowThick
};


#endif /* FUStyleDefine_h */
