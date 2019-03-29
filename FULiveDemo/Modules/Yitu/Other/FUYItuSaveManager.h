//
//  FUYItuSaveManager.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/18.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//
//  数据，资源管理类
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FUYituModel.h"
//默认模板数
#define defaultNum 3

NS_ASSUME_NONNULL_BEGIN
@interface FUYItuSaveManager : NSObject

+ (FUYItuSaveManager *)shareManager;

@property (nonatomic, strong) NSMutableArray<FUYituModel *> *dataDataArray;  /**道具分类数组*/


+(void)dataWriteToFile;
+(NSArray <FUYituModel *>*)loadDataArray;

+ (NSString *)saveImg:(UIImage *)image withVideoMid:(NSString *)imgName;

+ (UIImage *)loadImageWithVideoMid:(NSString *)imgName;
@end

NS_ASSUME_NONNULL_END
