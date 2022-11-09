//
//  FUBeautyComponentManager.m
//  FUBeautyComponentManager
//
//  Created by 项林平 on 2022/6/10.
//

#import "FUBeautyComponentManager.h"
#import "FUBeautyDefine.h"

#import "FUBeautySkinView.h"
#import "FUBeautyShapeView.h"
#import "FUBeautyFilterView.h"
#import "FUBeautyStyleView.h"

#import <FUCommonUIComponent/FUCommonUIComponent.h>
#import <FURenderKit/FURenderKit.h>

static FUBeautyComponentManager *beautyComponentManager = nil;
static dispatch_once_t onceToken;

@interface FUBeautyComponentManager ()<FUSegmentBarDelegate, FUBeautyFilterViewDelegate, FUBeautyStyleViewDelegate>

@property (nonatomic, weak) UIView *targetView;

@property (nonatomic, strong) FUSegmentBar *categoryView;
@property (nonatomic, strong) UIButton *compareButton;

@property (nonatomic, strong) FUBeautySkinView *beautySkinView;
@property (nonatomic, strong) FUBeautyShapeView *beautyShapeView;
@property (nonatomic, strong) FUBeautyFilterView *beautyFilterView;
@property (nonatomic, strong) FUBeautyStyleView *beautyStyleView;

@property (nonatomic, strong) FUBeautySkinViewModel *beautySkinViewModel;
@property (nonatomic, strong) FUBeautyShapeViewModel *beautyShapeViewModel;
@property (nonatomic, strong) FUBeautyFilterViewModel *beautyFilterViewModel;
@property (nonatomic, strong) FUBeautyStyleViewModel *beautyStyleViewModel;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation FUBeautyComponentManager

#pragma mark - Class methods

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        beautyComponentManager = [[FUBeautyComponentManager alloc] init];
    });
    return beautyComponentManager;
}

+ (void)destory {
    onceToken = 0;
    beautyComponentManager = nil;
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = FUBeautyCategoryNone;
    }
    return self;
}

#pragma mark - Instance methods

- (void)addComponentViewToView:(UIView *)view {
    NSAssert(view != nil, @"FUBeautyComponent: view can not be nil!");
    self.targetView = view;
    [self.targetView addSubview:self.compareButton];
    [self.targetView addSubview:self.beautySkinView];
    [self.targetView addSubview:self.beautyShapeView];
    [self.targetView addSubview:self.beautyFilterView];
    [self.targetView addSubview:self.beautyStyleView];
    [self.targetView addSubview:self.categoryView];
    
    if (self.beautyStyleViewModel.selectedIndex > 0) {
        // 选中了风格推荐
        self.categoryView.selectedIndex = FUBeautyCategoryPreset;
    }
}

- (void)removeComponentView {
    if (self.compareButton.superview) {
        [self.compareButton removeFromSuperview];
    }
    if (self.beautySkinView.superview) {
        [self.beautySkinView removeFromSuperview];
    }
    if (self.beautyShapeView.superview) {
        [self.beautyShapeView removeFromSuperview];
    }
    if (self.beautyFilterView.superview) {
        [self.beautyFilterView removeFromSuperview];
    }
    if (self.beautyStyleView.superview) {
        [self.beautyStyleView removeFromSuperview];
    }
    if (self.categoryView.superview) {
        [self.categoryView removeFromSuperview];
    }
}

- (void)loadBeauty {
    if (![FURenderKit shareRenderKit].beauty) {
        FUBeauty *beauty = [self defaultBeauty];
        [FURenderKit shareRenderKit].beauty = beauty;
    }
    // 设置当前美颜数据
    if (self.beautyStyleViewModel.selectedIndex > 0) {
        // 选择了风格推荐，只需要设置风格推荐
        self.beautyStyleViewModel.selectedIndex = self.beautyStyleViewModel.selectedIndex;
    } else {
        // 分别设置美肤、美型、滤镜
        [self.beautySkinViewModel setAllSkinValues];
        [self.beautyShapeViewModel setAllShapeValues];
        [self.beautyFilterViewModel setCurrentFilter];
    }
}

- (void)unloadBeauty {
    [FURenderKit shareRenderKit].beauty = nil;
}

- (void)saveBeauty {
    [self.beautySkinViewModel saveSkinsPersistently];
    [self.beautyShapeViewModel saveShapesPersistently];
    [self.beautyFilterViewModel saveFitersPersistently];
    [self.beautyStyleViewModel saveStylesPersistently];
}

#pragma mark - Private methods

