//
//  FUMakeupComponentManager.m
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/13.
//

#import "FUMakeupComponentManager.h"
#import "FUMakeupDefine.h"

#import "FUCombinationMakeupView.h"
#import "FUCustomizedMakeupView.h"
#import "FUCustomizedMakeupColorPicker.h"

#import <FURenderKit/FURenderKit.h>

static FUMakeupComponentManager *makeupComponentManager = nil;
static dispatch_once_t onceToken;

@interface FUMakeupComponentManager ()<FUCombinationMakeupViewDelegate, FUCustomizedMakeupViewDelegate, FUCustomizedMakeupColorPickerDelegate>

@property (nonatomic, weak) UIView *targetView;

@property (nonatomic, strong) FUCombinationMakeupView *combinationMakeupView;
@property (nonatomic, strong) FUCustomizedMakeupView *customizedMakeupView;
@property (nonatomic, strong) FUCustomizedMakeupColorPicker *colorPicker;

@property (nonatomic, strong) FUCombinationMakeupViewModel *combinationMakeupViewModel;
@property (nonatomic, strong) FUCustomizedMakeupViewModel *customizedMakeupViewModel;

@end

@implementation FUMakeupComponentManager

#pragma mark - Class methods

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        makeupComponentManager = [[FUMakeupComponentManager alloc] init];
    });
    return makeupComponentManager;
}

+ (void)destory {
    onceToken = 0;
    makeupComponentManager = nil;
}

#pragma mark - Instance methods

- (void)addComponentViewToView:(UIView *)view {
    NSAssert(view != nil, @"FUMakeupComponent: view can not be nil!");
    self.targetView = view;
    [self.targetView addSubview:self.combinationMakeupView];
    [self.targetView addSubview:self.customizedMakeupView];
    [self.targetView addSubview:self.colorPicker];
}

- (void)removeComponentView {
    if (self.combinationMakeupView.superview) {
        [self.combinationMakeupView removeFromSuperview];
    }
    if (self.customizedMakeupView.superview) {
        [self.customizedMakeupView removeFromSuperview];
    }
    if (self.colorPicker.superview) {
        [self.colorPicker removeFromSuperview];
    }
}

#pragma mark - Private methods

// 组合妆的各个子妆是否被自定义改变
- (BOOL)combinationMakeupIsChangedByCustoming {
    for (NSUInteger index = FUSubMakeupTypeFoundation; index <= FUSubMakeupTypePupil; index++) {
        
        NSUInteger index1 = [self.combinationMakeupViewModel subMakeupIndexOfSelectedCombinationMakeupWithType:index];
        NSUInteger index2 = [self.customizedMakeupViewModel subMakeupIndexWithType:index];
        
        double value1 = [self.combinationMakeupViewModel subMakeupValueOfSelectedCombinationMakeupWithType:index];
        double value2 = [self.customizedMakeupViewModel subMakeupValueWithType:index];
        
        NSUInteger colorIndex1 = [self.combinationMakeupViewModel subMakeupColorIndexOfSelectedCombinationMakeupWithType:index];
        NSUInteger colorIndex2 = [self.customizedMakeupViewModel subMakeupColorIndexWithType:index];
        
        BOOL isSameIndex = index1 == index2;
        BOOL isSameValue = fabs(value1 - value2) <= 0.01;
        BOOL isSameColor = colorIndex1 == colorIndex2;
        
        if (!isSameIndex || !isSameValue || !isSameColor) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - FUCombinationMakeupViewDelegate

- (void)combinationMakeupViewDidClickCustomize {
    // 自定义默认从第一项开始
    self.customizedMakeupViewModel.selectedCategoryIndex = 0;
    if (self.combinationMakeupViewModel.selectedIndex >= 0) {
        // 自定义前遍历更新各个子妆
        for (NSUInteger index = FUSubMakeupTypeFoundation; index <= FUSubMakeupTypePupil; index++) {
            [self.customizedMakeupViewModel updateCustomizedMakeupsWithSubMakeupType:index selectedSubMakeupIndex:[self.combinationMakeupViewModel subMakeupIndexOfSelectedCombinationMakeupWithType:index] selectedSubMakeupValue:[self.combinationMakeupViewModel subMakeupValueOfSelectedCombinationMakeupWithType:index] selectedColorIndex:[self.combinationMakeupViewModel subMakeupColorIndexOfSelectedCombinationMakeupWithType:index]];
        }
    }
    [self.combinationMakeupView dismiss];
    [self.customizedMakeupView show];
    [self customizedMakeupViewDidChangeSubMakeup:self.customizedMakeupViewModel.selectedSubMakeupTitle];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeupComponentViewHeightDidChange:)]) {
        [self.delegate makeupComponentViewHeightDidChange:FUMakeupHeightIncludeBottomSafeArea(190)];
    }
}

