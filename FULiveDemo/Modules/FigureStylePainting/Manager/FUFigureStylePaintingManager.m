//
//  FUFigureStylePaintingManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/23.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUFigureStylePaintingManager.h"
#import <FURenderKit/FUAISegment.h>

@interface FUFigureStylePaintingManager ()
//通用的道具贴纸
@property (nonatomic, strong) FUSticker *curSticker;
@property (nonatomic, strong) NSDictionary *stickTipDic;
@end

@implementation FUFigureStylePaintingManager
@synthesize selectedItem;

- (void)dealloc {
    [self releaseItem];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadItem];
    }
    return self;
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
        [self loadItem];
        if (completion) {
            completion(YES);
        }
    } else {
        [self releaseItem];
        if(completion) {
            completion(NO);
        }
    }
}

- (void)changeCameraMode {
    
}

- (void)loadItem {
    NSString *itemName = self.selectedItem;
    NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
    
    FUAISegment *newItem = [[FUAISegment alloc] initWithPath:path name:@"figureStylePainting"];
    [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.curSticker withSticker:newItem completion:nil];
    self.curSticker = newItem;
}


- (void)releaseItem {
    self.curSticker = nil;
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
}


@end
