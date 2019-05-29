//
//  FUYituItemModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUYituItemModel.h"
#import <objc/runtime.h>

@implementation FUYituItemModel
+(FUYituItemModel *)getClassTitle:(NSString *)title imageStr:(NSString *)iamgeName faceType:(FUFaceType)faceType subType:(FUFacialFeaturesType)type{
    FUYituItemModel *model = [[FUYituItemModel alloc] init];
    model.title = title;
    model.imageName = iamgeName;
    model.type = type;
    model.faceType = faceType;
    model.Transform = CGAffineTransformIdentity;
    model.itemCenter = CGPointZero;
    return model;
}

//归档序列化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        u_int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *propertyName = property_getName(properties[i]);
            NSString *key = [NSString stringWithUTF8String:propertyName];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
        free(properties);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(properties);
}
@end
