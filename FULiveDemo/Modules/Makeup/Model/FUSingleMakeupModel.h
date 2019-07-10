//
//  FUSingleMakeupModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 妆容类型

 - FUMakeupModelTypeLip: 口红
 - FUMakeupModelTypeBlusher: 腮红
 - FUMakeupModelTypeBrow: 眉毛
 - FUMakeupModelTypeEye: 眼影
 - FUMakeupModelTypeEyeLiner: 眼线
 - FUMakeupModelTypeEyeLash: 睫毛
 - FUMakeupModelTypePupil: 美瞳
 - FUMakeupModelTypeFoundation: 粉底
 - FUMakeupModelTypeHighlight: 高光
 - FUMakeupModelTypeShadow: 阴影
 */
typedef NS_ENUM(NSUInteger, FUMakeupModelType) {
    FUMakeupModelTypeLip = 0,
    FUMakeupModelTypeBlusher,
    FUMakeupModelTypeBrow,
    FUMakeupModelTypeEye,
    FUMakeupModelTypeEyeLiner,
    FUMakeupModelTypeEyeLash,
    FUMakeupModelTypePupil,
    FUMakeupModelTypeFoundation,
    FUMakeupModelTypeHighlight,
    FUMakeupModelTypeShadow,
};

@interface FUSingleMakeupModel : NSObject

/* 妆容类型 */
@property (nonatomic, assign) FUMakeupModelType makeType;
/* icon */
@property (nonatomic, copy) NSString* iconStr;
/* 加载到部位的图片 */
@property (nonatomic, copy) NSString* namaImgStr;
/* 妆容键值 */
@property (nonatomic, copy) NSString* namaTypeStr;
/* 妆容程度值键值 */
@property (nonatomic, copy) NSString* namaValueStr;
/* 妆容程度值 */
@property (nonatomic, assign) float  value;
/* 妆容颜色键值 */
@property (nonatomic, copy) NSString* colorStr;
/* 妆容颜色 */
@property (nonatomic, strong) NSArray* colorStrV;
/* 一些妆容标题 */
@property (nonatomic, copy) NSString *title;

/* 口红相关 */
@property (nonatomic, copy) NSString* colorStr2;
@property (nonatomic, strong) NSArray* colorStr2V;
@property (nonatomic, assign) int is_two_color;
@property (nonatomic, assign) int lip_type;

/* 眼影相关 */
@property (nonatomic, copy) NSString *tex_eye2;
@property (nonatomic, copy) NSString *tex_eye3;

/* 眉毛相关 */
@property (nonatomic, assign) int brow_warp;
//0柳叶眉  1上挑眉  2一字眉  3英气眉  4远山眉  5标准眉  6扶形眉  7剑眉  8日常风  9日系风
@property (nonatomic, assign) int brow_warp_type;

/* 样式所有可选的颜色 */
@property (nonatomic, strong) NSArray <NSArray *>* colors;
@property (nonatomic, assign) int defaultColorIndex;

@end

NS_ASSUME_NONNULL_END
