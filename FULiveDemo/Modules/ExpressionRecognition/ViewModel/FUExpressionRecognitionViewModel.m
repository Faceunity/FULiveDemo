//
//  FUExpressionRecognitionViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUExpressionRecognitionViewModel.h"

@interface FUExpressionRecognitionViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *expressionRecognitionItems;

@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *expressionRecognitionTips;

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
        _expressionRecognitionItems = @[@"reset_item", @"future_warrior", @"jet_mask", @"sdx2", @"luhantongkuan_ztt_fu", @"qingqing_ztt_fu", @"xiaobianzi_zh_fu", @"xiaoxueshen_ztt_fu"];
    }
    return _expressionRecognitionItems;
}

- (NSDictionary<NSString *,NSString *> *)expressionRecognitionTips {
    if (!_expressionRecognitionTips) {
        _expressionRecognitionTips = @{
            @"future_warrior" : @"张嘴试试",
            @"jet_mask" : @"鼓腮帮子",
            @"sdx2" : @"皱眉触发",
            @"luhantongkuan_ztt_fu" : @"眨一眨眼",
            @"qingqing_ztt_fu" : @"嘟嘴试试",
            @"xiaobianzi_zh_fu" : @"微笑触发",
            @"xiaoxueshen_ztt_fu" : @"吹气触发"
        };
    }
    return _expressionRecognitionTips;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleExpressionRecognition;
}

@end
