//
//  FUStyleComponentManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleComponentManager.h"

#import "FUStyleListView.h"
#import "FUStyleCustomizingView.h"

static FUStyleComponentManager *styleComponentManager = nil;
static dispatch_once_t onceToken;

@interface FUStyleComponentManager ()<FUStyleListViewDelegate, FUStyleCustomizingViewDelegate>

@property (nonatomic, weak) UIView *targetView;

@property (nonatomic, strong) FUStyleListView *styleListView;
@property (nonatomic, strong) FUStyleCustomizingView *styleCustomizingView;
@property (nonatomic, strong) UIButton *compareButton;
@property (nonatomic, strong) UIButton *recoverButton;

@end

@implementation FUStyleComponentManager

#pragma mark - Class methods

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        styleComponentManager = [[FUStyleComponentManager alloc] init];
    });
    return styleComponentManager;
}

+ (void)destory {
    onceToken = 0;
    styleComponentManager = nil;
}

#pragma mark - Instance methods

- (void)addComponentViewToView:(UIView *)view {
    NSAssert(view != nil, @"FUStyleComponent: view can not be nil!");
    self.targetView = view;
    [self removeComponentView];
    [self.targetView addSubview:self.styleListView];
    [self.targetView addSubview:self.styleCustomizingView];
    [self.targetView addSubview:self.compareButton];
    [self.targetView addSubview:self.recoverButton];
}

- (void)removeComponentView {
    if (self.styleListView.superview) {
        [self.styleListView removeFromSuperview];
    }
    if (self.styleCustomizingView) {
        [self.styleCustomizingView removeFromSuperview];
    }
}

- (void)saveStyles {
   [self.styleListView.viewModel saveStylesPersistently];
}

#pragma mark - Private methods

- (void)updateCompareAndRecoverButtonTransform:(CGFloat)constants completion:(nullable void (^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.compareButton.transform = CGAffineTransformMakeTranslation(0, constants);
        self.recoverButton.transform = CGAffineTransformMakeTranslation(0, constants);
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

- (void)updateRecoverButtonStatus {
    BOOL isDefault = self.styleListView.viewModel.isDefault;
    self.recoverButton.alpha = isDefault ? 0.6 : 1;
    self.recoverButton.userInteractionEnabled = !isDefault;
}

#pragma mark - Event response

- (void)compareTouchDownAction {
   if (self.delegate && [self.delegate respondsToSelector:@selector(styleComponentDidTouchDownComparison)]) {
      [self.delegate styleComponentDidTouchDownComparison];
   }
}

- (void)compareTouchUpAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(styleComponentDidTouchUpComparison)]) {
        [self.delegate styleComponentDidTouchUpComparison];
    }
}

- (void)recoverAction {
    [FUAlertManager showAlertWithTitle:nil message:FULocalizedString(@"recover_style_tips") cancel:FULocalizedString(@"取消") confirm:FULocalizedString(@"确认") inController:nil confirmHandler:^{
       [self.styleListView.viewModel resetToDefault];
       [self updateRecoverButtonStatus];
       [self.styleListView refreshSubviews];
    } cancelHandler:nil];
}

#pragma mark - FUStyleListViewDelegate

- (void)styleListViewDisSelectStyleAtIndex:(NSUInteger)index {
    [self updateRecoverButtonStatus];
}

- (void)styleListViewDidClickCustomizingAtIndex:(NSUInteger)index {
    self.styleCustomizingView.viewModel.customizingStyle = self.styleListView.viewModel.styles[index];
    [self.styleListView dismiss];
    [self.styleCustomizingView refreshSubviews];
    [self.styleCustomizingView show];
    self.recoverButton.hidden = YES;
    [self updateCompareAndRecoverButtonTransform:-50 completion:nil];
    // 视图高度变化
    if (self.delegate && [self.delegate respondsToSelector:@selector(styleComponentViewHeightDidChange:)]) {
        [self.delegate styleComponentViewHeightDidChange:CGRectGetHeight(self.styleCustomizingView.frame)];
    }
}

- (void)styleListViewFunctionValueDidChanged {
   [self updateRecoverButtonStatus];
}

#pragma mark - FUStyleCustomizingViewDelegate

- (void)styleCustomizingViewDidClickBack {
    [self.styleCustomizingView dismiss];
    [self.styleListView show];
    [self updateCompareAndRecoverButtonTransform:0 completion:^{
        [self updateRecoverButtonStatus];
        self.recoverButton.hidden = NO;
    }];
    // 视图高度变化
    if (self.delegate && [self.delegate respondsToSelector:@selector(styleComponentViewHeightDidChange:)]) {
        [self.delegate styleComponentViewHeightDidChange:CGRectGetHeight(self.styleListView.frame)];
    }
}

#pragma mark - Getters

- (FUStyleListView *)styleListView {
    if (!_styleListView) {
        _styleListView = [[FUStyleListView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUHeightIncludeBottomSafeArea(134), CGRectGetWidth(self.targetView.bounds), FUHeightIncludeBottomSafeArea(134))];
        _styleListView.delegate = self;
    }
    return _styleListView;
}

- (FUStyleCustomizingView *)styleCustomizingView {
    if (!_styleCustomizingView) {
        _styleCustomizingView = [[FUStyleCustomizingView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUHeightIncludeBottomSafeArea(183), CGRectGetWidth(self.targetView.bounds), FUHeightIncludeBottomSafeArea(183))];
        // 自定义视图默认隐藏
       _styleCustomizingView.hidden = YES;
        [_styleCustomizingView dismiss];
        _styleCustomizingView.delegate = self;
    }
    return _styleCustomizingView;
}

- (UIButton *)compareButton {
    if (!_compareButton) {
        _compareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _compareButton.frame = CGRectMake(12, CGRectGetMinY(self.styleListView.frame) - 56, 44, 44);
        [_compareButton setImage:[UIImage imageNamed:@"compare_item"] forState:UIControlStateNormal];
        [_compareButton addTarget:self action:@selector(compareTouchDownAction) forControlEvents:UIControlEventTouchDown];
        [_compareButton addTarget:self action:@selector(compareTouchUpAction) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _compareButton;
}

- (UIButton *)recoverButton {
    if (!_recoverButton) {
        _recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recoverButton.frame = CGRectMake(CGRectGetWidth(self.targetView.bounds) - 56, CGRectGetMinY(self.styleListView.frame) - 56, 44, 44);
        [_recoverButton setImage:[UIImage imageNamed:@"style_recover"] forState:UIControlStateNormal];
        [_recoverButton addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
        [self updateRecoverButtonStatus];
    }
    return _recoverButton;
}

- (CGFloat)componentViewHeight {
    if (self.styleCustomizingView.isHidden) {
       return FUHeightIncludeBottomSafeArea(134);
    } else {
       return FUHeightIncludeBottomSafeArea(183);
    }
}

@end
