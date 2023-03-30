//
//  FUAnimation.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/16.
//

#import "FUItem.h"

@interface FUAnimation : FUItem

+ (instancetype)animationWithPath:(NSString *)path name:(NSString *)name;

- (NSArray *)getAllAnimations;

- (NSArray *)getAllItems;
@end
