//
//  FUMakeupProtocol.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUMakeUpDefine.h"

NS_ASSUME_NONNULL_BEGIN

//美妆业务相关共用的协议属性
@protocol FUMakeupProtocol <NSObject>

@optional

/** 实际设置的妆容值是由 子妆vaue * 组合妆容程度值，所以用realValue来保存*/
@property (nonatomic, assign) float realValue;

/* 妆容类型 */
@property (nonatomic, assign) MAKEUPTYPE makeType;

/* 加载到部位的图片，可以是图片名称也可以是bundle名称 */
@property (nonatomic, copy) NSString* namaBundle;
/* 妆容程度值键值 sdk参数*/
@property (nonatomic, assign) int namaValueType;
/* 妆容程度值 */
@property (nonatomic, assign) float  value;
/* 妆容颜色键值 sdk参数*/
@property (nonatomic, copy) NSString* colorStr;
/* 妆容颜色 */
@property (nonatomic, strong) NSArray* colorStrV;

/* 口红相关 */
@property (nonatomic, assign) int is_two_color;
@property (nonatomic, assign) int lip_type;
@end

NS_ASSUME_NONNULL_END
