//
//  FUCombinationMakeupModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/11.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUCombinationMakeupModel.h"

@implementation FUCombinationMakeupModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"icon" : @"imageStr",
        @"bundleName" : @"makeupBundle"
    };
}

@end
