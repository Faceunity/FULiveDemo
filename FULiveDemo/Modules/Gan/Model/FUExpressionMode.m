//
//  FUGanExpressionMode.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/26.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUExpressionMode.h"

@implementation FUExpressionMode

+(FUExpressionMode *)getClassTitle:(NSString *)title imageStr:(NSString *)imageStr{
    FUExpressionMode *modle = [[FUExpressionMode alloc] init];
    modle.title = title;
    modle.imageName = imageStr;
    return modle;
}

@end
