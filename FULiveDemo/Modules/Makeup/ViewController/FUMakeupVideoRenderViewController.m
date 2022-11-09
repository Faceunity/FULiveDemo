//
//  FUMakeupVideoRenderViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/20.
//

#import "FUMakeupVideoRenderViewController.h"
#import <FUMakeupComponent/FUMakeupComponent.h>

@interface FUMakeupVideoRenderViewController ()<FUMakeupComponentDelegate>

@end

@implementation FUMakeupVideoRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUMakeupComponentManager sharedManager] addComponentViewToView:self.view];
    [FUMakeupComponentManager sharedManager].delegate = self;
    // 更新保存按钮位置
    [self updateBottomConstraintsOfDownloadButton:[FUMakeupComponentManager sharedManager].componentViewHeight + 10 hidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[FUMakeupComponentManager sharedManager] removeComponentView];
    [FUMakeupComponentManager sharedManager].delegate = nil;
}

#pragma mark - Event response

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}

#pragma mark - FUMakeupComponentDelegate

- (void)makeupComponentViewHeightDidChange:(CGFloat)height {
    // 美妆视图高度变化时需要更新保存按钮位置
    [self updateBottomConstraintsOfDownloadButton:height + 10 hidden:NO animated:YES];
}

- (void)makeupComponentNeedsDisplayPromptContent:(NSString *)content {
    if (content.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.text = content;
        self.tipLabel.hidden = NO;
        [FUMakeupVideoRenderViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

@end
