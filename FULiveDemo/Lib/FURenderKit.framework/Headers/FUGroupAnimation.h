//
//  FUGroupAnimation.h
//  FURenderKit
//
//  Created by liuyang on 2021/4/22.
//

#import <FURenderKit/FURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUGroupAnimation : FUAnimation

@property (nonatomic, copy, readonly) NSArray<FUItem *> *components;

@property (nonatomic, copy, readonly) NSArray<FUAnimation *> *componentAnimations;

- (instancetype)initWithPath:(NSString *)path name:(nullable NSString *)name components:(nullable NSArray<FUItem *> *)components componentAnimations:(nullable NSArray<FUAnimation *> *)componentAnimations;
+ (instancetype)groupAnimationWithPath:(NSString *)path name:(nullable NSString *)name components:(nullable NSArray<FUItem *> *)components componentAnimations:(nullable NSArray<FUAnimation *> *)componentAnimations;
@end

NS_ASSUME_NONNULL_END
