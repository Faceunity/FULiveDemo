//
//  FUAvatarModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FUAvatarType) {
    FUAvatarTypeHair = 0,
    FUAvatarTypeFace ,
    FUAvatarTypeEye,
    FUAvatarTypeMouth,
    FUAvatarTypeNose
};


NS_ASSUME_NONNULL_BEGIN

@interface FUAvatarColor : NSObject<NSCopying>

@property (nonatomic, assign) double r;
@property (nonatomic, assign) double g;
@property (nonatomic, assign) double b;
@property (nonatomic, assign) NSInteger intensity;
@property (nonatomic, copy) NSString* param;

@end

@interface FUAvatarParam: NSObject<NSCopying>

@property (nonatomic, copy) NSString* paramS;
@property (nonatomic, copy) NSString* paramB;
@property (nonatomic, copy) NSString* icon;
@property (nonatomic, copy) NSString* icon_sel;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) float value;

@property (nonatomic,assign) BOOL haveCustom;
@end


@interface FUBundelModel : NSObject<NSCopying>
@property (nonatomic, copy) NSString* bundleName;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, copy) NSString* color;
@property (nonatomic, strong) NSArray <FUAvatarParam *> *params;

@end


@interface FUAvatarModel : NSObject<NSCopying>

@property (nonatomic, assign) FUAvatarType avatarType;
@property (nonatomic, copy) NSString* title;
@property (nonatomic,assign) BOOL haveCustom;
@property (nonatomic, assign) int colorsSelIndex;
@property (nonatomic, copy) NSString *colorsParam;
@property (nonatomic,strong) NSArray <FUAvatarColor *> *colors;
@property (nonatomic, assign) int bundleSelIndex;
@property (nonatomic, strong) NSArray <FUBundelModel *> *bundles;

@end

NS_ASSUME_NONNULL_END
