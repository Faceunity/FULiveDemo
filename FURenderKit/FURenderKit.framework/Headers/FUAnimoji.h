//
//  FUAnimoji.h
//  FURenderKit
//
//  Created by Chen on 2021/1/28.
//

#import "FUSticker.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  FUAnimoji 表情
 */
@interface FUAnimoji : FUSticker
/**
 * NO 不跟随，YES 跟随
 */
@property (nonatomic, assign) BOOL flowEnable;

@end

NS_ASSUME_NONNULL_END
