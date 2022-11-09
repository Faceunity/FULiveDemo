//
//  FUBeautyViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/26.
//

#import "FUBeautyViewModel.h"

@implementation FUBeautyViewModel

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleBeauty;
}

- (BOOL)supportMediaRendering {
    return YES;
}

- (BOOL)supportPresetSelection {
    return YES;
}

@end
