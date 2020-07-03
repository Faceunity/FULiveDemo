//
//  FUPosition.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/2.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUPositionType) {
    FUPositionTypeSlimming = 0,
    FUPositionTypeLegged = 1,
    FUPositionTypeWaist = 2,
    FUPositionTypeshoulder = 3,
    FUPositionTypeHip = 4,
    FUPositionTypeHeadSlim = 5,
    FUPositionTypeLegSlim = 6
};

@interface FUPosition : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, assign) FUPositionType type;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) BOOL isSel;
@property (nonatomic, copy) NSString* bundleKey;


@end

NS_ASSUME_NONNULL_END