#pragma mark - FUCustomizedMakeupViewDelegate

- (void)customizedMakeupViewDidClickBack {
    // 返回组合妆时需要判断子妆是否变化
    if (self.combinationMakeupViewModel.selectedIndex >= 0 && [self combinationMakeupIsChangedByCustoming]) {
        [self.combinationMakeupView deselectCurrentCombinationMakeup];
    }
    self.colorPicker.hidden = YES;
    [self.customizedMakeupView dismiss];
    [self.combinationMakeupView show];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeupComponentViewHeightDidChange:)]) {
        [self.delegate makeupComponentViewHeightDidChange:FUMakeupHeightIncludeBottomSafeArea(144)];
    }
}

- (void)customizedMakeupViewDidChangeSubMakeup:(NSString *)title {
    self.colorPicker.hidden = !self.customizedMakeupViewModel.needsColorPicker;
    if (!self.colorPicker.hidden) {
        self.colorPicker.colors = self.customizedMakeupViewModel.currentColors;
        [self.colorPicker selectAtIndex:self.customizedMakeupViewModel.selectedColorIndex];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeupComponentNeedsDisplayPromptContent:)]) {
        [self.delegate makeupComponentNeedsDisplayPromptContent:title];
    }
}

#pragma mark - FUCustomizedMakeupColorPickerDelegate

- (void)colorPickerDidSelectColorAtIndex:(NSUInteger)index {
    self.customizedMakeupViewModel.selectedColorIndex = index;
}

#pragma mark - Getters

- (FUCombinationMakeupView *)combinationMakeupView {
    if (!_combinationMakeupView) {
        _combinationMakeupView = [[FUCombinationMakeupView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUMakeupHeightIncludeBottomSafeArea(144), CGRectGetWidth(self.targetView.bounds), FUMakeupHeightIncludeBottomSafeArea(144)) viewModel:self.combinationMakeupViewModel];
        _combinationMakeupView.delegate = self;
    }
    return _combinationMakeupView;
}

- (FUCustomizedMakeupView *)customizedMakeupView {
    if (!_customizedMakeupView) {
        _customizedMakeupView = [[FUCustomizedMakeupView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - FUMakeupHeightIncludeBottomSafeArea(190), CGRectGetWidth(self.targetView.bounds), FUMakeupHeightIncludeBottomSafeArea(190)) viewModel:self.customizedMakeupViewModel];
        // 自定义美妆视图默认隐藏
        _customizedMakeupView.transform = CGAffineTransformMakeTranslation(0, FUMakeupHeightIncludeBottomSafeArea(190));
        _customizedMakeupView.hidden = YES;
        _customizedMakeupView.delegate = self;
    }
    return _customizedMakeupView;
}

- (FUCustomizedMakeupColorPicker *)colorPicker {
    if (!_colorPicker) {
        _colorPicker = [[FUCustomizedMakeupColorPicker alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.targetView.bounds) - 75, CGRectGetHeight(self.targetView.bounds) - FUMakeupHeightIncludeBottomSafeArea(192) - 250, 60, 250)];
        _colorPicker.hidden = YES;
        _colorPicker.delegate = self;
    }
    return _colorPicker;
}

- (FUCombinationMakeupViewModel *)combinationMakeupViewModel {
    if (!_combinationMakeupViewModel) {
        _combinationMakeupViewModel = [[FUCombinationMakeupViewModel alloc] init];
    }
    return _combinationMakeupViewModel;
}

- (FUCustomizedMakeupViewModel *)customizedMakeupViewModel {
    if (!_customizedMakeupViewModel) {
        _customizedMakeupViewModel = [[FUCustomizedMakeupViewModel alloc] init];
    }
    return _customizedMakeupViewModel;
}

- (CGFloat)componentViewHeight {
    if (self.combinationMakeupView.hidden) {
        return FUMakeupHeightIncludeBottomSafeArea(190);
    } else {
        return FUMakeupHeightIncludeBottomSafeArea(144);
    }
}

@end
