//
//  FUAnimation.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/16.
//

#import "FUItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUAnimation : FUItem

+ (instancetype)animationWithPath:(NSString *)path name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
