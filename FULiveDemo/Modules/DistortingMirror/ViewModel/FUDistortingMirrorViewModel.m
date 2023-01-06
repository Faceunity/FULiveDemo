//
//  FUDistortingMirrorViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUDistortingMirrorViewModel.h"

@interface FUDistortingMirrorViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *distortingMirrorItems;

@property (nonatomic, strong) FUSticker *currentItem;

@end

@implementation FUDistortingMirrorViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUDistortingMirror"];
    if (!self.currentItem) {
        [[FURenderKit shareRenderKit].stickerContainer addSticker:sticker completion:completion];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.currentItem withSticker:sticker completion:completion];
    }
    self.currentItem = sticker;
}

- (void)releaseItem {
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    self.currentItem = nil;
}

- (NSArray<NSString *> *)distortingMirrorItems {
    if (!_distortingMirrorItems) {
        _distortingMirrorItems = @[@"reset_item", @"facewarp2", @"facewarp3", @"facewarp4", @"facewarp5", @"facewarp6"];
    }
    return _distortingMirrorItems;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleDistortingMirror;
}

- (CGFloat)captureButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(84);
}

@end
