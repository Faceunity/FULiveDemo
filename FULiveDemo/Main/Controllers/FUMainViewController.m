//
//  ViewController.m
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUMainViewController.h"
#import "FUManager.h"
#import "FULiveModel.h"
#import "FULiveCell.h"

#import "FUBeautyController.h"
#import "FUMakeupController.h"
#import "FUNormalItemController.h"
#import "FUPosterListViewController.h"
#import "FUAnimojiController.h"
#import "FUHairController.h"
#import "FUMusicFilterController.h"
#import "FUBGSegmentationController.h"
#import "FUBodyBeautyController.h"
#import "FULightMakeupController.h"
#import "FUHeadReusableView.h"
#import "FUBodyAvatarController.h"
#import "FULvMuViewController.h"

#import "FUMainViewControllerManager.h"
#import "FUQStickersViewController.h"

#import <SVProgressHUD.h>

static NSString *headerViewID = @"MGHeaderView";

@interface FUMainViewController ()

@property (nonatomic, strong) NSArray<NSArray<FULiveModel *>*> *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) FUMainViewControllerManager *manager;
@end

@implementation FUMainViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化FURenderKit 环境
    [[FUManager shareManager] setupRenderKit];
    self.manager = [[FUMainViewControllerManager alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:0/255.0 blue:16/255.0 alpha:1.0];
    self.dataArray = self.manager.dataSource;
    
    CGFloat collectionWidth = CGRectGetWidth(self.collection.bounds);
    CGFloat topHight = collectionWidth*456/750;
    self.collection.contentInset = UIEdgeInsetsMake(topHight, 0, 0, 0);
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homeview_background_top.png"]];
    topImage.frame = CGRectMake(0, -topHight, collectionWidth, topHight);
    [self.collection addSubview:topImage];
    [self.collection registerClass:[FUHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collection.userInteractionEnabled = YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FULiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FULive_Cell" forIndexPath:indexPath];

    cell.model = (FULiveModel *)self.dataArray[indexPath.section][indexPath.row] ;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        FUHeadReusableView *headerView= (FUHeadReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = FUNSLocalizedString(@"人脸特效", nil) ;
        }else if (indexPath.section == 1) {
            headerView.titleLabel.text = FUNSLocalizedString(@"人体特效", nil) ;
        } else {
            headerView.titleLabel.text = FUNSLocalizedString(@"Content service", nil) ;
        }
        return headerView;
    }
    return nil;

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = (self.view.frame.size.width - 72 )/ 3.0 ;
    CGFloat height = width / 101.0 * 122;
    if (indexPath.section == 2) {
        width = self.view.frame.size.width - 32;
    }
    return CGSizeMake(width, height) ;
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d",self.navigationController.navigationBar.isHidden);
    collectionView.userInteractionEnabled = NO ;
    
    FULiveModel *model = (FULiveModel *)self.dataArray[indexPath.section][indexPath.row];
    [FUManager shareManager].currentModel = model;
    
    if (!model.enble) {
        collectionView.userInteractionEnabled = YES ;
        return;
    }
    
    /* 进入不同控制器 */
    switch (model.type) {
        case FULiveModelTypeBeautifyFace:{
            FUBeautyController *vc = [[FUBeautyController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeMakeUp:{
            FUMakeupController *vc = [[FUMakeupController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypePoster:{
            FUPosterListViewController *vc = [[FUPosterListViewController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeAnimoji:{
            FUAnimojiController *vc = [[FUAnimojiController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FULiveModelTypeQSTickers:{
            FUQStickersViewController *vc = [[FUQStickersViewController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeHair:{
            FUHairController *vc = [[FUHairController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeWholeAvatar:{
            FUBodyAvatarController *vc = [[FUBodyAvatarController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FULiveModelTypeMusicFilter:{
            FUMusicFilterController *vc = [[FUMusicFilterController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    
        case FULiveModelTypeHilarious:{
            FUNormalItemController *vc = [[FUNormalItemController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeBGSegmentation:{
            FUBGSegmentationController *vc = [[FUBGSegmentationController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeBody:{
            FUBodyBeautyController *vc = [[FUBodyBeautyController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
          
        case FULiveModelTypeLightMakeup:{
            FULightMakeupController *vc = [[FULightMakeupController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeLvMu:{
                FULvMuViewController *vc = [[FULvMuViewController alloc] init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        case FULiveModelTypeGestureRecognition: {
            FUNormalItemController *vc = [[FUNormalItemController alloc] init];
            vc.type = FUGestureType;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:{
            FUNormalItemController *vc = [[FUNormalItemController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
    }
    collectionView.userInteractionEnabled = YES ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
