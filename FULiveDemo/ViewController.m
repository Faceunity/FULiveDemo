//
//  ViewController.m
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import "ViewController.h"
#import "FUManager.h"
#import "FULiveModel.h"
#import "FULiveCell.h"
#import "FURenderViewController.h"
#import <SVProgressHUD.h>

@interface ViewController ()

@property (nonatomic, strong) NSArray *dataArray ;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@end

@implementation ViewController

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

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FULiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FULive_Cell" forIndexPath:indexPath];
    
    cell.model = (FULiveModel *)self.dataArray[indexPath.row] ;
    
    return cell;
}
#pragma mark --- UICollectionViewDelegateFlowLayout
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FUHeader" forIndexPath:indexPath];
    }
    return nil ;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

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
    
    if (!model.enble) {
        
        collectionView.userInteractionEnabled = YES ;
        return ;
    }
    
    self.collection.userInteractionEnabled = NO ;
    [self performSegueWithIdentifier:@"showFULiveView" sender:model];
    
    collectionView.userInteractionEnabled = YES ;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showFULiveView"]) {
        
        FURenderViewController *renderController = (FURenderViewController *)segue.destinationViewController ;
        renderController.model = (FULiveModel *)sender ;
        [FUManager shareManager].currentModel = (FULiveModel *)sender ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
