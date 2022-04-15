//
//  FUSingleMakeupModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUSingleMakeupModel.h"

@implementation FUSingleMakeupModel

@synthesize bundleName, value, realValue, colorsArray, isTwoColorLip, lipType;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"type" : @"makeType",
        @"bundleName" : @"namaBundle",
        @"icon" : @"iconStr",
        @"colorsArray" : @"colorStrV",
        @"lipType" : @"lip_type",
        @"isTwoColorLip" : @"is_two_color",
        @"isBrowWarp" : @"brow_warp",
        @"browWarpType" : @"brow_warp_type"
    };
}

@end
