//
//  FUAnimojiViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAnimojiViewController.h"

@interface FUAnimojiViewController ()<FUItemsViewDelegate, FUSegmentBarDelegate>

@property (strong, nonatomic) FUItemsView *itemsView;
/* 动漫滤镜分栏*/
@property (strong, nonatomic) FUSegmentBar *segmentBarView;

@property (nonatomic, strong, readonly) FUAnimojiViewModel *viewModel;

@end

@implementation FUAnimojiViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.segmentBarView];
    [self.view addSubview:self.itemsView];
    
    [self updateBottomConstraintsOfCaptureButton:FUHeightIncludeBottomSafeArea(133) + 10 animated:NO];
}

#pragma mark - FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    if (self.segmentBarView.selectedIndex == 1){
        // 动漫滤镜
        [self.viewModel loadComicFilterAtIndex:index completion:^{
            [self.itemsView stopAnimation];
        }];
    } else {
        //anmoji
        [self.viewModel loadAnimojiAtIndex:index completion:^{
            [self.itemsView stopAnimation];
        }];
    }
}

#pragma mark - FUSegmentBarDelegate

- (void)segmentBar:(FUSegmentBar *)segmentsView didSelectItemAtIndex:(NSUInteger)index {
    if (index == self.viewModel.currentIndex) {
        return;
    }
    self.viewModel.currentIndex = index;
    if (index == 0) {
        self.itemsView.items = self.viewModel.animojiItems;
        self.itemsView.selectedIndex = self.viewModel.selectedAnimojiIndex;
    }else{
        self.itemsView.items = self.viewModel.comicFilterIcons;
        self.itemsView.selectedIndex = self.viewModel.selectedComicFilterIndex;
    }
}

#pragma mark - Getters

- (FUSegmentBar *)segmentBarView {
    if (!_segmentBarView) {
        _segmentBarView = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - FUHeightIncludeBottomSafeArea(49.f), CGRectGetWidth(self.view.bounds), FUHeightIncludeBottomSafeArea(49.f)) titles:@[FULocalizedString(@"Animoji"), FULocalizedString(@"动漫滤镜")] configuration:[FUSegmentBarConfigurations new]];
        _segmentBarView.delegate = self;
        _segmentBarView.selectedIndex = 0;
    }
    return _segmentBarView;
}

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[FUItemsView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - FUHeightIncludeBottomSafeArea(49.f) - 84, CGRectGetWidth(self.view.bounds), 84)];
        _itemsView.delegate = self;
        _itemsView.items = self.viewModel.animojiItems;
        _itemsView.selectedIndex = 0;
    }
    return _itemsView;
}

@end
