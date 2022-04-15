//
//  FUStyleModel.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/23.
//  Copyright © 2021 FaceUnity. All rights reserved.
//  风格其实就是 美肤、美型、滤镜三种组合的合集
//

#import "FUBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUStyleModel : FUBeautyModel
/// 美肤效果
@property (nonatomic, copy) NSArray<FUBeautyModel *> *skins;
/// 美型普通效果
@property (nonatomic, copy) NSArray<FUBeautyModel *> *shapes;
/// 滤镜效果
@property (nonatomic, strong) FUBeautyModel *filter;

+ (FUStyleModel *)defaultParams;

- (void)styleWithType:(FUBeautyStyleType)type;

@end

NS_ASSUME_NONNULL_END
