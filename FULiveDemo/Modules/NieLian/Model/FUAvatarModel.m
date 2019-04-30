//
//  FUAvatarModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarModel.h"
#import <objc/runtime.h>


@implementation FUAvatarColor
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
    
-(id)copyWithZone:(NSZone *)zone{
    FUAvatarColor *color = [[FUAvatarColor alloc] init];
    color.r = self.r;
    color.g = self.g;
    color.b = self.b;
    color.intensity = self.intensity;
    return color;
}
    
@end


@implementation FUAvatarParam
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
    
-(id)copyWithZone:(NSZone *)zone{
    FUAvatarParam *parm = [[FUAvatarParam alloc] init];
    parm.paramS = self.paramS;
    parm.paramB = self.paramB;
    parm.icon = self.icon;
    parm.icon_sel = self.icon_sel;
    parm.title = self.title;
    parm.value = self.value;
    parm.haveCustom = self.haveCustom;
    return parm;
}

@end
@implementation FUBundelModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"params" : @"FUAvatarParam"
             };
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
    

-(id)copyWithZone:(NSZone *)zone{
    FUBundelModel *bundlelModel = [[FUBundelModel alloc] init];
    bundlelModel.bundleName = self.bundleName;
    bundlelModel.iconName = self.iconName;
    bundlelModel.color = self.color;
    NSMutableArray *params = [NSMutableArray array];
    for (FUAvatarParam *modle in self.params) {
        [params addObject:[modle copy]];
    }
    bundlelModel.params = params;
    
    return bundlelModel;
}

@end

@implementation FUAvatarModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"bundles" : @"FUBundelModel",
             @"colors" : @"FUAvatarColor",
             };
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
    
-(id)copyWithZone:(NSZone *)zone{
    FUAvatarModel *modle = [[FUAvatarModel alloc] init];
    modle.avatarType = self.avatarType;
    modle.title = self.title;
    modle.haveCustom = self.haveCustom;
    modle.colorsSelIndex = self.colorsSelIndex;
    modle.colorsParam = self.colorsParam;
    modle.bundleSelIndex = self.bundleSelIndex;
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *bundles = [NSMutableArray array];
    
    for (FUAvatarColor *modle0 in self.colors) {
        [colors addObject:[modle0 copy]];
    }
    modle.colors = colors;
    
    for (FUAvatarColor *modle0 in self.bundles) {
        [bundles addObject:[modle0 copy]];
    }
    modle.bundles = bundles;
    
    return modle;
}

@end





