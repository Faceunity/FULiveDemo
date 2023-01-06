//
//  FUHilariousViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHilariousViewModel.h"

@interface FUHilariousViewModel ()

@property (nonatomic, strong) FUSticker *currentItem;

@property (nonatomic, copy,) NSArray<NSString *> *hilariousItems;

@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *hilariousTips;

@end

@implementation FUHilariousViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUHilarious"];
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

- (NSArray<NSString *> *)hilariousItems {
    if (!_hilariousItems) {
        _hilariousItems = @[@"reset_item", @"big_head_facewarp1", @"big_head_facewarp2", @"big_head_facewarp4", @"big_head_facewarp5", @"big_head_facewarp6", @"big_head_facewarp3"];
    }
    return _hilariousItems;
}

- (NSDictionary<NSString *,NSString *> *)hilariousTips {
    if (!_hilariousTips) {
        _hilariousTips = @{
            @"big_head_facewarp3" : @"微笑触发"
        };
    }
    return _hilariousTips;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleHilarious;
}

- (CGFloat)captureButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(84);
}

@end
