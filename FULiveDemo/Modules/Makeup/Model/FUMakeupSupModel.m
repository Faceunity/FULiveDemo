//
//  FUMakeupSupModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/11.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMakeupSupModel.h"
#import <objc/runtime.h>

@implementation FUMakeupSupModel

//+ (NSDictionary *)objectClassInArray{
//    return @{
//             @"makeups" : @"FUSingleMakeupModel"
//             };
//}

-(void)setMakeupBundle:(NSString *)makeupBundle{
    if (!makeupBundle || [makeupBundle isEqualToString:@""]) {
        return;
    }
    _makeupBundle = makeupBundle;
    
    /* modle.makeupBundle 和 妆容json文件 名称是相同的 */
    NSString *path=[[NSBundle mainBundle] pathForResource:makeupBundle ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    //注意：FUSingleMakeupModel 为单个子妆容如：口红，腮红....
    /* 口红数据 */
    FUSingleMakeupModel *modle0 = [FUSingleMakeupModel new];
    modle0.makeType = 0;
    modle0.namaValueType = MAKEUPTYPE_Lip;
    modle0.value  = [dic[@"makeup_intensity_lip"] floatValue];
    modle0.colorStr = @"makeup_lip_color";
    modle0.colorStrV = dic[@"makeup_lip_color"];
    modle0.is_two_color = [dic[@"is_two_color"] intValue];
    modle0.lip_type = [dic[@"lip_type"] intValue];

    /* 腮红 */
    FUSingleMakeupModel *modle1 = [FUSingleMakeupModel new];
    modle1.makeType = 1;
    modle1.namaBundleType = SUBMAKEUPTYPE_blusher;
    modle1.namaBundle = dic[@"tex_blusher"];
    modle1.namaValueType = MAKEUPTYPE_blusher;
    modle1.value  = [dic[@"makeup_intensity_blusher"] floatValue];
    modle1.colorStr = @"makeup_blusher_color";
    modle1.colorStrV = dic[@"makeup_blusher_color"];

    /* 眉毛 */
    FUSingleMakeupModel *modle2 = [FUSingleMakeupModel new];
    modle2.makeType = 2;
    modle2.namaBundleType = SUBMAKEUPTYPE_eyeBrow;
    modle2.namaBundle = dic[@"tex_brow"];
    modle2.brow_warp = [dic[@"brow_warp"] intValue];
    modle2.brow_warp_type = [dic[@"brow_warp_type"] intValue];
    modle2.namaValueType = MAKEUPTYPE_eyeBrow;
    modle2.value  = [dic[@"makeup_intensity_eyeBrow"] floatValue];
    modle2.colorStr = @"makeup_eyeBrow_color";
    modle2.colorStrV = dic[@"makeup_eyeBrow_color"];

    /* 眼影 */
    FUSingleMakeupModel *modle3 = [FUSingleMakeupModel new];
    modle3.makeType = 3;
    modle3.namaBundleType = SUBMAKEUPTYPE_eyeShadow;
    modle3.namaBundle = dic[@"tex_eye"];
    modle3.namaValueType = MAKEUPTYPE_eyeShadow;
    modle3.value  = [dic[@"makeup_intensity_eye"] floatValue];
    modle3.colorStr = @"makeup_eye_color";
    modle3.colorStrV = dic[@"makeup_eye_color"];

    /* 眼线 */
    FUSingleMakeupModel *modle4 = [FUSingleMakeupModel new];
    modle4.makeType = 4;
    modle4.namaBundleType = SUBMAKEUPTYPE_eyeLiner;
    modle4.namaBundle = dic[@"tex_eyeLiner"];
    modle4.namaValueType = MAKEUPTYPE_eyeLiner;
    modle4.value  = [dic[@"makeup_intensity_eyeLiner"] floatValue];
    modle4.colorStr = @"makeup_eyeLiner_color";
    modle4.colorStrV = dic[@"makeup_eyeLiner_color"];

    /* 睫毛 */
    FUSingleMakeupModel *modle5 = [FUSingleMakeupModel new];
    modle5.makeType = 5;
    modle5.namaBundleType = SUBMAKEUPTYPE_eyeLash;
    modle5.namaBundle = dic[@"tex_eyeLash"];
    modle5.namaValueType = MAKEUPTYPE_eyelash;
    modle5.value  = [dic[@"makeup_intensity_eyelash"] floatValue];
    modle5.colorStr = @"makeup_eyelash_color";
    modle5.colorStrV = dic[@"makeup_eyelash_color"];

    /* 美瞳 */
    FUSingleMakeupModel *modle6 = [FUSingleMakeupModel new];
    modle6.makeType = 6;
    modle6.namaBundleType = SUBMAKEUPTYPE_pupil;
    modle6.namaBundle = dic[@"tex_pupil"];
    modle6.namaValueType = MAKEUPTYPE_pupil;
    modle6.value  = [dic[@"makeup_intensity_pupil"] floatValue];
    modle6.colorStr = @"makeup_pupil_color";
    modle6.colorStrV = dic[@"makeup_pupil_color"];

    /* 粉底 */
    FUSingleMakeupModel *modle7 = [FUSingleMakeupModel new];
    modle7.makeType = 7;
    modle7.namaBundleType = SUBMAKEUPTYPE_foundation;
    modle7.namaBundle = dic[@"tex_foundation"];
    modle7.namaValueType = MAKEUPTYPE_foundation;
    modle7.value  = [dic[@"makeup_intensity_foundation"] floatValue];
    modle7.colorStr = @"makeup_foundation_color";
    modle7.colorStrV = dic[@"makeup_foundation_color"];

    /* 高光 */
    FUSingleMakeupModel *modle8 = [FUSingleMakeupModel new];
    modle8.makeType = 8;
    modle8.namaBundleType = SUBMAKEUPTYPE_highlight;
    modle8.namaBundle = dic[@"tex_highlight"];
    modle8.namaValueType = MAKEUPTYPE_highlight;
    modle8.value  = [dic[@"makeup_intensity_highlight"] floatValue];
    modle8.colorStr = @"makeup_highlight_color";
    modle8.colorStrV = dic[@"makeup_highlight_color"];

    /* 阴影 */
    FUSingleMakeupModel *modle9 = [FUSingleMakeupModel new];
    modle9.makeType = 9;
    modle9.namaBundleType = SUBMAKEUPTYPE_shadow;
    modle9.namaBundle = dic[@"tex_shadow"];
    modle9.namaValueType = MAKEUPTYPE_shadow;
    modle9.value  = [dic[@"makeup_intensity_shadow"] floatValue];
    modle9.colorStr = @"makeup_shadow_color";
    modle9.colorStrV = dic[@"makeup_shadow_color"];
        
    _makeups = [NSMutableArray arrayWithObjects:modle0,modle1,modle2,modle3,modle4,modle5,modle6,modle7,modle8,modle9, nil];
}


-(id)copyWithZone:(NSZone *)zone{
    FUSingleMakeupModel *model = [[FUSingleMakeupModel allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}
 
-(id)mutableCopyWithZone:(NSZone *)zone{
    FUSingleMakeupModel *model = [[FUSingleMakeupModel allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}



@end
