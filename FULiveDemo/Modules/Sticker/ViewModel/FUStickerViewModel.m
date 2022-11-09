//
//  FUStickerViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/26.
//

#import "FUStickerViewModel.h"

@implementation FUStickerViewModel

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleSticker;
}

- (BOOL)supportMediaRendering {
    return YES;
}

- (BOOL)supportPresetSelection {
    return NO;
}

@end
