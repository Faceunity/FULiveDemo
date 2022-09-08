//
//  FUStickerManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStickerManager.h"
#import <FURenderKit/FUStickerContainer.h>
#import "FULocalDataManager.h"
#import <FURenderKit/FUStickerContainer.h>


@interface FUStickerManager ()
@property (nonatomic, strong) NSDictionary *stickTipDic;
// @property (nonatomic, strong) NSArray *deviceOrientationItems;
//通用的道具贴纸
@property (nonatomic, strong) FUSticker *curSticker;
@end

@implementation FUStickerManager

@synthesize selectedItem;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stickTipDic = [FULocalDataManager stickerTipsJsonData];
    }
    return self;
}

/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName
      completion:(void (^ __nullable)(BOOL finished))completion {
    self.selectedItem = itemName;
    NSLog(@"道具名称=====%@",itemName);
    if (itemName != nil && ![itemName isEqual: @"resetItem"])  {
        [self loadItemWithCompletion:^{
            if (completion) {
                completion(YES);
            }
        }];
    } else {
        [self releaseItem];
        if(completion) {
            completion(NO);
        }
    }
}


- (void)loadItemWithCompletion:(void(^)(void))completion {
}

- (NSString *)getStickTipsWithItemName:(NSString *)itemName {
    if ([self.stickTipDic.allKeys containsObject:itemName]) {
        return self.stickTipDic[itemName];
    }
    return nil;
}

//释放item，内部会自动清除相关资源文件
- (void)releaseItem {
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
}
@end
