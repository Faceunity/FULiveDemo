//
//  FUSingleMakeupProtocol.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/18.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FUMakeupDefine.h"


NS_ASSUME_NONNULL_BEGIN

// 美妆业务相关共用的协议属性
@protocol FUSingleMakeupProtocol <NSObject>

@optional
/// 子妆类型
@property (nonatomic, assign) FUSingleMakeupType type;
/// 加载到子妆的图片或者bundle
@property (nonatomic, copy) NSString *bundleName;
/// 妆容程度值
@property (nonatomic, assign) float value;
/// 实际妆容程度值（子妆value * 组合妆value）
@property (nonatomic, assign) float realValue;
/// 妆容颜色
@property (nonatomic, copy) NSArray *colorsArray;
/// 是否双色口红
@property (nonatomic, assign) BOOL isTwoColorLip;
/// 口红类型
@property (nonatomic, assign) NSInteger lipType;

@end

NS_ASSUME_NONNULL_END

