//
//  FUAvatarPresenter.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define defaultAvatarNum 1

NS_ASSUME_NONNULL_BEGIN

@class FUWholeAvatarModel;
@class FUAvatarModel;

@interface FUAvatarPresenter : NSObject
+ (FUAvatarPresenter *)shareManager;

/* 单个完整扭脸模型 */
@property (nonatomic, strong) NSMutableArray<FUAvatarModel *> *dataDataArray;  /**道具分类数组*/
/* 所有完整扭脸模型 */
@property (nonatomic, strong) NSMutableArray<FUWholeAvatarModel *> *wholeAvatarArray;  /**道具分类数组*/


-(void)addWholeAvatar:(NSMutableArray<FUAvatarModel *> *)array icon:(UIImage *)image;

-(void)dataWriteToFile;
/* 展示一个模式 */
-(void)showAProp:(FUWholeAvatarModel *)wholeAvatarModel;
    
/* 保存图片 */
+ (NSString *)saveImg:(UIImage *)image withVideoMid:(NSString *)imgName;
    /* 获取图片 */
+ (UIImage *)loadImageWithVideoMid:(NSString *)imgName;

/* 重置人脸初始化模型 */
-(void)restAvatarModelData;

@end

NS_ASSUME_NONNULL_END
