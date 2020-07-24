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
#import <SVProgressHUD.h>

#import "FUBeautyController.h"
#import "FUMakeupController.h"
#import "FUNormalItemController.h"
#import "FUPosterListViewController.h"
#import "FUAnimojiController.h"
#import "FUHairController.h"
#import "FUMusicFilterController.h"
#import "FUGanController.h"
#import "FUBGSegmentationController.h"
#import "FUBodyBeautyController.h"
#import "FULightMakeupController.h"
#import "FUHeadReusableView.h"
#import "FUActionRecognitionController.h"
#import "FUBodyAvtarController.h"

static NSString *headerViewID = @"MGHeaderView";
@interface FUMainViewController ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray<FULiveModel *>*> *dataArray ;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@end

@implementation FUMainViewController

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:0/255.0 blue:16/255.0 alpha:1.0];
    self.dataArray = [FUManager shareManager].dataSource;
    float w = [UIScreen mainScreen].bounds.size.width;
    float h = w * 456/750;

    self.collection.contentInset = UIEdgeInsetsMake(h, 0, 0, 0);
    UIImageView *imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homeview_background_top.png"]];
    imagev.frame = CGRectMake(0, -h, w, h);
    [self.collection addSubview: imagev];
    
    [self.collection registerClass:[FUHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collection.userInteractionEnabled = YES ;
}

#pragma mark - UICollectionViewDataSource

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
    FUHeadReusableView *headerView= (FUHeadReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = NSLocalizedString(@"人脸特效", nil) ;
        }else{
            headerView.titleLabel.text = NSLocalizedString(@"人体特效", nil) ;
        }
   
    return headerView;
    }
    
    return nil;

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = (self.view.frame.size.width - 72 )/ 3.0 ;

    return CGSizeMake(width, width / 101.0 * 122 ) ;
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
 return CGSizeMake(screenWidth, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
//            vc.view.backgroundColor = [UIColor grayColor];
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
            
        case FULiveModelTypeHair:{
            FUHairController *vc = [[FUHairController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeWholeAvatar:{
            FUBodyAvtarController *vc = [[FUBodyAvtarController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FULiveModelTypeMusicFilter:{
            FUMusicFilterController *vc = [[FUMusicFilterController alloc] init];
            vc.model = model;
//             vc.view.backgroundColor = [UIColor grayColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    
        case FULiveModelTypeHilarious:{
            FUNormalItemController *vc = [[FUNormalItemController alloc] init];
            vc.model = model;
//            vc.view.backgroundColor = [UIColor grayColor];
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
        
        case FULiveModelTypeActionRecognition:{
                FUActionRecognitionController *vc = [[FUActionRecognitionController alloc] init];
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
