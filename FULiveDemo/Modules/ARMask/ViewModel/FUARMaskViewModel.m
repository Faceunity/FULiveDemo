//
//  FUARMaskViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUARMaskViewModel.h"

@interface FUARMaskViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *maskItems;

@property (nonatomic, strong) FUSticker *currentItem;

@end

@implementation FUARMaskViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUARMask"];
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

- (NSArray<NSString *> *)maskItems {
    if (!_maskItems) {
        _maskItems = @[@"reset_item", @"bluebird", @"lanhudie", @"fenhudie", @"tiger_huang", @"tiger_bai", @"baozi", @"tiger", @"xiongmao"];
    }
    return _maskItems;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleARMask;
}

@end
