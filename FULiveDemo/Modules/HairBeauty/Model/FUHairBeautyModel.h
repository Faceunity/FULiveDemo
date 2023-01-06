//
//  FUHairBeautyModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/26.
//

#import "FURenderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUHairBeautyModel : FURenderModel

@property (nonatomic, copy) NSString *icon;
/// 程度值
@property (nonatomic, assign) double value;
/// 是否渐变色
@property (nonatomic, assign) BOOL isGradient;
/// 颜色索引
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
