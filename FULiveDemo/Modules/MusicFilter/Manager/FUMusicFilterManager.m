//
//  FUMusicFilterManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMusicFilterManager.h"

@interface FUMusicFilterManager () {
    NSString *_musicPath;
}
@end

@implementation FUMusicFilterManager
@synthesize selectedItem;
@synthesize type;

- (instancetype)init {
    self = [super init];
    if (self) {
        _musicPath = [[NSBundle mainBundle] pathForResource:@"douyin" ofType:@"mp3"];
    }
    return self;
}

- (void)loadItem:(NSString *)itemName
      completion:(void (^ __nullable)(BOOL finished))completion {
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
    FUMusicFilter *newItem = [[FUMusicFilter alloc] initWithPath:path name:@"music"];
    newItem.musicPath = _musicPath;
    [FURenderKit shareRenderKit].musicFilter = newItem;
    self.musicItem = newItem;
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FURenderKit shareRenderKit].musicFilter = nil;
    });
}
@end
