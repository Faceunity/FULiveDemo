//
//  FUPersistentBeautyModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/6/13.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FUBeautyModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUPersistentBeautyModel : NSObject

@property (nonatomic, copy) NSArray<FUBeautyModel *> *beautySkins;
@property (nonatomic, copy) NSArray<FUBeautyModel *> *beautyShapes;
@property (nonatomic, copy) NSArray<FUBeautyModel *> *beautyFilters;
/// 选中的滤镜索引
@property (nonatomic, assign) NSInteger selectedFilterIndex;
/// 选中的风格推荐索引
@property (nonatomic, assign) NSInteger selectedStyleIndex;

@end

NS_ASSUME_NONNULL_END
