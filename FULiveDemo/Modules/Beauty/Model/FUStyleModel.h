//
//  FUStyleModel.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/23.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBeautyModel.h"
#import "FUBaseUIModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * 风格其实就是 美肤、美型、滤镜三种组合的合集
 */
@interface FUStyleModel : FUBeautyModel
@property (nonatomic, strong) NSArray <FUBeautyModel *> *skins;
@property (nonatomic, strong) NSArray <FUBeautyModel *> *shapes;
@property (nonatomic, strong) FUBeautyModel *filter;

+ (FUStyleModel *)defaultParams;

- (void)styleWithType:(FUBeautyStyleType)type;
@end

NS_ASSUME_NONNULL_END
