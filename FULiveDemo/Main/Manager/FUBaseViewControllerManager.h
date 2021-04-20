//
//  FUBaseViewControllerManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/24.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUKeysDefine.h>
#import <FURenderKit/FUBeauty.h>
#import "FUBeautyModel.h"
#import "FUBeautyDefine.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * 处理美颜的业务逻辑和数据类
 */
@interface FUBaseViewControllerManager : FUMetaManager
/* 滤镜参数 */
@property (nonatomic, strong, readonly) NSArray<FUBeautyModel *> *filters;
/* 美肤参数 */
@property (nonatomic, strong, readonly) NSArray<FUBeautyModel *> *skinParams;
/* 美型参数 */
@property (nonatomic, strong, readonly) NSArray<FUBeautyModel *> *shapeParams;

@property (nonatomic, strong) FUBeautyModel *seletedFliter;

@property (nonatomic, strong) FUBeauty *beauty;

- (void)setSkin:(double)value forKey:(FUBeautifySkin)key;

- (void)setShap:(double)value forKey:(FUBeautifyShape)key;

- (void)setFilterkey:(FUFilter)filterKey;

- (void)setDefaultRotationMode:(int)orientation;

- (void)setFaceProcessorDetectMode:(int)mode;

/**
 判断是不是默认美型参数
 */
-(BOOL)isDefaultShapeValue;
/* 判断是不是默认美肤 */
-(BOOL)isDefaultSkinValue;

// 默认美颜参数
- (void)resetDefaultParams:(FUBeautyDefine)type;
@end

NS_ASSUME_NONNULL_END
