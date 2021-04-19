//
//  FUGLContext.h
//  FUStaLiteDemo
//
//  Created by ly-Mac on 2019/8/9.
//  Copyright © 2019 ly-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUGLContext : NSObject

@property (nonatomic,strong, readonly) EAGLContext *currentGLContext;

+ (instancetype)shareGLContext;

- (void)setCustomGLContext:(EAGLContext *)customGLContext;

- (void)glQueueAsync:(dispatch_block_t)block;

- (void)glQueueSync:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
