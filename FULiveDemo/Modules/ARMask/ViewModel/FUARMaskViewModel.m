//
//  FUARMaskViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUARMaskViewModel.h"

@interface FUARMaskViewModel ()

@property (nonatomic, strong) FUSticker *currentSticker;

@end

@implementation FUARMaskViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUARMask"];
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

- (NSArray<NSString *> *)maskItems {
    if (!_maskItems) {
        _maskItems = @[@"resetItem", @"bluebird", @"lanhudie", @"fenhudie", @"tiger_huang", @"tiger_bai", @"baozi", @"tiger", @"xiongmao"];
    }
    return _maskItems;
}

@end
