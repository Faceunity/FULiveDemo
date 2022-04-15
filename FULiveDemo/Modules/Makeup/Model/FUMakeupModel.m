//
//  FUMakeupModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/22.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMakeupModel.h"

@implementation FUMakeupModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"singleMakeups" : @"sgArr"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"singleMakeups" : @"FUSingleMakeupModel"
    };
}

@end
