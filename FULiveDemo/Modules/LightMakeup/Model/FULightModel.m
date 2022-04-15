//
//  FULightModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FULightModel.h"

@implementation FUSingleLightMakeupModel : NSObject

@synthesize bundleName, value, realValue, colorsArray, isTwoColorLip, lipType;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"type" : @"makeType",
        @"bundleName" : @"namaBundle",
        @"colorsArray" : @"colorStrV",
        @"lipType" : @"lip_type",
        @"isTwoColorLip" : @"is_two_color"
    };
}

@end

@implementation FULightModel : NSObject

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"makeups" : @"FUSingleLightMakeupModel"
    };
}

@end
