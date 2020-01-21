//
//  FULightModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FULightModel.h"
@implementation FUSingleLightMakeupModel : NSObject


@end
@implementation FULightModel : NSObject 

+ (NSDictionary *)objectClassInArray{
    return @{
             @"makeups" : @"FUSingleLightMakeupModel"
             };
}


@end
