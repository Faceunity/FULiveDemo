//
//  FUBeautyImageRenderViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import "FUBeautyImageRenderViewController.h"

@interface FUBeautyImageRenderViewController ()<FUBeautyComponentDelegate>

@end

@implementation FUBeautyImageRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // // 添加美颜视图
    [[FUBeautyComponentManager sharedManager] addComponentViewToView:self.view];
    [FUBeautyComponentManager sharedManager].delegate = self;
    
    // 更新保存按钮位置
    [self updateBottomConstraintsOfDownloadButton:[FUBeautyComponentManager sharedManager].componentViewHeight + 10 hidden:[FUBeautyComponentManager sharedManager].selectedIndex == -1 animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[FUBeautyComponentManager sharedManager] removeComponentView];
    [FUBeautyComponentManager sharedManager].delegate = nil;
}

#pragma mark - Event response

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}


#pragma mark - FUBeautyComponentDelegate

- (void)beautyComponentViewHeightDidChange:(CGFloat)height {
    // 美颜视图高度变化时需要更新拍照/录制按钮的位置
    [self updateBottomConstraintsOfDownloadButton:height + 10 hidden:[FUBeautyComponentManager sharedManager].selectedIndex == -1 animated:YES];
}

- (void)beautyComponentDidTouchDownComparison {
    self.viewModel.rendering = NO;
}

- (void)beautyComponentDidTouchUpComparison {
    self.viewModel.rendering = YES;
}

- (void)beautyComponentNeedsDisplayPromptContent:(NSString *)content {
    if (content.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.text = content;
        self.tipLabel.hidden = NO;
        [FUBeautyImageRenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

@end
