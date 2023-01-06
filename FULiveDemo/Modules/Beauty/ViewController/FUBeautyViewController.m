//
//  FUBeautyViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/26.
//

#import "FUBeautyViewController.h"

@interface FUBeautyViewController ()<FUBeautyComponentDelegate>

@property (nonatomic, strong, readonly) FUBeautyViewModel *viewModel;

@end

@implementation FUBeautyViewController

@dynamic viewModel;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 添加美颜视图
    [[FUBeautyComponentManager sharedManager] addComponentViewToView:self.view];
    [FUBeautyComponentManager sharedManager].delegate = self;
    // 更新拍照/录制按钮位置
    [self updateBottomConstraintsOfCaptureButton:[FUBeautyComponentManager sharedManager].componentViewHeight];
}

#pragma mark - Event response

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}

#pragma mark - FUBeautyComponentDelegate

- (void)beautyComponentViewHeightDidChange:(CGFloat)height {
    // 美颜视图高度变化时需要更新拍照/录制按钮的位置
    [self updateBottomConstraintsOfCaptureButton:height];
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
        [FUBeautyViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

#pragma mark - FUHeadButtonViewDelegate

- (void)headButtonViewBackAction:(UIButton *)btn {
    [[FUBeautyComponentManager sharedManager] saveBeauty];
    [super headButtonViewBackAction:btn];
}


@end
