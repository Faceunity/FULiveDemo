//
//  FULightMakeupModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import "FULightMakeupModel.h"

@implementation FUSingleLightMakeupModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"type" : @"makeType",
        @"bundleName" : @"namaBundle",
        @"colorsArray" : @"colorStrV",
        @"lipType" : @"lip_type",
        @"isTwoColorLipstick" : @"is_two_color"
    };
}

@end

@implementation FULightMakeupModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"makeups" : @"FUSingleLightMakeupModel"
    };
}

@end
