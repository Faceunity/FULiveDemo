//
//  FUGanImageModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/27.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUGanImageModel.h"

@implementation FUGanSubImageModel

-(id)copyWithZone:(NSZone *)zone{
    FUGanSubImageModel *model = [[FUGanSubImageModel alloc] init];
    model.subImage = self.subImage;
    model.type = self.type;
    return model;
}

@end

@implementation FUGanImageModel

@end
