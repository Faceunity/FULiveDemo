//
//  FUMakeupViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/7.
//

#import "FUMakeupViewModel.h"

@implementation FUMakeupViewModel

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleMakeup;
}

- (BOOL)supportMediaRendering {
    if ([[FURenderKitManager sharedManager].configurations[@"美妆导图"] boolValue]) {
        return YES;
    }
    return NO;
}

@end
