//
//  FUMusicFilterViewModel.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMusicFilterViewModel.h"

@interface FUMusicFilterViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *musicFilterItems;

@end

@implementation FUMusicFilterViewModel

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.musicFilterItems.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    if (selectedIndex == 0) {
        [FURenderKit shareRenderKit].musicFilter = nil;
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.musicFilterItems[selectedIndex] ofType:@"bundle"];
        FUMusicFilter *musicFilter = [[FUMusicFilter alloc] initWithPath:path name:@"FUMusicFilter"];
        musicFilter.musicPath = [[NSBundle mainBundle] pathForResource:@"douyin" ofType:@"mp3"];
        [FURenderKit shareRenderKit].musicFilter = musicFilter;
    }
}

- (NSArray *)musicFilterItems {
    if (!_musicFilterItems) {
        _musicFilterItems = @[@"reset_item", @"douyin_01", @"douyin_02"];
    }
    return _musicFilterItems;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleMusicFilter;
}

@end
