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
#import "FUYItuController.h"
#import "FUMusicFilterController.h"
#import "FUGanController.h"
#import "FUFacepupController.h"
#import "FUBGSegmentationController.h"

@interface FUMainViewController ()

@property (nonatomic, strong) NSArray *dataArray ;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@end

@implementation FUMainViewController

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [FUManager shareManager].dataSource;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collection.userInteractionEnabled = YES ;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FULiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FULive_Cell" forIndexPath:indexPath];
    
    cell.model = (FULiveModel *)self.dataArray[indexPath.row] ;
    
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FUHeader" forIndexPath:indexPath];
    }
    return nil ;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.view.frame.size.width - 72 )/ 3.0 ;
    
    return CGSizeMake(width, width / 101.0 * 122 ) ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width / 375.0 * 212) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    collectionView.userInteractionEnabled = NO ;
    
    FULiveModel *model = (FULiveModel *)self.dataArray[indexPath.row] ;
    [FUManager shareManager].currentModel = model;
    
    /* 进入不同控制器 */
    switch (model.type) {
        case FULiveModelTypeBeautifyFace:{
            FUBeautyController *vc = [[FUBeautyController alloc] init];
            vc.model = model;
            vc.view.backgroundColor = [UIColor grayColor];
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
            
        case FULiveModelTypeYiTu:{
            FUYItuController *vc = [[FUYItuController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeMusicFilter:{
            FUMusicFilterController *vc = [[FUMusicFilterController alloc] init];
            vc.model = model;
             vc.view.backgroundColor = [UIColor grayColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    
        case FULiveModelTypeGan:{
            FUGanController *vc = [[FUGanController alloc] init];
            vc.model = model;
            vc.view.backgroundColor = [UIColor grayColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeNieLian:{
            FUFacepupController *vc = [[FUFacepupController alloc] init];
            vc.model = model;
            vc.view.backgroundColor = [UIColor grayColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case FULiveModelTypeBGSegmentation:{
            FUBGSegmentationController *vc = [[FUBGSegmentationController alloc] init];
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
