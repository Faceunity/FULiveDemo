//
//  FUStyleModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleModel.h"

@implementation FUStyleSkinModel

@end

@implementation FUStyleShapeModel

@end

@implementation FUStyleMakeupModel

@end

@implementation FUStyleModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"skins" : [FUStyleSkinModel class],
        @"shapes" : [FUStyleShapeModel class]
    };
}

@end
