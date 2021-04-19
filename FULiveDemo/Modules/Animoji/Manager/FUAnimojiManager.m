//
//  FUAnimojiManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUAnimojiManager.h"

@implementation FUAnimojiManager
@synthesize selectedItem;
@synthesize type;

//加载抗锯齿道具
- (void)loadAntiAliasing {
    NSString *path = [[NSBundle mainBundle] pathForResource:[@"fxaa" stringByAppendingString:@".bundle"] ofType:nil];
    dispatch_async(self.loadQueue, ^{
        [FURenderKit shareRenderKit].antiAliasing = [[FUItem alloc] initWithPath:path name:@"antiAliasing"];
    });
}

- (void)loadItem:(NSString *)itemName
      completion:(void (^)(BOOL))completion {
    self.selectedItem = itemName;
    if (itemName != nil && ![itemName isEqual: @"resetItem"])  {
        [self loadItem];
        if (completion) {
            completion(YES);
        }
    } else {
        [self releaseItem];
        if (completion) {
            completion(NO);
        }
    }
}

- (void)loadItem {
    NSString *itemName = self.selectedItem;
    NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
    FUAnimoji *newItem = [[FUAnimoji alloc] initWithPath:path name:@"animoji"];
    [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.animoji withSticker:newItem completion:nil];
    self.animoji = newItem;
}

//释放item，内部会自动清除相关资源文件
- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[FURenderKit shareRenderKit].stickerContainer removeSticker:self.animoji completion:nil];
        self.animoji = nil;
        [FURenderKit shareRenderKit].antiAliasing = nil;
    });
}

@end
