//
//  FUGreenScreenViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/1.
//

#import "FUGreenScreenViewModel.h"

@implementation FUGreenScreenViewModel

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleGreenScreen;
}

- (BOOL)supportMediaRendering {
    return YES;
}

- (BOOL)supportPresetSelection {
    return YES;
}

- (FUDetectingParts)detectingParts {
    return FUDetectingPartsNone;
}

@end
