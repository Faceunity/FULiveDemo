//
//  FUYituItemModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUYituItemModel.h"

@implementation FUYituItemModel
+(FUYituItemModel *)getClassTitle:(NSString *)title imageStr:(NSString *)iamgeName type:(FUFacialFeaturesType)type{
    FUYituItemModel *model = [[FUYituItemModel alloc] init];
    model.title = title;
    model.imageName = iamgeName;
    model.type = type;
    return model;
}
@end
