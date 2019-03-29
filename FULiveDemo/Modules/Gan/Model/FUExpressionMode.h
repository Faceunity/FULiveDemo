//
//  FUGanExpressionMode.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/26.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUExpressionMode : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* imageName;

+(FUExpressionMode *)getClassTitle:(NSString *)title imageStr:(NSString *)imageStr;
@end

NS_ASSUME_NONNULL_END
