//
//  FULightMakeupModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import "FULightMakeupModel.h"

@implementation FUSingleLightMakeupModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
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

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"makeups" : [FUSingleLightMakeupModel class]
    };
}

@end
