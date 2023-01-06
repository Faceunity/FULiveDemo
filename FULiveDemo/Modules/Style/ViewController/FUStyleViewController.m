//
//  FUStyleViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleViewController.h"

#import "FUStyleComponentManager.h"

@interface FUStyleViewController ()<FUStyleComponentDelegate>

@end

@implementation FUStyleViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUStyleComponentManager sharedManager] addComponentViewToView:self.view];
    [FUStyleComponentManager sharedManager].delegate = self;
    // 更新拍照/录制按钮位置
    [self updateBottomConstraintsOfCaptureButton:[FUStyleComponentManager sharedManager].componentViewHeight];
}

#pragma mark - FUStyleComponentDelegate

- (void)styleComponentViewHeightDidChange:(CGFloat)height {
    [self updateBottomConstraintsOfCaptureButton:height];
}

- (void)styleComponentDidTouchDownComparison {
    self.viewModel.rendering = NO;
}

- (void)styleComponentDidTouchUpComparison {
    self.viewModel.rendering = YES;
}

#pragma mark - FUHeadButtonViewDelegate

- (void)headButtonViewBackAction:(UIButton *)btn {
    [[FUStyleComponentManager sharedManager] saveStyles];
    [FUStyleComponentManager destory];
    [super headButtonViewBackAction:btn];
}

@end
