//
//  FULightModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUMakeupProtocol.h"
#import "FUSingleMakeupModel.h"//目的导入FUMakeupModelType枚举，这里简单写了

NS_ASSUME_NONNULL_BEGIN
@interface FUSingleLightMakeupModel : NSObject <FUMakeupProtocol>
//轻美妆妆容图片键值
@property (nonatomic, assign) LIGHTMAKEUPIMAGETYPE namaBundleKey;
@end

@interface FULightModel : NSObject
/* 妆容名称 */
@property (copy, nonatomic) NSString *name;
/* icon图片 */
@property (copy, nonatomic) NSString *imageStr;
/* 选中的滤镜 */
@property (nonatomic, strong) NSString *selectedFilter;
/* 选中滤镜的 level*/
@property (nonatomic, assign) double selectedFilterLevel;
/* 记录选中状态 */
@property (assign, nonatomic) BOOL isSel;
/* 整体妆容程度值 */
@property (nonatomic, assign) float value;

/* 组合妆对应所有子妆容 */
@property (nonatomic, strong) NSArray <FUSingleLightMakeupModel *>* makeups;

@end


NS_ASSUME_NONNULL_END
