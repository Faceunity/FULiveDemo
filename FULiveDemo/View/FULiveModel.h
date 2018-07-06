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
    FULiveModelTypeAnimoji,
    FULiveModelTypeItems,
    FULiveModelTypeARMarsk,
    FULiveModelTypeFaceChange,
    FULiveModelTypeExpressionRecognition,
    FULiveModelTypeMusicFilter,
    FULiveModelTypeBGSegmentation,
    FULiveModelTypeGestureRecognition,
    FULiveModelTypeHahaMirror,
    FULiveModelTypePortraitLighting,
    FULiveModelTypePortraitDrive,
};

@interface FULiveModel : NSObject

@property (nonatomic, assign) NSInteger maxFace ;

@property (nonatomic, copy) NSString *title ;

@property (nonatomic, assign) BOOL enble ;

@property (nonatomic, assign) FULiveModelType type ;

@property (nonatomic, assign) NSArray *modules ;

@property (nonatomic, strong) NSArray *items ;
@end
