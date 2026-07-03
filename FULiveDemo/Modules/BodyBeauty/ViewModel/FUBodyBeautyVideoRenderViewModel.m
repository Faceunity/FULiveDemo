//
//  FUBodyBeautyVideoRenderViewModel.m
//  FULiveDemo
//
//  Created by Cursor on 2026/6/30.
//

#import "FUBodyBeautyVideoRenderViewModel.h"
#import "FUBodyBeautyComponentManager.h"

@implementation FUBodyBeautyVideoRenderViewModel

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [super initWithVideoURL:videoURL];
    if (self) {
        self.detectingParts = FUDetectingPartsHuman;
        [[FUBodyBeautyComponentManager sharedManager] loadBodyBeautyIfNeeded];
    }
    return self;
}

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace | FUAIModelTypeHuman;
}

- (CGFloat)downloadButtonBottomConstant {
    return [FUBodyBeautyComponentManager sharedManager].componentViewHeight;
}

@end
