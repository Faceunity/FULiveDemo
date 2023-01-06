//
//  FURenderModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/16.
//

#import "FURenderModel.h"

@implementation FURenderModel

+ (NSArray *)modelArrayWithJSON:(id)json {
    if (!json) {
        return nil;
    }
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

@end
