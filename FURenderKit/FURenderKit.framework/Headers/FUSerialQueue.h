//
//  FUSerialQueue.h
//  FURenderKit
//
//  Created by liuyang on 2021/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUSerialQueue : NSObject

+ (instancetype)queueWithLabel:(NSString *)label;

- (void)sync:(dispatch_block_t)block;

- (void)async:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
