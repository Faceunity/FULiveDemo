//
//  FUMakeupViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMakeupViewController.h"

#import "FUCombinationMakeupView.h"
#import "FUCustomizedMakeupView.h"
#import "FUColourView.h"

#import "FUMakeupManager.h"

#import "FUCombinationMakeupModel.h"
#import "FUMakeupModel.h"
#import "FUSingleMakeupModel.h"

@interface FUMakeupViewController ()<FUCombinationMakeupViewDelegate, FUCustomizedMakeupViewDelegate, FUColourViewDelegate>

/// 组合妆选择视图
@property (nonatomic, strong) FUCombinationMakeupView *combinationMakeupView;
/// 自定义子妆视图
@property (nonatomic, strong) FUCustomizedMakeupView *customizedMakeupView;
/// 子妆颜色选择视图
@property (nonatomic, strong) FUColourView *colorSelectView;

@property (nonatomic, strong) FUMakeupManager *makeupManager;

@end

@implementation FUMakeupViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 添加点位测试开关
    if (FUShowLandmark) {
        [FULandmarkManager show];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 移除点位测试开关
    if (FUShowLandmark) {
        [FULandmarkManager dismiss];
    }
}

#pragma mark - UI

- (void)configureUI {
    
    [self.view insertSubview:self.combinationMakeupView belowSubview:self.photoBtn];
    [self.combinationMakeupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(144));
    }];
    
    [self.view insertSubview:self.customizedMakeupView belowSubview:self.photoBtn];
    [self.customizedMakeupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(190));
    }];
    
    // 自定义美妆视图默认隐藏
    self.customizedMakeupView.transform = CGAffineTransformMakeTranslation(0, FUHeightIncludeBottomSafeArea(190));
    self.customizedMakeupView.hidden = YES;
    
    [self.view addSubview:self.colorSelectView];
    [self.colorSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).mas_offset(-15);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-192);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-192);
        }
        make.size.mas_offset(CGSizeMake(60, 250));
    }];
    
    // 调整拍照按钮位置
    self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));
}

#pragma mark - Private methods

/// 更新美颜滤镜
- (void)updateBeautyFilter:(FUCombinationMakeupModel *)model {
    if (!model.selectedFilter || [model.selectedFilter isEqualToString:@""]) {
        // 没有滤镜则使用默认滤镜"origin"
        self.baseManager.beauty.filterName = @"origin";
        self.baseManager.beauty.filterLevel = model.value;
    } else {
        self.baseManager.beauty.filterName = [model.selectedFilter lowercaseString];
        self.baseManager.beauty.filterLevel = model.value;
    }
}

- (void)refreshColorViewWithIndex:(NSInteger)index {
    if (index < 0 || index >= self.makeupManager.makeups.count) {
        return;
    }
    FUMakeupModel *model = self.makeupManager.makeups[index];
    FUSingleMakeupModel *singleModel = model.singleMakeups[model.selectedIndex];
    if (singleModel.type == FUSingleMakeupTypeFoundation || singleModel.colors.count == 0) {
        self.colorSelectView.hidden = YES;
    } else {
        self.colorSelectView.hidden = NO;
        [self.colorSelectView setDataColors:singleModel.colors];
        [self.colorSelectView setSelCell:(int)singleModel.defaultColorIndex];
    }
}

#pragma mark - Event response

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}

#pragma mark - FUCombinationMakeupViewDelegate

- (void)combinationMakeupView:(FUCombinationMakeupView *)view didSelectCombinationMakeup:(FUCombinationMakeupModel *)model {
    if (!model.isCombined) {
        // 老组合妆需要更新美颜滤镜，滤镜值设置给Beauty
        [self updateBeautyFilter:model];
    } else {
        // 新组合妆，更新滤镜，滤镜值设置给Makeup
        if (!model.selectedFilter || [model.selectedFilter isEqualToString:@""]) {
            self.baseManager.beauty.filterName = @"origin";
        } else {
            self.baseManager.beauty.filterName = [model.selectedFilter lowercaseString];
        }
    }
    self.makeupManager.currentCombinationMakeupModel = model;
}

- (void)combinationMakeupView:(FUCombinationMakeupView *)view didChangeCombinationMakeupValue:(FUCombinationMakeupModel *)model {
    [self.makeupManager updateIntensityOfCombinationMakeup:model];
    if (!model.isCombined) {
        // 老组合妆需要更新美颜滤镜
        [self updateBeautyFilter:model];
    }
}

