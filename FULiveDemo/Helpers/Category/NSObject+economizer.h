//
//  NSObject+economizer.h
//  ttttt
//
//  Created by Chen on 2021/3/15.
//

#import <Foundation/Foundation.h>
/**
 * throttle 预先设定一个执行周期，当调用动作的时刻大于等于执行周期则执行该动作，然后进入下一个新的时间周期
 * debounce 当调用动作触发一段时间后，才会执行该动作，若在这段时间间隔内又调用此动作则将重新计算时间间隔
 */
typedef NS_ENUM(NSUInteger, CONTROLLTYPE) {
    CONTROLLTYPE_throttle,
    CONTROLLTYPE_debounce,
};

typedef void(^ControlEventBlock) (void);

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (economizer)
@property (nonatomic, assign) CONTROLLTYPE type;

- (void)controlEventWithInterval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue controlEventBlock:(ControlEventBlock)block;
@end

NS_ASSUME_NONNULL_END
