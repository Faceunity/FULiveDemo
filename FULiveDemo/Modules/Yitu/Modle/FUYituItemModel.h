//
//  FUYituItemModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/* 五官类型 */
typedef NS_ENUM(NSUInteger, FUFacialFeaturesType) {
    FUFacialFeaturesLeye  =  0,
    FUFacialFeaturesReye  =  1,
    FUFacialFeaturesNose  =  2,
    FUFacialFeaturesMouth =  3,
    FUFacialFeatureLbrow  =  4,
    FUFacialFeaturesRbrow =  5,
};
typedef NS_ENUM(NSUInteger, FUFaceType) {
    FUFaceTypeComicBoy = 0,
    FUFaceTypeComicGirl = 1,
    FUFaceTypeMengBan = 2,
    FUFaceTypeRealism = 3
};

@interface FUYituItemModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, assign) FUFacialFeaturesType type;
@property (nonatomic, assign) FUFaceType faceType;
@property (nonatomic, assign) CGAffineTransform Transform;
@property (nonatomic, assign) CGPoint itemCenter;
@property (nonatomic, strong) NSArray *points;

+(FUYituItemModel *)getClassTitle:(NSString *)title imageStr:(NSString *)iamgeName faceType:(FUFaceType)faceType subType:(FUFacialFeaturesType)type;

@end

NS_ASSUME_NONNULL_END
