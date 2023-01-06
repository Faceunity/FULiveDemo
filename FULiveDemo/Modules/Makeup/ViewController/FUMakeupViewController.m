//
//  FUMakeupViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/7.
//

#import "FUMakeupViewController.h"
#import <FUMakeupComponent/FUMakeupComponent.h>

@interface FUMakeupViewController ()<FUMakeupComponentDelegate>

@end

@implementation FUMakeupViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUMakeupComponentManager sharedManager] addComponentViewToView:self.view];
    [FUMakeupComponentManager sharedManager].delegate = self;
    // 更新拍照/录制按钮位置
    [self updateBottomConstraintsOfCaptureButton:[FUMakeupComponentManager sharedManager].componentViewHeight];
}

#pragma mark - Event response

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}

#pragma mark - FUMakeupComponentDelegate

- (void)makeupComponentViewHeightDidChange:(CGFloat)height {
    // 美妆视图高度变化时需要更新拍照/录制按钮的位置
    [self updateBottomConstraintsOfCaptureButton:height];
}

- (void)makeupComponentNeedsDisplayPromptContent:(NSString *)content {
    if (content.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.text = content;
        self.tipLabel.hidden = NO;
        [FUMakeupViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

#pragma mark - FUHeadButtonViewDelegate

- (void)headButtonViewBackAction:(UIButton *)btn {
    [FUMakeupComponentManager destory];
    [super headButtonViewBackAction:btn];
}

@end
