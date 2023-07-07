//
//  FUGreenScreenComponentManager.m
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/11.
//

#import "FUGreenScreenComponentManager.h"
#import "FUGreenScreenDefine.h"

#import "FUGreenScreenKeyingView.h"
#import "FUGreenScreenSafeAreaView.h"
#import "FUGreenScreenBackgroundView.h"
#import "FUGreenScreenColorPicker.h"

#import <FUCommonUIComponent/FUCommonUIComponent.h>

static FUGreenScreenComponentManager *manager = nil;
static dispatch_once_t onceToken;

@interface FUGreenScreenComponentManager ()<FUSegmentBarDelegate, FUGreenScreenKeyingViewDelegate, FUGreenScreenSafeAreaViewDelegate, FUGreenScreenColorPickerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *targetView;

@property (nonatomic, strong) FUSegmentBar *segmentBar;
@property (nonatomic, strong) FUGreenScreenKeyingView *keyingView;
@property (nonatomic, strong) FUGreenScreenSafeAreaView *safeAreaView;
@property (nonatomic, strong) FUGreenScreenBackgroundView *backgroundView;
/// 取色器
@property (nonatomic, strong) FUGreenScreenColorPicker *colorPicker;

@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;

@property (nonatomic, strong) FUGreenScreenKeyingViewModel *keyingViewModel;
@property (nonatomic, strong) FUGreenScreenBackgroundViewModel *backgroundViewModel;

@property (nonatomic, assign) NSInteger selectedIndex;
/// 是否显示安全区域选择器
@property (nonatomic, assign) BOOL isShowingSafeAreaSelection;

@end

@implementation FUGreenScreenComponentManager

#pragma mark - Class methods

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        manager = [[FUGreenScreenComponentManager alloc] init];
    });
    return manager;
}

+ (void)destory {
    onceToken = 0;
    manager = nil;
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = FUGreenScreenCategoryNone;
    }
    return self;
}

#pragma mark - Instance methods

- (void)addComponentViewToView:(UIView *)view {
    NSAssert(view != nil, @"FUGreenScreenComponent: view can not be nil!");
    
    self.targetView = view;
    [self removeComponentView];
    [self.targetView addSubview:self.keyingView];
    [self.targetView addSubview:self.backgroundView];
    [self.targetView addSubview:self.safeAreaView];
    [self.targetView addSubview:self.segmentBar];
    
    // 拖拽手势
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.panGesture.delegate = self;
    [self.targetView addGestureRecognizer:self.panGesture];
    
    // 缩放手势
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    self.pinchGesture.delegate = self;
    [self.targetView addGestureRecognizer:self.pinchGesture];
}

- (void)removeComponentView {
    if (self.keyingView.superview) {
        [self.keyingView removeFromSuperview];
    }
    if (self.backgroundView.superview) {
        [self.backgroundView removeFromSuperview];
    }
    if (self.safeAreaView.superview) {
        [self.safeAreaView removeFromSuperview];
    }
    if (self.segmentBar.superview) {
        [self.segmentBar removeFromSuperview];
    }
    if (self.colorPicker.superview) {
        [self.colorPicker removeFromSuperview];
    }
    if (self.panGesture.view) {
        [self.targetView removeGestureRecognizer:self.panGesture];
    }
    if (self.pinchGesture.view) {
        [self.targetView removeGestureRecognizer:self.pinchGesture];
    }
}

- (void)loadGreenScreen {
    if (![FURenderKit shareRenderKit].greenScreen) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"green_screen_740" ofType:@"bundle"];
        FUGreenScreen *greenScreen = [[FUGreenScreen alloc] initWithPath:path name:@"green_screen"];
        [FURenderKit shareRenderKit].greenScreen = greenScreen;
    }
}

- (void)unloadGreenScreen {
    [FURenderKit shareRenderKit].greenScreen = nil;
}

