//
//  FUBeautyParam.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/1/7.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUBeautyParam.h"

@implementation FUBeautyParams
+(FUBeautyParams *)defaultParams{
    FUBeautyParams *deParams = [[FUBeautyParams alloc] init];
    deParams.is_beauty_on = 1;
    deParams.use_landmark = 1;
    deParams.filter_level = 1;
    deParams.filter_name = @"origin";
    
    deParams.color_level = 0.0;
    deParams.red_level = 0.0;
    deParams.blur_level = 0.0;
    deParams.heavy_blur = 0;
    deParams.blur_type = 2;
    deParams.blur_use_mask = 0;
    
    deParams.sharpen = 0.0;
    deParams.eye_bright = 0.0;
    deParams.tooth_whiten = 0.0;
    
    deParams.remove_pouch_strength = 0.0;
    deParams.remove_nasolabial_folds_strength = 0.0;
    
    deParams.face_shape_level = 1.0;
    deParams.change_frames = 0;
    deParams.face_shape = 4;
    
    deParams.eye_enlarging = 0.0;
    deParams.cheek_thinning = 0.0;
    deParams.cheek_v = 0.0;
    deParams.cheek_narrow = 0;
    deParams.cheek_small = 0;
    deParams.intensity_nose = 0;
    deParams.intensity_forehead = 0.5;
    deParams.intensity_mouth = 0.5;
    deParams.intensity_chin = 0.5;
    deParams.intensity_philtrum = 0.5;
    deParams.intensity_long_nose = 0.5;
    deParams.intensity_eye_space = 0.5;
    deParams.intensity_eye_rotate = 0.5;
    deParams.intensity_smile = 0.0;
    deParams.intensity_canthus = 0.5;
    deParams.intensity_cheekbones = 0;
    deParams.intensity_lower_jaw= 0.0;
    deParams.intensity_eye_circle = 0.0;
    
    return deParams;
}

+(FUBeautyParams *)styleWithType:(FUBeautyStyleType)type{
    if (type == FUBeautyStyleType1) {
        return [self style1];
    }
    if (type == FUBeautyStyleType2) {
        return [self style2];
    }
    if (type == FUBeautyStyleType3) {
        return [self style3];
    }
    if (type == FUBeautyStyleType4) {
        return [self style4];
    }
    if (type == FUBeautyStyleType5) {
        return [self style5];
    }
    if (type == FUBeautyStyleType6) {
        return [self style6];
    }
    if (type == FUBeautyStyleType7) {
        return [self style7];
    }
    return nil;
}

+(FUBeautyParams *)style1{
    FUBeautyParams *style = [FUBeautyParams defaultParams];
    style.filter_name = @"bailiang1";
    style.filter_level = 0.2;
    style.color_level = 0.5;
    style.blur_level = 3;
    style.eye_bright = 0.35;
    style.tooth_whiten = 0.25;
    style.cheek_thinning = 0.45;
    style.cheek_v = 0.08;
    style.cheek_small = 0.1;
    style.eye_enlarging = 0.3;
    
    return style;
    
}
+(FUBeautyParams *)style2{
    FUBeautyParams *style = [FUBeautyParams defaultParams];
    style.filter_name = @"ziran3";
    style.filter_level = 0.35;
    style.color_level = 0.7;
    style.red_level = 0.3;
    style.blur_level = 3;
    style.eye_bright = 0.5;
    style.tooth_whiten = 0.4;
    style.cheek_thinning = 0.3;
    style.intensity_nose = 0.5;
    style.eye_enlarging = 0.25;
    return style;

}
+(FUBeautyParams *)style3
{
    FUBeautyParams *style = [FUBeautyParams defaultParams];

    style.color_level = 0.6;
    style.red_level = 0.1;
    style.blur_level = 1.8;

    style.cheek_thinning = 0.3;
    style.cheek_small = 0.3;
    style.eye_enlarging = 0.65;
    style.cheek_small = 0.3;
    return style;
}
+(FUBeautyParams *)style4{
    FUBeautyParams *style = [FUBeautyParams defaultParams];
    style.color_level = 0.25;
    style.blur_level = 3;

    return style;
}
+(FUBeautyParams *)style5{
    FUBeautyParams *style = [FUBeautyParams defaultParams];
    style.filter_name = @"fennen1";
    style.filter_level = 0.4;
    style.color_level = 0.7;
    style.blur_level = 3;
    style.cheek_thinning = 0.35;
    style.eye_enlarging = 0.65;
    return style;
}
+(FUBeautyParams *)style6{
    FUBeautyParams *style = [FUBeautyParams defaultParams];
    style.filter_name = @"ziran5";
    style.filter_level = 0.2;
    style.color_level = 0.2;
    style.red_level = 0.65;
    style.blur_level = 3.3;
    style.cheek_thinning = 0.1;
    style.cheek_small = 0.1;
    return style;
}
+(FUBeautyParams *)style7{
    FUBeautyParams *style = [FUBeautyParams defaultParams];
    style.filter_name = @"ziran2";
    style.filter_level = 0.4;
    style.color_level = 0.3;
    style.blur_level = 4.2;
    style.cheek_v = 0.5;
    style.eye_enlarging = 0.4;
    return style;
}


@end

@implementation FUBeautyParam

@end