- (void)combinationMakeupViewDidClickCustomize {
    // 对比更新自定义妆容数据
    [self.makeupManager compareCustomizedMakeupsWithCurrentCombinationMakeup];
    [self.customizedMakeupView reloadData:self.makeupManager.makeups];
    // 每次进入自定义页面默认从头开始自定义
    [self.customizedMakeupView selectMakeupAtIndex:0];
    // 刷新颜色选择控件
    [self refreshColorViewWithIndex:0];
    // UI
    [self.combinationMakeupView dismiss];
    [self.customizedMakeupView show];
    [UIView animateWithDuration:0.2 animations:^{
        self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -160), CGAffineTransformMakeScale(0.8, 0.8));
    }];
}

#pragma mark - FUCustomizedMakeupViewDelegate

- (void)customizedMakeupView:(FUCustomizedMakeupView *)view didChangeMakeupCategoryWithSingleMakeup:(FUSingleMakeupModel *)model {
    if (model.colors.count > model.defaultColorIndex) {
        // 更新颜色值
        [self.makeupManager updateColorOfCustomizedSingleMakeup:model];
        // 刷新颜色选择控件
        [self refreshColorViewWithIndex:model.type];
    } else {
        self.colorSelectView.hidden = YES;
    }
}

- (void)customizedMakeupView:(FUCustomizedMakeupView *)view didSelectedSingleMakeup:(FUSingleMakeupModel *)model {
    model.realValue = model.value;
    // 更新子妆bundle
    [self.makeupManager updateCustomizedSingleMakeup:model];
    // 更新程度值
    [self.makeupManager updateIntensityOfSingleMakeup:model];
    if (model.colors.count > model.defaultColorIndex) {
        // 更新颜色值
        [self.makeupManager updateColorOfCustomizedSingleMakeup:model];
        // 刷新颜色选择控件
        [self refreshColorViewWithIndex:model.type];
    } else {
        self.colorSelectView.hidden = YES;
    }
    // 单个妆容标题提示
    if (model.title) {
        self.tipLabel.hidden = NO;
        self.tipLabel.text = FUNSLocalizedString(model.title, nil);
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    }
}

- (void)customizedMakeupView:(FUCustomizedMakeupView *)view didChangeSingleMakeupValue:(FUSingleMakeupModel *)model {
    model.realValue = model.value;
    [self.makeupManager updateIntensityOfSingleMakeup:model];
}

- (void)customizedMakeupViewDidClickBack {
    // 根据自定义后妆容是否有变化决定是否选中组合妆
    if (self.makeupManager.isChangedMakeup) {
        [self.combinationMakeupView deselectCurrentCombinationMakeup];
        self.makeupManager.currentCombinationMakeupModel = nil;
    }
    // UI
    if (!self.colorSelectView.hidden) {
        self.colorSelectView.hidden = YES;
    }
    [self.customizedMakeupView dismiss];
    [self.combinationMakeupView show];
    [UIView animateWithDuration:0.2 animations:^{
        self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));
    }];
}

#pragma mark - FUColourViewDelegate

- (void)colourViewDidSelIndex:(int)index {
    FUMakeupModel *makeupModel = self.makeupManager.makeups[self.customizedMakeupView.selectedCategoryIndex];
    FUSingleMakeupModel *singleMakeupModel = makeupModel.singleMakeups[makeupModel.selectedIndex];
    singleMakeupModel.defaultColorIndex = index;
    [self.makeupManager updateColorOfCustomizedSingleMakeup:singleMakeupModel];
}

#pragma mark - Getters

- (FUCombinationMakeupView *)combinationMakeupView {
    if (!_combinationMakeupView) {
        _combinationMakeupView = [[FUCombinationMakeupView alloc] initWithFrame:CGRectZero];
        [_combinationMakeupView reloadData:self.makeupManager.combinationMakeups];
        _combinationMakeupView.delegate = self;
        // 默认选中
        [_combinationMakeupView selectCombinationMakeupAtIndex:1];
    }
    return _combinationMakeupView;
}

- (FUCustomizedMakeupView *)customizedMakeupView {
    if (!_customizedMakeupView) {
        _customizedMakeupView = [[FUCustomizedMakeupView alloc] initWithFrame:CGRectZero];
        _customizedMakeupView.delegate = self;
    }
    return _customizedMakeupView;
}

- (FUColourView *)colorSelectView {
    if (!_colorSelectView) {
        _colorSelectView = [[FUColourView alloc] initWithFrame:CGRectMake(0, 0, 60, 250)];
        _colorSelectView.delegate = self;
        _colorSelectView.hidden = YES;
    }
    return _colorSelectView;
}

- (FUMakeupManager *)makeupManager {
    if (!_makeupManager) {
        _makeupManager = [[FUMakeupManager alloc] init];
    }
    return _makeupManager;
}

@end
