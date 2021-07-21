//
//  FUQualtyStickerManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/31.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUQualityStickerManager.h"
#import "FULiveDefine.h"

#import <FURenderKit/FUQualitySticker.h>

@interface FUQualityStickerManager ()

@property (nonatomic, strong) FUQualitySticker *curStickItem;

@end

@implementation FUQualityStickerManager

/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItemWithModel:(FUStickerModel *)stickModel
              completion:(void (^ __nullable)(BOOL finished))completion {
    NSString *filePath = [[FUStickerBundlesPath stringByAppendingPathComponent:stickModel.tag] stringByAppendingPathComponent:stickModel.itemId];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExist) {
        FUQualitySticker *item = [[FUQualitySticker alloc] initWithPath:filePath name:stickModel.stickerId];
        item.isFlipPoints = stickModel.isMakeupItem;
        item.is3DFlipH = stickModel.is3DFlipH;
        [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.curStickItem withSticker:item completion:^{
            if (completion) {
                completion(YES);
            }
        }];
        self.curStickItem = item;
    } else {
        NSLog(@"精品贴纸道具不存在");
        if (completion) {
            completion(NO);
        }
    }
}

- (void)clickCurrentItem {
    if (!_curStickItem) {
        return;
    }
    [_curStickItem clickToChange];
}

- (void)releaseItem {
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    self.curStickItem = nil;
}
@end