- (void)saveCustomSafeArea:(UIImage *)image {
    if (!image) {
        return;
    }
    if ([self.keyingViewModel.safeAreaViewModel saveLocalSafeAreaImage:image]) {
        // 刷新安全区域数据
        [self.keyingViewModel.safeAreaViewModel realoadSafeAreaData];
        // 默认选择自定义的安全区域图片
        self.keyingViewModel.safeAreaViewModel.selectedIndex = 3;
        // 刷新安全区域视图
        [self.safeAreaView refreshSafeAreas];
    }
}

#pragma mark - Event response

- (void)panAction:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translationPoint = [pan translationInView:view.superview];
        CGFloat dx = translationPoint.x/CGRectGetWidth(view.superview.bounds);
        CGFloat dy = translationPoint.y/CGRectGetHeight(view.superview.bounds);
        if (![FURenderKit shareRenderKit].greenScreen) {
            return;
        }
        FUGreenScreen *greenScreen = [FURenderKit shareRenderKit].greenScreen;
        FUGLDisplayViewOrientation orientation = self.displayView.origintation;
        switch (orientation) {
            case FUGLDisplayViewOrientationPortrait:
                greenScreen.center = CGPointMake(greenScreen.center.x + dx, greenScreen.center.y + dy);
                break;
            case FUGLDisplayViewOrientationPortraitUpsideDown:
                greenScreen.center = CGPointMake(greenScreen.center.x - dx, greenScreen.center.y - dy);
                break;
            case FUGLDisplayViewOrientationLandscapeRight:
                greenScreen.center = CGPointMake(greenScreen.center.x + dy, greenScreen.center.y - dx);
                break;
            case FUGLDisplayViewOrientationLandscapeLeft:
                greenScreen.center = CGPointMake(greenScreen.center.x - dy, greenScreen.center.y + dx);
                break;
        }
        [pan setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        if (![FURenderKit shareRenderKit].greenScreen) {
            return;
        }
        [FURenderKit shareRenderKit].greenScreen.scale *= pinch.scale;
        pinch.scale = 1;
    }
}

#pragma mark - Private methods

- (void)showEffectView:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion {
    view.hidden = NO;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(view.frame));
        } completion:^(BOOL finished) {
            !completion ?: completion();
        }];
    } else {
        view.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(view.frame));
        !completion ?: completion();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(greenScreenComponentViewHeightDidChange:)]) {
        [self.delegate greenScreenComponentViewHeightDidChange:CGRectGetHeight(view.frame) + CGRectGetHeight(self.segmentBar.frame)];
    }
}

- (void)hideEffectView:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            view.hidden = YES;
            !completion ?: completion();
        }];
    } else {
        view.transform = CGAffineTransformIdentity;
        view.hidden = YES;
        !completion ?: completion();
    }
}

- (UIView *)showingView {
    UIView *view;
    if (self.selectedIndex == FUGreenScreenCategoryKeying) {
        view = self.isShowingSafeAreaSelection ? self.safeAreaView : self.keyingView;
    } else {
        view = self.backgroundView;
    }
    return view;
}

#pragma mark - FUSegmentBarDelegate

