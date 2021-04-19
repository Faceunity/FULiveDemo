//
//  FUSingleMakeupModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUSingleMakeupModel.h"
#import <objc/runtime.h>


@implementation FUSingleMakeupModel
@synthesize makeType, namaBundle, namaValueType, value, colorStr, colorStrV, is_two_color, lip_type, realValue;

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
