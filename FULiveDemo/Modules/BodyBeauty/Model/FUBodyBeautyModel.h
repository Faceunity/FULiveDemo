//
//  FUBodyBeautyModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import "FURenderModel.h"

typedef NS_ENUM(NSUInteger, FUBodyBeautyParts) {
    FUBodyBeautyPartsSlimming = 0,
    FUBodyBeautyPartsLongLegs,
    FUBodyBeautyPartsWaist,
    FUBodyBeautyPartsShoulder,
    FUBodyBeautyPartsHip,
    FUBodyBeautyPartsHeadSlim,
    FUBodyBeautyPartsLegSlim,
    FUBodyBeautyPartsBreast        // 丰胸，SDK key 待定，范围 0.0-1.0，全机型
};

NS_ASSUME_NONNULL_BEGIN

@interface FUBodyBeautyModel : FURenderModel

@property (nonatomic, assign) FUBodyBeautyParts parts;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) double defaultValue;
@property (nonatomic, assign) double currentValue;
@property (nonatomic, assign) BOOL defaultValueInMiddle;

@end

NS_ASSUME_NONNULL_END
