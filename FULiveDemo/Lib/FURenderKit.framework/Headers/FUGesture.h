//
//  FUGestureItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/28.
//

#import <FURenderKit/FURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 手势道具
 */
@interface FUGesture : FUSticker
//比心道具支持自动调整y轴位置
@property (nonatomic, assign) double handOffY;
@end

NS_ASSUME_NONNULL_END
