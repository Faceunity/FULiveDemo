//
//  FUBodyBeautyModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FUBodyBeautyParts) {
    FUBodyBeautyPartsSlimming = 0,
    FUBodyBeautyPartsLongLegs,
    FUBodyBeautyPartsWaist,
    FUBodyBeautyPartsShoulder,
    FUBodyBeautyPartsHip,
    FUBodyBeautyPartsHeadSlim,
    FUBodyBeautyPartsLegSlim
};

NS_ASSUME_NONNULL_BEGIN

@interface FUBodyBeautyModel : NSObject

@property (nonatomic, assign) FUBodyBeautyParts parts;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) double defaultValue;
@property (nonatomic, assign) double currentValue;
@property (nonatomic, assign) BOOL defaultValueInMiddle;

@end

NS_ASSUME_NONNULL_END
