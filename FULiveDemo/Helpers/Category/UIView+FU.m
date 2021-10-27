//
//  UIView+FU.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/8/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "UIView+FU.h"

@implementation UIView (FU)

- (UIViewController *)fu_targetViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