/// 默认美颜
- (FUBeauty *)defaultBeauty {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
    beauty.heavyBlur = 0;
    // 默认均匀磨皮
    beauty.blurType = 3;
    // 默认精细变形
    beauty.faceShape = 4;
    // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
    if ([FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh) {
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
    }
    return beauty;
}

- (void)showEffectView:(UIView *)view animated:(BOOL)animated {
    view.hidden = NO;
    self.compareButton.hidden = NO;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(view.frame));
            self.compareButton.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(view.frame));
        } completion:^(BOOL finished) {
        }];
    } else {
        view.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(view.frame));
        self.compareButton.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(view.frame));
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyComponentViewHeightDidChange:)]) {
        [self.delegate beautyComponentViewHeightDidChange:CGRectGetHeight(view.frame) + CGRectGetHeight(self.categoryView.frame)];
    }
}

- (void)hideEffectView:(UIView *)view animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            view.hidden = YES;
        }];
    } else {
        view.transform = CGAffineTransformIdentity;
        view.hidden = YES;
    }
}

- (UIView *)showingView {
    UIView *view;
    switch (self.selectedIndex) {
        case FUBeautyCategorySkin:{
            view = self.beautySkinView;
        }
            break;
        case FUBeautyCategoryShape:{
            view = self.beautyShapeView;
        }
            break;
        case FUBeautyCategoryFilter:{
            view = self.beautyFilterView;
        }
            break;
        case FUBeautyCategoryPreset:{
            view = self.beautyStyleView;
        }
            break;
        default:
            break;
    }
    return view;
}

#pragma mark - Event response

- (void)compareTouchDownAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyComponentDidTouchDownComparison)]) {
        [self.delegate beautyComponentDidTouchDownComparison];
    }
}

- (void)compareTouchUpAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyComponentDidTouchUpComparison)]) {
        [self.delegate beautyComponentDidTouchUpComparison];
    }
}

#pragma mark - FUSegmentBarDelegate

- (BOOL)segmentBar:(FUSegmentBar *)segmentBar shouldSelectItemAtIndex:(NSInteger)index {
    if (self.beautyStyleViewModel.selectedIndex > 0 && index < FUBeautyCategoryPreset) {
        // 取消风格推荐提示
        NSArray<NSString *> *categories = @[FUBeautyStringWithKey(@"skin"), FUBeautyStringWithKey(@"shape"), FUBeautyStringWithKey(@"filter")];
        NSString *tipString = [NSString stringWithFormat:FUBeautyStringWithKey(@"To use, cancel Presets first."), categories[index]];
        [FUTipHUD showTips:tipString dismissWithDelay:1.5];
        return NO;
    }
    return YES;
}

- (BOOL)segmentBar:(FUSegmentBar *)segmentBar shouldDisableItemAtIndex:(NSInteger)index {
    return self.beautyStyleViewModel.selectedIndex > 0 && index < FUBeautyCategoryPreset;
}

- (void)segmentBar:(FUSegmentBar *)segmentBar didSelectItemAtIndex:(NSUInteger)index {
    if (index == self.selectedIndex) {
        // 隐藏
        [self hideEffectView:[self showingView] animated:YES];
        self.compareButton.transform = CGAffineTransformIdentity;
        self.compareButton.hidden = YES;
        segmentBar.selectedIndex = -1;
        self.selectedIndex = FUBeautyCategoryNone;
        if (self.delegate && [self.delegate respondsToSelector:@selector(beautyComponentViewHeightDidChange:)]) {
            [self.delegate beautyComponentViewHeightDidChange:CGRectGetHeight(self.categoryView.frame)];
        }
    } else {
        if (self.selectedIndex > FUBeautyCategoryNone) {
            [self hideEffectView:[self showingView] animated:NO];
        }
        self.selectedIndex = index;
        [self showEffectView:[self showingView] animated:YES];
    }
}

#pragma mark - FUBeautyFilterViewDelegate

- (void)beautyFilterViewDidChangeFilter:(NSString *)name {
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyComponentNeedsDisplayPromptContent:)]) {
        [self.delegate beautyComponentNeedsDisplayPromptContent:name];
    }
}

#pragma mark - FUBeautyStyleViewDelegate

- (void)beautyStyleViewDidSelectStyle {
    [self.categoryView refresh];
}

- (void)beautyStyleViewDidCancelStyle {
    [self.categoryView refresh];
    // 取消风格推荐，恢复美肤、美型、滤镜效果
    [self.beautySkinViewModel setAllSkinValues];
    [self.beautyShapeViewModel setAllShapeValues];
    [self.beautyFilterViewModel setCurrentFilter];
}

