//
//  FUBeautyPropertyModeDefine.h
//  FURenderKit
//
//  Created by 项林平 on 2022/3/29.
//

#ifndef FUBeautyPropertyModeDefine_h
#define FUBeautyPropertyModeDefine_h

#import "FUKeysDefine.h"

typedef NS_ENUM(NSUInteger, FUBeautyPropertyMode) {
    FUBeautyPropertyMode1 = 1,
    FUBeautyPropertyMode2 = 2,
    FUBeautyPropertyMode3 = 3
};

FUParamsKeysDefine(FUModeKey,
                   FUModeKeyColorLevel = @"color_level",
                   FUModeKeyRemovePouchStrength = @"remove_pouch_strength",
                   FUModeKeyRemoveNasolabialFoldsStrength = @"remove_nasolabial_folds_strength",
                   FUModeKeyCheekThinning = @"cheek_thinning",
                   FUModeKeyCheekNarrow = @"cheek_narrow",
                   FUModeKeyCheekSmall = @"cheek_small",
                   FUModeKeyEyeEnlarging = @"eye_enlarging",
                   FUModeKeyIntensityChin = @"intensity_chin",
                   FUModeKeyIntensityForehead = @"intensity_forehead",
                   FUModeKeyIntensityNose = @"intensity_nose",
                   FUModeKeyIntensityMouth = @"intensity_mouth"
                   )


#endif /* FUBeautyPropertyModeDefine_h */
