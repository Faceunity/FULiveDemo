//
//  FUExpressionRecognitionViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUExpressionRecognitionViewModel.h"

@interface FUExpressionRecognitionViewModel ()

@property (nonatomic, strong) FUSticker *currentItem;

@end

@implementation FUExpressionRecognitionViewModel

- (void)loadItem:(NSString *)item completion:(void (^)(void))completion {
    if (!item) {
        !completion ?: completion();
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:item ofType:@"bundle"];
    FUSticker *sticker = [FUSticker itemWithPath:path name:@"FUExpressionRecognition"];
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

- (NSArray<NSString *> *)expressionRecognitionItems {
    if (!_expressionRecognitionItems) {
        _expressionRecognitionItems = @[@"resetItem", @"future_warrior", @"jet_mask", @"sdx2", @"luhantongkuan_ztt_fu", @"qingqing_ztt_fu", @"xiaobianzi_zh_fu", @"xiaoxueshen_ztt_fu"];
    }
    return _expressionRecognitionItems;
}

@end
