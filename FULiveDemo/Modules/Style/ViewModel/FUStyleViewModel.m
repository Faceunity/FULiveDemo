//
//  FUStyleViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleViewModel.h"

@implementation FUStyleViewModel

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleStyle;
}

- (BOOL)needsLoadingBeauty {
    return NO;
}

- (BOOL)supportMediaRendering {
    return YES;
}

- (BOOL)supportPresetSelection {
    return YES;
}

- (CGFloat)captureButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(134);
}

@end
