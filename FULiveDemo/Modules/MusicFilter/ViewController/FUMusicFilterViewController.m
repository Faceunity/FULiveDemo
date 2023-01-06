//
//  FUMusicFilterViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMusicFilterViewController.h"

@interface FUMusicFilterViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;

@property (nonatomic, strong, readonly) FUMusicFilterViewModel *viewModel;

@end

@implementation FUMusicFilterViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)setupView{
    self.itemsView = [[FUItemsView alloc] init];
    self.itemsView.delegate = self;
    [self.view addSubview:self.itemsView];
    self.itemsView.items = self.viewModel.musicFilterItems;
    
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(FUHeightIncludeBottomSafeArea(84));
    }];
    
    self.itemsView.selectedIndex = 1;
}

- (void)applicationWillResignActive {
    if (self.viewModel.selectedIndex > 0 && [FURenderKit shareRenderKit].musicFilter.musicPath) {
        [[FURenderKit shareRenderKit].musicFilter pause];
    }
}

- (void)applicationDidBecomeActive {
    if (self.viewModel.selectedIndex > 0 && [FURenderKit shareRenderKit].musicFilter.musicPath) {
        [[FURenderKit shareRenderKit].musicFilter resume];
    }
}

#pragma mark -  FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    self.viewModel.selectedIndex = index;
}

#pragma mark - FUHeadButtonViewDelegate

- (void)headButtonViewSwitchAction:(UIButton *)btn {
    [super headButtonViewSwitchAction:btn];
    if ([FURenderKit shareRenderKit].musicFilter) {
        [[FURenderKit shareRenderKit].musicFilter play];
    }
}

- (void)headButtonViewSegmentedChange:(NSUInteger)index {
    [super headButtonViewSegmentedChange:index];
    if ([FURenderKit shareRenderKit].musicFilter) {
        [[FURenderKit shareRenderKit].musicFilter play];
    }
}

@end
