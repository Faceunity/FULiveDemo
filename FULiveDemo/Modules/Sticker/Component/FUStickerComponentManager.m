//
//  FUStickerComponentManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/20.
//

#import "FUStickerComponentManager.h"
#import "FUStickerComponentViewModel.h"

static FUStickerComponentManager *stickerComponentManager = nil;
static dispatch_once_t onceToken;

@interface FUStickerComponentManager ()<FUItemsViewDelegate>

@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, strong) FUItemsView *stickersView;
@property (nonatomic, strong) FUStickerComponentViewModel *viewModel;

@end

@implementation FUStickerComponentManager

#pragma mark - Class methods

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        stickerComponentManager = [[FUStickerComponentManager alloc] init];
    });
    return stickerComponentManager;
}

+ (void)destory {
    onceToken = 0;
    stickerComponentManager = nil;
}

#pragma mark - Instance methods

- (void)addComponentViewToView:(UIView *)view {
    NSAssert(view != nil, @"FUStickerComponentManager: view can not be nil!");
    self.targetView = view;
    [self removeComponentView];
    [self.targetView addSubview:self.stickersView];
}

- (void)removeComponentView {
    if (self.stickersView.superview) {
        [self.stickersView removeFromSuperview];
    }
}

#pragma mark - FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [itemsView startAnimation];
    [self.viewModel loadStickerAtIndex:index completion:^{
        [itemsView stopAnimation];
    }];
}

#pragma mark - Getters

- (FUItemsView *)stickersView {
    if (!_stickersView) {
        _stickersView = [[FUItemsView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUHeightIncludeBottomSafeArea(84), CGRectGetWidth(self.targetView.bounds), FUHeightIncludeBottomSafeArea(84))];
        _stickersView.items = self.viewModel.stickerItems;
        _stickersView.selectedIndex = self.viewModel.selectedIndex;
        _stickersView.delegate = self;
    }
    return _stickersView;
}

- (FUStickerComponentViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUStickerComponentViewModel alloc] init];
    }
    return _viewModel;
}

@end