#pragma mark - Getters

- (FUSegmentBar *)categoryView {
    if (!_categoryView) {
        NSArray<NSString *> *categories = @[FUBeautyStringWithKey(@"skin"), FUBeautyStringWithKey(@"shape"), FUBeautyStringWithKey(@"filter"), FUBeautyStringWithKey(@"preset")];
        FUSegmentBarConfigurations *configurations = [[FUSegmentBarConfigurations alloc] init];
        configurations.titleFont = [UIFont systemFontOfSize:15];
        _categoryView = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUBeautyHeightIncludeBottomSafeArea(FUBeautyCategoryViewHeight), CGRectGetWidth(self.targetView.bounds), FUBeautyHeightIncludeBottomSafeArea(FUBeautyCategoryViewHeight)) titles:categories configuration:configurations];
        _categoryView.delegate = self;
    }
    return _categoryView;
}

- (UIButton *)compareButton {
    if (!_compareButton) {
        _compareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _compareButton.frame = CGRectMake(15, CGRectGetMinY(self.categoryView.frame) - 54, 44, 44);
        [_compareButton setImage:FUBeautyImageNamed(@"demo_icon_contrast") forState:UIControlStateNormal];
        [_compareButton addTarget:self action:@selector(compareTouchDownAction) forControlEvents:UIControlEventTouchDown];
        [_compareButton addTarget:self action:@selector(compareTouchUpAction) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _compareButton.hidden = YES;
    }
    return _compareButton;
}

- (FUBeautySkinView *)beautySkinView {
    if (!_beautySkinView) {
        _beautySkinView = [[FUBeautySkinView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.categoryView.frame), CGRectGetWidth(self.targetView.bounds), FUBeautyFunctionViewOverallHeight) viewModel:self.beautySkinViewModel];
        _beautySkinView.hidden = YES;
    }
    return _beautySkinView;
}

- (FUBeautyShapeView *)beautyShapeView {
    if (!_beautyShapeView) {
        _beautyShapeView = [[FUBeautyShapeView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.categoryView.frame), CGRectGetWidth(self.targetView.bounds), FUBeautyFunctionViewOverallHeight) viewModel:self.beautyShapeViewModel];
        _beautyShapeView.hidden = YES;
    }
    return _beautyShapeView;
}

- (FUBeautyFilterView *)beautyFilterView {
    if (!_beautyFilterView) {
        _beautyFilterView = [[FUBeautyFilterView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.categoryView.frame), CGRectGetWidth(self.targetView.bounds), FUBeautyFunctionViewOverallHeight) viewModel:self.beautyFilterViewModel];
        _beautyFilterView.hidden = YES;
        _beautyFilterView.delegate = self;
    }
    return _beautyFilterView;
}

- (FUBeautyStyleView *)beautyStyleView {
    if (!_beautyStyleView) {
        _beautyStyleView = [[FUBeautyStyleView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.categoryView.frame), CGRectGetWidth(self.targetView.bounds), FUBeautyFunctionViewOverallHeight) viewModel:self.beautyStyleViewModel];
        _beautyStyleView.hidden = YES;
        _beautyStyleView.delegate = self;
    }
    return _beautyStyleView;
}

- (FUBeautySkinViewModel *)beautySkinViewModel {
    if (!_beautySkinViewModel) {
        _beautySkinViewModel = [[FUBeautySkinViewModel alloc] init];
    }
    return _beautySkinViewModel;
}

- (FUBeautyShapeViewModel *)beautyShapeViewModel {
    if (!_beautyShapeViewModel) {
        _beautyShapeViewModel = [[FUBeautyShapeViewModel alloc] init];
    }
    return _beautyShapeViewModel;
}

- (FUBeautyFilterViewModel *)beautyFilterViewModel {
    if (!_beautyFilterViewModel) {
        _beautyFilterViewModel = [[FUBeautyFilterViewModel alloc] init];
    }
    return _beautyFilterViewModel;
}

- (FUBeautyStyleViewModel *)beautyStyleViewModel {
    if (!_beautyStyleViewModel) {
        _beautyStyleViewModel = [[FUBeautyStyleViewModel alloc] init];
    }
    return _beautyStyleViewModel;
}

- (CGFloat)componentViewHeight {
    if (self.selectedIndex == FUBeautyCategoryNone) {
        return FUBeautyHeightIncludeBottomSafeArea(FUBeautyCategoryViewHeight);
    } else {
        return FUBeautyHeightIncludeBottomSafeArea(FUBeautyCategoryViewHeight) + FUBeautyFunctionViewOverallHeight;
    }
}

@end
