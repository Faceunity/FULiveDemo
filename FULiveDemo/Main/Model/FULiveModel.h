//
//  FULiveModel.h
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FULiveModelType) {
    FULiveModelTypeBeautifyFace             = 0,
    FULiveModelTypeMakeUp,
    FULiveModelTypeItems,
    FULiveModelTypeAnimoji,
    FULiveModelTypeHair,
    FULiveModelTypeARMarsk,
    FULiveModelTypeFaceChange,
    FULiveModelTypePoster,//海报换脸
    FULiveModelTypeExpressionRecognition,
    FULiveModelTypeMusicFilter,
    FULiveModelTypeBGSegmentation,
    FULiveModelTypeGestureRecognition,
    FULiveModelTypeHahaMirror,
//    FULiveModelTypePortraitLighting,
    FULiveModelTypePortraitDrive,
    FULiveModelTypeNieLian,
    FULiveModelTypeYiTu,
    FULiveModelTypeGan,
};

@interface FULiveModel : NSObject

@property (nonatomic, assign) NSInteger maxFace ;

@property (nonatomic, copy) NSString *title ;

@property (nonatomic, assign) BOOL enble ;

@property (nonatomic, assign) FULiveModelType type ;

@property (nonatomic, assign) NSArray *modules ;

@property (nonatomic, strong) NSArray *items ;

@property (nonatomic, assign) int selIndex;
@end
