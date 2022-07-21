//
//  FUMakeupRenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/6/14.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUMakeupRenderMediaViewController.h"

#import "FUCombinationMakeupView.h"
#import "FUCustomizedMakeupView.h"
#import "FUColourView.h"

#import "FUMakeupManager.h"

#import "FUCombinationMakeupModel.h"
#import "FUMakeupModel.h"
#import "FUSingleMakeupModel.h"

@interface FUMakeupRenderMediaViewController ()<FUCombinationMakeupViewDelegate, FUCustomizedMakeupViewDelegate, FUColourViewDelegate>

/// 组合妆选择视图
@property (nonatomic, strong) FUCombinationMakeupView *combinationMakeupView;
/// 自定义子妆视图
@property (nonatomic, strong) FUCustomizedMakeupView *customizedMakeupView;
/// 子妆颜色选择视图
@property (nonatomic, strong) FUColourView *colorSelectView;

@property (nonatomic, strong) FUMakeupManager *makeupManager;

@end

@implementation FUMakeupRenderMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureMakeupUI];
}

#pragma mark - UI

- (void)configureMakeupUI {
    
    [self.view addSubview:self.combinationMakeupView];
    [self.combinationMakeupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(144));
    }];
    
    [self.view addSubview:self.customizedMakeupView];
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
    
    [self refreshDownloadButtonTransformWithHeight:120 show:YES];
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
    
    [self refreshDownloadButtonTransformWithHeight:170 show:YES];
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
//    if (model.title) {
//        self.tipLabel.hidden = NO;
//        self.tipLabel.text = FUNSLocalizedString(model.title, nil);
//        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
//    }
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
    [self refreshDownloadButtonTransformWithHeight:120 show:YES];
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
