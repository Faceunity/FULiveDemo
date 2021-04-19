//
//  FUPositionInfo.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/2.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUPositionInfoType) {
    FUPositionInfoTypeSlimming = 0,
    FUPositionInfoTypeLegged = 1,
    FUPositionInfoTypeWaist = 2,
    FUPositionInfoTypeshoulder = 3,
    FUPositionInfoTypeHip = 4,
    FUPositionInfoTypeHeadSlim = 5,
    FUPositionInfoTypeLegSlim = 6
};

@interface FUPositionInfo : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, assign) FUPositionInfoType type;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) BOOL isSel;
@property (nonatomic, copy) NSString* bundleKey;


@end

NS_ASSUME_NONNULL_END
