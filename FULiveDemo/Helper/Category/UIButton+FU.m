//
//  UIButton+FU.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import "UIButton+FU.h"
#import <objc/runtime.h>

static char kFUDelayActionHandler, kFUDelayTime;

@interface UIButton ()

@property (nonatomic, copy) void (^delayActionHandler)(void);
@property (nonatomic, assign) NSTimeInterval delayTime;

@end

@implementation UIButton (FU)

- (void)addCommonActionWithDelay:(NSTimeInterval)delay actionHandler:(void (^)(void))handler {
    self.delayTime = delay;
    self.delayActionHandler = handler;
    [self addTarget:self action:@selector(delayAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delayAction:(UIButton *)sender {
    if (self.delayActionHandler) {
        self.delayActionHandler();
        self.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.enabled = YES;
        });
    }
}

- (void)setDelayActionHandler:(void (^)(void))delayActionHandler {
    objc_setAssociatedObject(self, &kFUDelayActionHandler, delayActionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))delayActionHandler {
    return objc_getAssociatedObject(self, &kFUDelayActionHandler);
}

- (NSTimeInterval)delayTime {
    return [objc_getAssociatedObject(self, &kFUDelayTime) doubleValue];
}

- (void)setDelayTime:(NSTimeInterval)delayTime {
    objc_setAssociatedObject(self, &kFUDelayTime, @(delayTime), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
