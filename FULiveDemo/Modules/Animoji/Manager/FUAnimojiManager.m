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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadAntiAliasing];
    }
    return self;
}

//加载抗锯齿道具
- (void)loadAntiAliasing {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa" ofType:@"bundle"];
    [FURenderKit shareRenderKit].antiAliasing = [[FUItem alloc] initWithPath:path name:@"antiAliasing"];
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
    NSString *path = [[NSBundle mainBundle] pathForResource:itemName ofType:@"bundle"];
    FUAnimoji *newItem = [[FUAnimoji alloc] initWithPath:path name:@"animoji"];
    [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.animoji withSticker:newItem completion:nil];
    self.animoji = newItem;
}

- (void)releaseItem {
    [[FURenderKit shareRenderKit].stickerContainer removeSticker:self.animoji completion:nil];;
    _animoji = nil;
}

@end
