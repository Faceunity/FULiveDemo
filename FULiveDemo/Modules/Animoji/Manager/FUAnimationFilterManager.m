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
    [FURenderKit shareRenderKit].comicFilter = self.comicFilter;
}

- (void)releaseItem {
    [FURenderKit shareRenderKit].comicFilter = nil;
    _comicFilter = nil;
}

- (FUComicFilter *)comicFilter {
    if (!_comicFilter) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fuzzytoonfilter" ofType:@"bundle"];
        _comicFilter = [[FUComicFilter alloc] initWithPath:path name:@"fuzzytoonfilter"];
    }
    return _comicFilter;
}

- (NSArray *)comicFilterItems {
    if (!_comicFilterItems) {
        _comicFilterItems = @[@"resetItem", @"fuzzytoonfilter1", @"fuzzytoonfilter2", @"fuzzytoonfilter3", @"fuzzytoonfilter4", @"fuzzytoonfilter5", @"fuzzytoonfilter6", @"fuzzytoonfilter7", @"fuzzytoonfilter8"];
    }
    return _comicFilterItems;
}

@end
