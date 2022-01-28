//
//  FUAnimationFilterManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUAnimationFilterManager.h"


@implementation FUAnimationFilterManager
@synthesize selectedItem;
@synthesize type;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.comicFilter.style = -1;
        [self loadItem];
    }
    return self;
}

- (void)loadItem:(NSString *)itemName
            type:(int)type
      completion:(void (^)(BOOL))completion {
    self.selectedItem = itemName;
    if (itemName != nil && ![itemName isEqual: @"resetItem"])  {
        if (!_comicFilter) {
            [self loadItem];
        }
        self.comicFilter.style = type;
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FURenderKit shareRenderKit].comicFilter = self.comicFilter;
    });
}

- (void)dealloc {
    [self releaseItem];
}

- (void)releaseItem {
    _comicFilter = nil;
    [FURenderKit shareRenderKit].comicFilter = nil;
}

- (FUComicFilter *)comicFilter {
    if (!_comicFilter) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fuzzytoonfilter" ofType:@"bundle"];
        _comicFilter = [[FUComicFilter alloc] initWithPath:path name:@"fuzzytoonfilter"];
    }
    return _comicFilter;
}
@end
