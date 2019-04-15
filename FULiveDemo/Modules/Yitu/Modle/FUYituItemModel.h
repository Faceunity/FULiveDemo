//
//  FUYituItemModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/* 五官类型 */
typedef NS_OPTIONS(NSUInteger, FUFacialFeaturesType) {
    FUFacialFeaturesLeye  =  0,
    FUFacialFeaturesReye  =  1,
    FUFacialFeaturesNose  =  2,
    FUFacialFeaturesMouth =  3,
    FUFacialFeatureLbrow  =  4,
    FUFacialFeaturesRbrow =  5,
};


@interface FUYituItemModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, assign) FUFacialFeaturesType type;

+(FUYituItemModel *)getClassTitle:(NSString *)title imageStr:(NSString *)iamgeName type:(FUFacialFeaturesType)type;

@end

NS_ASSUME_NONNULL_END
