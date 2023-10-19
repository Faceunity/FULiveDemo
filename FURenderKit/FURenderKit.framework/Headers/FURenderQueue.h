//
//  FURenderQueue.h
//  FURenderKit
//
//  Created by liuyang on 2022/6/8.
//
// 渲染队列，可以使用该队列处理单帧同步效果
//

#import "FUSerialQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface FURenderQueue : FUSerialQueue
+ (void)sync:(dispatch_block_t)block;

+ (void)async:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
