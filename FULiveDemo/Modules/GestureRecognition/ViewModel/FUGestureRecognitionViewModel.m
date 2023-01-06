//
//  FUGestureRecognitionViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUGestureRecognitionViewModel.h"

@interface FUGestureRecognitionViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *gestureRecognitionItems;

@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *gestureRecognitionTips;

@property (nonatomic, strong) FUSticker *currentItem;

@end

@implementation FUGestureRecognitionViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUGesture *gesture = [FUGesture itemWithPath:path name:@"FUGestureRecognition"];
    if ([item isEqualToString:@"ssd_thread_korheart"]) {
        // 比心道具手动调整下
        gesture.handOffY = -100;
    }
    if (!self.currentItem) {
        [[FURenderKit shareRenderKit].stickerContainer addSticker:gesture completion:completion];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.currentItem withSticker:gesture completion:completion];
    }
    self.currentItem = gesture;
}

- (void)releaseItem {
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    self.currentItem = nil;
}

- (NSArray<NSString *> *)gestureRecognitionItems {
    if (!_gestureRecognitionItems) {
        _gestureRecognitionItems = @[@"reset_item", @"ctrl_rain_740", @"ctrl_snow_740", @"ctrl_flower_740", @"ssd_thread_korheart", @"ssd_thread_six", @"ssd_thread_cute"];
    }
    return _gestureRecognitionItems;
}

- (NSDictionary<NSString *,NSString *> *)gestureRecognitionTips {
    if (!_gestureRecognitionTips) {
        _gestureRecognitionTips = @{
            @"ssd_thread_thumb" : @"竖个拇指",
            @"ssd_thread_six" : @"比个六",
            @"ssd_thread_cute" : @"双拳靠近脸颊卖萌",
            @"ssd_thread_korheart" : @"单手手指比心",
            @"ctrl_rain_740" : @"推出手掌",
            @"ctrl_snow_740" : @"推出手掌",
            @"ctrl_flower_740" : @"推出手掌"
        };
    }
    return _gestureRecognitionTips;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleGestureRecognition;
}

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace | FUAIModelTypeHuman | FUAIModelTypeHand;
}

- (FUDetectingParts)detectingParts {
    return FUDetectingPartsHand;
}

- (CGFloat)captureButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(84);
}

@end
