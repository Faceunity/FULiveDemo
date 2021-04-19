//
//  FUAnimationFIlterItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/13.
//

#import "FUItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUComicFilter : FUItem
/**
 * 范围 0.0 - 7.0，对应不同的动漫滤镜效果
 */
@property (nonatomic, assign) double style;
@end

NS_ASSUME_NONNULL_END
