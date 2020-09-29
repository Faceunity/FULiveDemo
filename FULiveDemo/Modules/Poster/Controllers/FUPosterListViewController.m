//
//  FUPosterListViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/8.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUPosterListViewController.h"
#import "FUPosterCell.h"
#import "FUManager.h"
#import "FUPosterController.h"

@interface FUPosterListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/* 图片数组 */
@property (nonatomic, strong) NSArray <NSString *>*dataArray ;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) float itemW;
@property (nonatomic, assign) float itemH;
@end

static NSString *registerID = @"PosterCell";
@implementation FUPosterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    _titleLabel.text = FUNSLocalizedString(@"海报换脸", nil);
    
    self.view.backgroundColor = [UIColor colorWithRed:9/255 green:0 blue:23/255 alpha:1.0];
    _mPosterCollectionView.backgroundColor = [UIColor colorWithRed:9/255 green:0 blue:23/255 alpha:1.0];
    
    _mPosterCollectionView.delegate = self;
    _mPosterCollectionView.dataSource = self;
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in _model.items) {
        [array addObject:[NSString stringWithFormat:@"%@_list",str]];
    }
    _dataArray = array;
    
    _itemW = ([UIScreen mainScreen].bounds.size.width - 17 * 3) / 2;
    _itemH = _itemW/324 * 358;
    
    //注册
     [_mPosterCollectionView registerNib:[UINib nibWithNibName:@"FUPosterCell" bundle:nil] forCellWithReuseIdentifier:registerID];
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}


#pragma  mark ----  UI action  -----

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FUPosterCell *cell = (FUPosterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:registerID forIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor redColor];
    cell.mImageView.image = [UIImage imageNamed:_dataArray[indexPath.row]];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(_itemW, _itemH);
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(17, 17, 17, 17);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FUPosterController *vc = [[FUPosterController alloc] init];
    _model.selIndex = (int)indexPath.row;
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma  mark ----  重载系统方法  -----
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}


-(void)dealloc{
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeChangeface];
}
@end
