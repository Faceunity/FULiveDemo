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

#import "FUBeautyViewController.h"
#import "FUMakeupViewController.h"
#import "FUStickerViewController.h"
#import "FUAnimojiViewController.h"
#import "FUHairBeautyViewController.h"
#import "FULightMakeupViewController.h"
#import "FUARMaskViewController.h"
#import "FUHilariousViewController.h"
#import "FUFaceFusionCollectionViewController.h"
#import "FUExpressionRecognitionViewController.h"
#import "FUMusicFilterViewController.h"
#import "FUDistortingMirrorViewController.h"
#import "FUSegmentationViewController.h"
#import "FUGestureRecognitionViewController.h"
#import "FUBodyBeautyViewController.h"
#import "FUBodyAvatarViewController.h"
#import "FUGreenScreenViewController.h"
#import "FUQualityStickerViewController.h"

static NSString * const kFUHomepageModuleCellIdentifier = @"FUHomepageModuleCell";
static NSString * const kFUHomepageHeaderViewIdentifier = @"FUHomepageHeaderView";

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
    [[FURenderKitManager sharedManager] setupRenderKit];
    
    [self configureUI];
}

#pragma mark - UI

- (void)configureUI {
    self.view.backgroundColor = FUColorFromHex(0x090017);
    
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
    UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homepage_background_top"]];
    topImageView.frame = CGRectMake(0, -offsetHeight, CGRectGetWidth(self.view.bounds), offsetHeight);
    [self.collectionView addSubview:topImageView];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel modulesCountOfGroup:section];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUHomepageModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUHomepageModuleCellIdentifier forIndexPath:indexPath];
    cell.iconImageView.image = [self.viewModel moduleIconAtIndex:indexPath.item group:indexPath.section];
    cell.titleLabel.text = [self.viewModel moduleTitleAtIndex:indexPath.item group:indexPath.section];
    cell.bottomImageView.image =
    cell.bottomImageView.image = [self.viewModel moduleBottomBackgroundImageAtIndex:indexPath.item group:indexPath.section];
    if ([self.viewModel moduleAtIndex:indexPath.item group:indexPath.section] == FUModuleQualityTicker) {
        // 精品贴纸特殊效果
        cell.backgroundImageView.hidden = NO;
        cell.animationView.hidden = NO;
        cell.backgroundImageView.image = [UIImage imageNamed:@"homepage_cell_background"];
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
        header.titleLabel.text = [self.viewModel groupNameOfGroup:indexPath.section];
        return header;
    }
    return nil;
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel moduleEnableStatusAtIndex:indexPath.item group:indexPath.section];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller;
    switch ([self.viewModel moduleAtIndex:indexPath.item group:indexPath.section]) {
        case FUModuleBeauty:{
            controller = [[FUBeautyViewController alloc] initWithViewModel:[[FUBeautyViewModel alloc] init]];
        }
            break;
        case FUModuleMakeup:{
            controller = [[FUMakeupViewController alloc] initWithViewModel:[[FUMakeupViewModel alloc] init]];
        }
            break;
        case FUModuleSticker:{
            controller = [[FUStickerViewController alloc] initWithViewModel:[[FUStickerViewModel alloc] init]];
        }
            break;
        case FUModuleAnimoji:{
            controller = [[FUAnimojiViewController alloc] initWithViewModel:[[FUAnimojiViewModel alloc] init]];
        }
            break;
        case FUModuleHairBeauty:{
            controller = [[FUHairBeautyViewController alloc] initWithViewModel:[[FUHairBeautyViewModel alloc] init]];
        }
            break;
        case FUModuleLightMakeup:{
            controller = [[FULightMakeupViewController alloc] initWithViewModel:[[FULightMakeupViewModel alloc] init]];
        }
            break;
        case FUModuleARMask: {
            controller = [[FUARMaskViewController alloc] initWithViewModel:[[FUARMaskViewModel alloc] init]];
        }
            break;
        case FUModuleHilarious: {
            controller = [[FUHilariousViewController alloc] initWithViewModel:[[FUHilariousViewModel alloc] init]];
        }
            break;
        case FUModuleFaceFusion:{
            controller = [[FUFaceFusionCollectionViewController alloc] init];
        }
            break;
        case FUModuleExpressionRecognition: {
            controller = [[FUExpressionRecognitionViewController alloc] initWithViewModel:[[FUExpressionRecognitionViewModel alloc] init]];
        }
            break;
        case FUModuleMusicFilter:{
            controller = [[FUMusicFilterViewController alloc] initWithViewModel:[[FUMusicFilterViewModel alloc] init]];
        }
            break;
        case FUModuleDistortingMirror:{
            controller = [[FUDistortingMirrorViewController alloc] initWithViewModel:[[FUDistortingMirrorViewModel alloc] init]];
        }
            break;
        case FUModuleBodyBeauty:{
            controller = [[FUBodyBeautyViewController alloc] initWithViewModel:[[FUBodyBeautyViewModel alloc] init]];
        }
            break;
        case FUModuleBodyAvatar:{
            controller = [[FUBodyAvatarViewController alloc] initWithViewModel:[[FUBodyAvatarViewModel alloc] init]];
        }
            break;
        case FUModuleSegmentation:{
            controller = [[FUSegmentationViewController alloc] initWithViewModel:[[FUSegmentationViewModel alloc] init]];
        }
            break;
        case FUModuleGestureRecognition:{
            controller = [[FUGestureRecognitionViewController alloc] initWithViewModel:[[FUGestureRecognitionViewModel alloc] init]];
        }
            break;
        case FUModuleGreenScreen:{
            controller = [[FUGreenScreenViewController alloc] initWithViewModel:[[FUGreenScreenViewModel alloc] init]];
        }
                break;
        case FUModuleQualityTicker:{
            controller = [[FUQualityStickerViewController alloc] initWithViewModel:[[FUQualityStickerViewModel alloc] init]];
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
    return 16;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 长宽固定比例
    CGFloat width = (CGRectGetWidth(self.view.frame) - 72) / 3.0;
    CGFloat height = width / 101.0 * 122.0;
    if (indexPath.section == FUGroupContentService) {
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
        _navigationView.backgroundColor = FUColorFromHex(0x030010);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = FULocalizedString(@"FU Live Demo 特效版");
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        [_navigationView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_navigationView);
        }];

        UIView *line = [[UIView alloc] init];
        line.backgroundColor = FUColorFromHex(0x302D33);
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
        _collectionView.backgroundColor = FUColorFromHex(0x090017);
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

#pragma mark - Overriding

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