- (void)segmentBar:(FUSegmentBar *)segmentBar didSelectItemAtIndex:(NSUInteger)index {
    if (index == self.selectedIndex) {
        // 隐藏当前显示视图
        segmentBar.userInteractionEnabled = NO;
        [self hideEffectView:[self showingView] animated:YES completion:^{
            segmentBar.userInteractionEnabled = YES;
        }];
        [segmentBar selectItemAtIndex:-1];
        self.selectedIndex = FUGreenScreenCategoryNone;
        if (self.delegate && [self.delegate respondsToSelector:@selector(greenScreenComponentViewHeightDidChange:)]) {
            [self.delegate greenScreenComponentViewHeightDidChange:CGRectGetHeight(self.segmentBar.frame)];
        }
    } else {
        segmentBar.userInteractionEnabled = NO;
        if (self.selectedIndex != FUGreenScreenCategoryNone) {
            // 先隐藏当前显示视图
            [self hideEffectView:[self showingView] animated:NO completion:nil];
        }
        self.selectedIndex = index;
        // 再显示需要的视图
        [self showEffectView:[self showingView] animated:YES completion:^{
            segmentBar.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - FUGreenScreenKeyingViewDelegate

- (void)keyingViewRequiresPickColor:(BOOL)required {
    if (required) {
        if (!self.colorPicker.superview) {
            if (!self.displayView && ![FURenderKit shareRenderKit].glDisplayView) {
                NSLog(@"FUGreenScreenComponent: Set displayView first!");
                return;
            }
            if (!self.displayView) {
                self.displayView = [FURenderKit shareRenderKit].glDisplayView;
            }
            [self.displayView addSubview:self.colorPicker];
        }
        self.colorPicker.frame = CGRectMake(100, 100, 36, 60);
        UIColor *color = self.keyingViewModel.keyColorArray[0];
        [self.colorPicker refreshPickerColor:color];
        [self.keyingView refreshPickerColor:color];
        // 显示取色器
        self.colorPicker.hidden = NO;
        // 取色的时候取消手势
        self.panGesture.enabled = NO;
        self.pinchGesture.enabled = NO;
        if (![FURenderKit shareRenderKit].greenScreen) {
            // 暂停抠像
            [FURenderKit shareRenderKit].greenScreen.cutouting = YES;
        }
    } else {
        // 隐藏取色器
        self.colorPicker.hidden = YES;
        self.panGesture.enabled = YES;
        self.pinchGesture.enabled = YES;
        if ([FURenderKit shareRenderKit].greenScreen) {
            [FURenderKit shareRenderKit].greenScreen.cutouting = NO;
        }
    }
}

- (void)keyingViewDidSelectSafeArea {
    [self hideEffectView:self.keyingView animated:NO completion:nil];
    self.isShowingSafeAreaSelection = YES;
    [self showEffectView:self.safeAreaView animated:YES completion:nil];
}

- (void)keyingViewDidRecoverToDefault {
    self.colorPicker.hidden = YES;
    [self.safeAreaView refreshSafeAreas];
}

#pragma mark - FUGreenScreenSafeAreaViewDelegate

- (void)safeAreaCollectionViewDidClickBack {
    self.isShowingSafeAreaSelection = NO;
    [self.keyingView refreshKeyingCollectionView];
    [self hideEffectView:self.safeAreaView animated:NO completion:nil];
    [self showEffectView:self.keyingView animated:YES completion:nil];
}

- (void)safeAreaCollectionViewDidClickCancel {
    [self.keyingView refreshRecoverButtonState];
}

- (void)safeAreaCollectionViewDidClickAdd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(greenScreenComponentDidCustomizeSafeArea)]) {
        [self.delegate greenScreenComponentDidCustomizeSafeArea];
    }
}

- (void)safeAreaCollectionViewDidSelectItemAtIndex:(NSInteger)index {
    [self.keyingView refreshRecoverButtonState];
}

#pragma mark - FUGreenScreenColorPickerDelegate

- (void)colorPickerDidChangePoint:(CGPoint)point {
    UIColor *color = [self.displayView colorInPoint:point];
    // 取色过程中只刷新视图颜色，不设置关键颜色给绿幕
    [self.colorPicker refreshPickerColor:color];
    [self.keyingView refreshPickerColor:color];
}

- (void)colorPickerDidEndPickingAtPoint:(CGPoint)point {
    // 隐藏取色器
    self.colorPicker.hidden = YES;
    // 取完色后恢复手势
    self.panGesture.enabled = YES;
    self.pinchGesture.enabled = YES;
    // 获取锚点颜色
    UIColor *color = [self.displayView colorInPoint:point];
    // 刷新视图颜色
    [self.colorPicker refreshPickerColor:color];
    [self.keyingView refreshPickerColor:color];
    // 取色结束设置关键颜色给绿幕
    [self.keyingViewModel setCurrentKeyColor:color];
    // 更新颜色数据
    self.keyingViewModel.keyColorArray[0] = color;
    // 更新视图
    [self.keyingView refreshKeyingCollectionView];
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.segmentBar] || [touch.view isDescendantOfView:self.keyingView] || [touch.view isDescendantOfView:self.backgroundView] || [touch.view isDescendantOfView:self.safeAreaView]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Getters

- (FUSegmentBar *)segmentBar {
    if (!_segmentBar) {
        _segmentBar = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUGreenScreenHeightIncludeBottomSafeArea(49.f), CGRectGetWidth(self.targetView.bounds), FUGreenScreenHeightIncludeBottomSafeArea(49.f)) titles:@[FUGreenScreenStringWithKey(@"抠像"), FUGreenScreenStringWithKey(@"背景")] configuration:[FUSegmentBarConfigurations new]];
        _segmentBar.delegate = self;
        [_segmentBar selectItemAtIndex:FUGreenScreenCategoryKeying];
    }
    return _segmentBar;
}

