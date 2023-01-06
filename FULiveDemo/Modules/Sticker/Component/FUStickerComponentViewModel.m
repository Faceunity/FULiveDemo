//
//  FUStickerComponentViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/20.
//

#import "FUStickerComponentViewModel.h"

#import <FURenderKit/FURenderKit.h>

@interface FUStickerComponentViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *stickerItems;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) FUSticker *currentSticker;

@end

@implementation FUStickerComponentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedIndex = 1;
    }
    return self;
}

- (void)loadStickerAtIndex:(NSUInteger)index completion:(void (^)(void))completion {
    if (index < 0 || index >= self.stickerItems.count) {
        return;
    }
    _selectedIndex = index;
    if (index == 0) {
        // 取消
        [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
        self.currentSticker = nil;
        !completion ?: completion();
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.stickerItems[index] ofType:@"bundle"];
        FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUSticker"];
        if (self.currentSticker) {
            [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.currentSticker withSticker:sticker completion:^{
                self.currentSticker = sticker;
                !completion ?: completion();
            }];
        } else {
            [[FURenderKit shareRenderKit].stickerContainer addSticker:sticker completion:^{
                self.currentSticker = sticker;
                !completion ?: completion();
            }];
        }
    }
}

#pragma mark - Getters

- (NSArray<NSString *> *)stickerItems {
    if (!_stickerItems) {
        _stickerItems = @[@"reset_item", @"CatSparks", @"fu_zh_fenshu", @"sdlr", @"xlong_zh_fu", @"newy1", @"redribbt", @"DaisyPig", @"sdlu"];
    }
    return _stickerItems;
}

@end
