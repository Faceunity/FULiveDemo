//
//  NSObject+economizer.m
//  ttttt
//
//  Created by Chen on 2021/3/15.
//

#import "NSObject+economizer.h"
#import <sys/time.h>
#import <objc/runtime.h>

static NSString *controlType;

static time_t lastTime = 0;
static time_t duration = 0;
@implementation NSObject (economizer)

- (void)setType:(CONTROLLTYPE)type {
    if (self.type != type) {
        [self reset];
    }
    objc_setAssociatedObject(self, &controlType, @(type), OBJC_ASSOCIATION_ASSIGN);
}


- (CONTROLLTYPE)type {
    return [objc_getAssociatedObject(self, &controlType) unsignedIntValue];
}

- (void)controlEventWithInterval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue controlEventBlock:(ControlEventBlock)block {
    switch (self.type) {
        case CONTROLLTYPE_throttle:
            [[self class] throttleWithTimeInterval:interval queue:queue throttleBlock:block];
            break;
        case CONTROLLTYPE_debounce:
            [[self class] debounceWithTimeInterval:interval queue:queue debounceBlock:block];
            break;
        default:
            [[self class] throttleWithTimeInterval:interval queue:queue throttleBlock:block];
            break;
    }
}

+ (void)throttleWithTimeInterval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue throttleBlock:(ControlEventBlock)throttleBlock {
    time_t curTime = [self uptime];
    if (curTime - lastTime > (size_t)interval * 1000) {
        dispatch_async(queue, ^{
            if (throttleBlock) {
                throttleBlock();
            }
        });
    } else {
        NSLog(@"点击的时间间隔:%f 小于设定的时间间隔:%f",(NSTimeInterval)(curTime - lastTime) / 1000, interval);
    }

    lastTime = curTime;
}

+ (void)debounceWithTimeInterval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue debounceBlock:(ControlEventBlock)debounceBlock {
    time_t curTime = [self uptime];
    if (duration != 0) {
        if (duration - (curTime - lastTime) <= 0) {
            dispatch_async(queue, ^{
                if (debounceBlock) {
                    debounceBlock();
                }
            });
        } else {
            NSLog(@"点击的时间间隔:%f 小于设定的时间间隔:%f 不触发block",(NSTimeInterval)(curTime - lastTime) / 1000, interval);
        }
    } else {
        duration = interval * 1000;
    }
    lastTime = curTime;
}

+ (time_t)uptime {
    struct timeval tv;
    time_t time = 0;
    if (gettimeofday(&tv, NULL) == 0) {
        time_t s = tv.tv_sec * 1000;
        time_t c = tv.tv_usec / 1000;
        time = s + c;
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970: time / 1000];
//        NSLog(@"%@",date);
    }
    
    return time;
}

//重置参数
- (void)reset {
    //重置时间
    lastTime = 0;
    duration = 0;
}
@end
