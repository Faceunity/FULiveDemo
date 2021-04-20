//
//  FULightModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FULightModel.h"
@implementation FUSingleLightMakeupModel : NSObject

@synthesize makeType, namaBundle, namaValueType, value, colorStr, colorStrV, is_two_color, lip_type, realValue;

@end

@implementation FULightModel : NSObject 

+ (NSDictionary *)objectClassInArray{
    return @{
             @"makeups" : @"FUSingleLightMakeupModel"
             };
}


@end