- (FUGreenScreenKeyingView *)keyingView {
    if (!_keyingView) {
        _keyingView = [[FUGreenScreenKeyingView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUGreenScreenHeightIncludeBottomSafeArea(49.f), CGRectGetWidth(self.targetView.bounds), FUGreenScreenFunctionViewOverallHeight) viewModel:self.keyingViewModel];
        _keyingView.delegate = self;
    }
    return _keyingView;
}

- (FUGreenScreenSafeAreaView *)safeAreaView {
    if (!_safeAreaView) {
        _safeAreaView = [[FUGreenScreenSafeAreaView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUGreenScreenHeightIncludeBottomSafeArea(49.f), CGRectGetWidth(self.targetView.bounds), FUGreenScreenFunctionViewHeight) viewModel:self.keyingViewModel.safeAreaViewModel];
        _safeAreaView.hidden = YES;
        _safeAreaView.delegate = self;
    }
    return _safeAreaView;
}

- (FUGreenScreenBackgroundView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[FUGreenScreenBackgroundView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUGreenScreenHeightIncludeBottomSafeArea(49.f), CGRectGetWidth(self.targetView.bounds), FUFUGreenScreenBackgroundViewHeight) viewModel:self.backgroundViewModel];
        _backgroundView.hidden = YES;
    }
    return _backgroundView;
}

- (FUGreenScreenColorPicker *)colorPicker {
    if (!_colorPicker) {
        _colorPicker = [[FUGreenScreenColorPicker alloc] initWithFrame:CGRectMake(100, 100, 36, 60)];
        _colorPicker.delegate = self;
        _colorPicker.hidden = YES;
    }
    return _colorPicker;
}

- (FUGreenScreenKeyingViewModel *)keyingViewModel {
    if (!_keyingViewModel) {
        _keyingViewModel = [[FUGreenScreenKeyingViewModel alloc] init];
    }
    return _keyingViewModel;
}

- (FUGreenScreenBackgroundViewModel *)backgroundViewModel {
    if (!_backgroundViewModel) {
        _backgroundViewModel = [[FUGreenScreenBackgroundViewModel alloc] init];
    }
    return _backgroundViewModel;
}

- (CGFloat)componentViewHeight {
    CGFloat height = FUGreenScreenHeightIncludeBottomSafeArea(FUGreenScreenCategoryViewHeight);
    switch (self.selectedIndex) {
        case FUGreenScreenCategoryKeying:{
            if (self.isShowingSafeAreaSelection) {
                height += FUGreenScreenFunctionViewHeight;
            } else {
                height += FUGreenScreenFunctionViewOverallHeight;
            }
        }
            break;
        case FUGreenScreenCategoryBackground:
            height += FUFUGreenScreenBackgroundViewHeight;
        default:
            break;
    }
    return height;
}

@end
