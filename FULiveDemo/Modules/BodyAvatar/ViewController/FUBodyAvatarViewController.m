//
//  FUBodyAvatarViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FUBodyAvatarViewController.h"
#import "FUSwitch.h"

@interface FUBodyAvatarViewController ()<FUItemsViewDelegate>

@property(nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) FUGLDisplayView *preview;
@property (nonatomic, strong) FUSwitch *positionSwitch;

@property (nonatomic, strong, readonly) FUBodyAvatarViewModel *viewModel;

@end

@implementation FUBodyAvatarViewController

@dynamic viewModel;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.preview belowSubview:self.headButtonView];
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(80));
    }];
    
    [self.view addSubview:self.positionSwitch];
    [self.positionSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.itemsView.mas_top).mas_offset(-17);
        make.leading.equalTo(self.view.mas_leading).mas_offset(17);
        make.size.mas_offset(CGSizeMake(86, 32));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 异步处理防止卡主线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 默认后置摄像头
        [self.viewModel switchCameraBetweenFrontAndRear:NO unsupportedPresetHandler:nil];
    });
}

#pragma mark - Event response

- (void)postionSwitchAction:(FUSwitch *)sender {
    self.viewModel.wholeBody = sender.isOn;
}

- (void)previewPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:sender.view.superview];
    CGFloat senderHalfViewWidth = CGRectGetWidth(sender.view.frame) / 2.0;
    CGFloat senderHalfViewHeight = CGRectGetHeight(sender.view.frame) / 2.0;
    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    if (sender.state == UIGestureRecognizerStateEnded) {
        // 拖拽状态结束
        [UIView animateWithDuration:0.4 animations:^{
            CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 5 || sender.view.center.x < viewWidth/2.0) {
                viewCenter.x = senderHalfViewWidth + 5;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= viewWidth - 5 || sender.view.center.x >= viewWidth/2) {
                viewCenter.x = viewWidth - senderHalfViewWidth - 5;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= FUHeightIncludeTopSafeArea(75)) {
                viewCenter.y = senderHalfViewHeight + FUHeightIncludeTopSafeArea(75);
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= (FUScreenHeight - 90 -  34)) {
                viewCenter.y = viewHeight - senderHalfViewHeight - 90 - 34;
            }
            sender.view.center = viewCenter;
        } completion:^(BOOL finished) {
        }];
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    } else if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        viewCenter.x = sender.view.center.x + point.x;
        viewCenter.y = sender.view.center.y + point.y;
        sender.view.center = viewCenter;
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    }
}

#pragma mark - FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    self.viewModel.selectedIndex = index;
}

#pragma mark - FURenderViewModelDelegate

- (void)renderWillInputPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    [self.preview displayPixelBuffer:pixelBuffer];
}

#pragma mark - Getters

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[FUItemsView alloc] init];
        _itemsView.delegate = self;
        _itemsView.items = self.viewModel.avatarItems;
        _itemsView.selectedIndex = 0;
    }
    return _itemsView;
}

- (FUGLDisplayView *)preview {
    if (!_preview) {
        _preview = [[FUGLDisplayView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 95, CGRectGetHeight(self.view.bounds) - 149 - FUHeightIncludeBottomSafeArea(80), 90, 144)];
         UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(previewPanAction:)];
         [_preview addGestureRecognizer:panGestureRecognizer];
    }
    return _preview;
}

- (FUSwitch *)positionSwitch {
    if (!_positionSwitch) {
        _positionSwitch = [[FUSwitch alloc] initWithFrame:CGRectMake(60, 150, 86, 32) onColor:[UIColor colorWithRed:31 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1.0] offColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] ballSize:30];
        _positionSwitch.onText = FULocalizedString(@"全身驱动");
        _positionSwitch.offText = FULocalizedString(@"半身驱动");
        _positionSwitch.offLabel.textColor = [UIColor colorWithRed:31 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1.0];
        _positionSwitch.on = YES;
        [_positionSwitch addTarget:self action:@selector(postionSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _positionSwitch;
}

@end
