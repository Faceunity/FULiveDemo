//
//  FUGestureRecognitionViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUGestureRecognitionViewModel.h"

@interface FUGestureRecognitionViewModel ()

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
        _gestureRecognitionItems = @[@"resetItem", @"ctrl_rain", @"ctrl_snow", @"ctrl_flower", @"ssd_thread_korheart", @"ssd_thread_six", @"ssd_thread_cute"];
    }
    return _gestureRecognitionItems;
}

@end
