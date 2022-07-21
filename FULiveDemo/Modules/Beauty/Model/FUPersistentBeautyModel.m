//
//  FUPersistentBeautyModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/6/13.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUPersistentBeautyModel.h"
#import <MJExtension.h>

@implementation FUPersistentBeautyModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"beautySkins" : @"FUBeautyModel",
        @"beautyShapes" : @"FUBeautyModel",
        @"beautyFilters" : @"FUBeautyModel"
    };
}

@end
