//
//  FUFaceFusionCaptureViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/2.
//

#import "FUFaceFusionCaptureViewModel.h"

@implementation FUFaceFusionCaptureViewModel

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleFaceFusion;
}

- (BOOL)supportMediaRendering {
    return YES;
}

- (BOOL)supportPresetSelection {
    return NO;
}

- (BOOL)supportVideoRecording {
    // 不需要视频录制
    return NO;
}

@end
