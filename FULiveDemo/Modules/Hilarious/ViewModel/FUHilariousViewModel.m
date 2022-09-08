//
//  FUHilariousViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHilariousViewModel.h"

@interface FUHilariousViewModel ()

@property (nonatomic, strong) FUSticker *currentSticker;

@end

@implementation FUHilariousViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUHilarious"];
    if (!self.currentSticker) {
        [[FURenderKit shareRenderKit].stickerContainer addSticker:sticker completion:completion];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.currentSticker withSticker:sticker completion:completion];
    }
    self.currentSticker = sticker;
}

- (void)releaseItem {
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    self.currentSticker = nil;
}

- (NSArray<NSString *> *)hilariousItems {
    if (!_hilariousItems) {
        _hilariousItems = @[@"resetItem", @"big_head_facewarp1", @"big_head_facewarp2", @"big_head_facewarp4", @"big_head_facewarp5", @"big_head_facewarp6", @"big_head_facewarp3"];
    }
    return _hilariousItems;
}

@end
