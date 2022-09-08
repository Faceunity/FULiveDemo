//
//  FUStickerViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/15.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUStickerViewModel.h"
#import "FULocalDataManager.h"

@interface FUStickerViewModel ()

@property (nonatomic, strong) FUSticker *currentSticker;

@end

@implementation FUStickerViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUSticker"];
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

- (NSArray<NSString *> *)stickerItems {
    if (!_stickerItems) {
        _stickerItems = @[@"resetItem", @"CatSparks", @"fu_zh_fenshu", @"sdlr", @"xlong_zh_fu", @"newy1", @"redribbt", @"DaisyPig", @"sdlu"];
    }
    return _stickerItems;
}

@end
