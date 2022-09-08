//
//  FUHomepageViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHomepageViewController.h"
#import "FUHomepageModuleCell.h"
#import "FUHomepageHeaderView.h"

#import "FUHomepageViewModel.h"

#import "FUBeautyController.h"
#import "FUMakeupViewController.h"
#import "FUStickerViewController.h"
#import "FUAnimojiController.h"
#import "FUHairController.h"
#import "FULightMakeupController.h"
#import "FUARMaskViewController.h"
#import "FUHilariousViewController.h"
#import "FUPosterListViewController.h"
#import "FUExpressionRecognitionViewController.h"
#import "FUMusicFilterController.h"
#import "FUDistortingMirrorViewController.h"
#import "FUBGSegmentationController.h"
#import "FUGestureRecognitionViewController.h"
#import "FUBodyBeautyController.h"
#import "FUBodyAvatarController.h"
#import "FULvMuViewController.h"
#import "FUQStickersViewController.h"

NSString * const kFUHomepageModuleCellIdentifier = @"FUHomepageModuleCell";
NSString * const kFUHomepageHeaderViewIdentifier = @"FUHomepageHeaderView";

@interface FUHomepageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) FUHomepageViewModel *viewModel;

@end

@implementation FUHomepageViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化FURenderKit
    [[FUManager shareManager] setupRenderKit];
    
    [self configureUI];
}

#pragma mark - UI

- (void)configureUI {
    self.view.backgroundColor = [UIColor colorWithHexColorString:@"090017"];
    
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top).mas_offset(20);
        }
        make.height.mas_offset(44);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    CGFloat offsetHeight = CGRectGetWidth(self.view.bounds) * 456 / 750;
    self.collectionView.contentInset = UIEdgeInsetsMake(offsetHeight, 0, 0, 0);
    UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homeview_background_top.png"]];
    topImageView.frame = CGRectMake(0, -offsetHeight, CGRectGetWidth(self.view.bounds), offsetHeight);
    [self.collectionView addSubview:topImageView];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataSource[section].modules.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUHomepageModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUHomepageModuleCellIdentifier forIndexPath:indexPath];
    FUHomepageModule *module = self.viewModel.dataSource[indexPath.section].modules[indexPath.item];
    cell.iconImageView.image = [UIImage imageNamed:module.title];
    cell.titleLabel.text = FUNSLocalizedString(module.title, nil);
    cell.bottomImageView.image = module.enable ? [UIImage imageNamed:@"bottomImage"] : [UIImage imageNamed:@"bottomImage_gray"];
    if (module.type == FUModuleTypeQualityTicker) {
        // 精品贴纸特殊效果
        cell.backgroundImageView.hidden = NO;
        cell.animationView.hidden = NO;
        cell.backgroundImageView.image = [UIImage imageNamed:@"bg_card_small_elements"];
        [cell.animationView setAnimationNamed:@"tiezhi_data"];
        cell.animationView.loopAnimation = YES;
        [cell.animationView play];
    } else {
        cell.backgroundImageView.hidden = YES;
        cell.animationView.hidden = YES;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        FUHomepageHeaderView *header = (FUHomepageHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFUHomepageHeaderViewIdentifier forIndexPath:indexPath];
        FUHomepageGroup *group = self.viewModel.dataSource[indexPath.section];
        header.titleLabel.text = FUNSLocalizedString(group.name, nil);
        return header;
    }
    return nil;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FUHomepageModule *module = self.viewModel.dataSource[indexPath.section].modules[indexPath.item];
    if (!module.enable) {
        return;
    }
    UIViewController *controller;
    switch (module.type) {
        case FUModuleTypeBeauty:{
            controller = [[FUBeautyController alloc] init];
        }
            break;
        case FUModuleTypeMakeup:{
            controller = [[FUMakeupViewController alloc] init];
        }
            break;
        case FUModuleTypeSticker:{
            controller = [[FUStickerViewController alloc] init];
        }
            break;
        case FUModuleTypeAnimoji:{
            controller = [[FUAnimojiController alloc] init];
        }
            break;
        case FUModuleTypeHair:{
            controller = [[FUHairController alloc] init];
        }
            break;
        case FUModuleTypeLightMakeup:{
            controller = [[FULightMakeupController alloc] init];
        }
            break;
        case FUModuleTypeARMask: {
            controller = [[FUARMaskViewController alloc] init];
        }
            break;
        case FUModuleTypeHilarious: {
            controller = [[FUHilariousViewController alloc] init];
        }
            break;
        case FUModuleTypePoster:{
            controller = [[FUPosterListViewController alloc] init];
        }
            break;
        case FUModuleTypeExpressionRecognition: {
            controller = [[FUExpressionRecognitionViewController alloc] init];
        }
            break;
        case FUModuleTypeMusicFilter:{
            controller = [[FUMusicFilterController alloc] init];
        }
            break;
        case FUModuleTypeDistortingMirror:{
            controller = [[FUDistortingMirrorViewController alloc] init];
        }
            break;
        case FUModuleTypeBody:{
            controller = [[FUBodyBeautyController alloc] init];
        }
            break;
        case FUModuleTypeWholeAvatar:{
            controller = [[FUBodyAvatarController alloc] init];
        }
            break;
        case FUModuleTypeSegmentation:{
            controller = [[FUBGSegmentationController alloc] init];
        }
            break;
        case FUModuleTypeGestureRecognition:{
            controller = [[FUGestureRecognitionViewController alloc] init];
        }
            break;
        case FUModuleTypeGreenScreen:{
            controller = [[FULvMuViewController alloc] init];
        }
                break;
        case FUModuleTypeQualityTicker:{
            controller = [[FUQStickersViewController alloc] init];
        }
            break;
        default:{
        }
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Collection view delegate flow layout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 16, 32, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 长宽固定比例
    CGFloat width = (CGRectGetWidth(self.view.frame) - 72) / 3.0;
    CGFloat height = width / 101.0 * 122.0;
    FUHomepageGroup *group = self.viewModel.dataSource[indexPath.section];
    if (group.type == FUGroupTypeContentService) {
        // 内容服务（精品贴纸）设置全屏宽度，宽度不变
        width = CGRectGetWidth(self.view.frame) - 32;
    }
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(self.view.frame), 44);
}

#pragma mark - Getters

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _navigationView.backgroundColor = [UIColor colorWithHexColorString:@"030010"];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = FUNSLocalizedString(@"FU Live Demo 特效版", nil);
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        [_navigationView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_navigationView);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexColorString:@"302D33"];
        [_navigationView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(_navigationView);
            make.height.mas_offset(1);
        }];
    }
    return _navigationView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexColorString:@"090017"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FUHomepageModuleCell class] forCellWithReuseIdentifier:kFUHomepageModuleCellIdentifier];
        [_collectionView registerClass:[FUHomepageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFUHomepageHeaderViewIdentifier];
    }
    return _collectionView;
}

- (FUHomepageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUHomepageViewModel alloc] init];
    }
    return _viewModel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
