//
//  FUStyleImageRenderViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleImageRenderViewController.h"

#import "FUStyleComponentManager.h"

@interface FUStyleImageRenderViewController ()<FUStyleComponentDelegate>

@end

@implementation FUStyleImageRenderViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUStyleComponentManager sharedManager] addComponentViewToView:self.view];
    [FUStyleComponentManager sharedManager].delegate = self;
    // 更新拍照/录制按钮位置
    [self updateBottomConstraintsOfDownloadButton:[FUStyleComponentManager sharedManager].componentViewHeight];
}

#pragma mark - FUStyleComponentDelegate

- (void)styleComponentViewHeightDidChange:(CGFloat)height {
    [self updateBottomConstraintsOfDownloadButton:height];
}

- (void)styleComponentDidTouchDownComparison {
    self.viewModel.rendering = NO;
}

- (void)styleComponentDidTouchUpComparison {
    self.viewModel.rendering = YES;
}

@end
