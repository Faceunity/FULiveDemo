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
@property (nonatomic, strong) NSArray *deviceOrientationItems;
//通用的道具贴纸
@property (nonatomic, strong) FUSticker *curSticker;
@end

@implementation FUStickerManager

@synthesize selectedItem;
@synthesize type;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stickTipDic = [FULocalDataManager stickerTipsJsonData];
        /* 带屏幕方向的道具 */
        self.deviceOrientationItems = @[@"ctrl_rain",@"ctrl_snow",@"ctrl_flower",@"ssd_thread_six",@"ssd_thread_cute"];
    }
    return self;
}

+ (int)aiHandDistinguishNums {
    return [FUAIKit aiHandDistinguishNums];
}

/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName
      completion:(void (^ __nullable)(BOOL finished))completion {
    self.selectedItem = itemName ;
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
    NSString *itemName = self.selectedItem;
    NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
    switch (self.type) {
        case FUStickerPropType: {
            FUSticker *newItem = [[FUSticker alloc] initWithPath:path name:@"sticker"];
            [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.curSticker withSticker:newItem completion:completion];
            self.curSticker = newItem;
        }
            break;
        case FUGestureType: {
            FUGesture *item = [[FUGesture alloc] initWithPath:path name:@"gesture"];
            if ([itemName isEqualToString:@"ssd_thread_korheart"]) {//比心道具手动调整下
                item.handOffY = -100;
            }
            [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.gestureItem withSticker:item completion:completion];
            self.gestureItem = item;
        }
            break;
        default:
            break;
    }
}

- (NSString *)getStickTipsWithItemName:(NSString *)itemName {
    if ([self.stickTipDic.allKeys containsObject:itemName]) {
        return self.stickTipDic[itemName];
    }
    return nil;
}

//释放item，内部会自动清除相关资源文件
- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        switch (self.type) {
            case FUStickerPropType:
                self.curSticker = nil;
                break;
            case FUGestureType:
                self.gestureItem = nil;
                break;
            default:
                break;
        }
        [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    });
}
@end
