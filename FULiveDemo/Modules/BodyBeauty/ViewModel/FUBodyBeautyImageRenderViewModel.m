//
//  FUBodyBeautyImageRenderViewModel.m
//  FULiveDemo
//
//  Created by Cursor on 2026/6/30.
//

#import "FUBodyBeautyImageRenderViewModel.h"
#import "FUBodyBeautyComponentManager.h"

@implementation FUBodyBeautyImageRenderViewModel

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
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
