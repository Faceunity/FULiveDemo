//
//  FUMyItemsViewController.m
//  FULiveDemo
//
//  Created by L on 2018/3/1.
//  Copyright © 2018年 刘洋. All rights reserved.
//

#import "FUMyItemsViewController.h"
#import "FUYItuSaveManager.h"
#import "FUYItuMeItemCell.h"

@interface FUMyItemsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *noItemImage;
@property (weak, nonatomic) IBOutlet UILabel *noItemLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iXBottom;

@property (nonatomic, strong) NSMutableArray *selectedIndex ;
@property (nonatomic, strong) NSMutableArray <FUYituModel *>*dataArray;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@end

@implementation FUMyItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.noItemImage.hidden = [FUManager shareManager].myStickers.count != 0;
//    self.noItemLabel.hidden = [FUManager shareManager].myStickers.count != 0;
    self.noItemLabel.text = FUNSLocalizedString(@"暂无制作道具哦~",nil);
    self.mTitleLabel.text = FUNSLocalizedString(@"删除道具",nil);
    [self.selectAllBtn setTitle:FUNSLocalizedString(@"全选",nil) forState:UIControlStateNormal];
     [self.deleteBtn setTitle:FUNSLocalizedString(@"删除",nil) forState:UIControlStateNormal];
    self.selectedIndex = [NSMutableArray arrayWithCapacity:1];
    
    [self.collectionView registerClass:[FUYItuMeItemCell class] forCellWithReuseIdentifier:@"YItuMeItemCell"];
    _dataArray = [NSMutableArray array];
    
    for (int i = 0; i  < [FUYItuSaveManager shareManager].dataDataArray.count ; i ++ ) {
        if (i  < defaultYiTuNum) {
            continue;
        }
         [_dataArray addObject:[FUYItuSaveManager shareManager].dataDataArray[i]];
    }
    if(_dataArray.count == 0){
        _noItemImage.hidden = NO;
        _noItemLabel.hidden = NO;
    }
    
//    if ([[FULiveTool getPlatformtype] isEqualToString:@"iPhone X"]) {
//        self.iXBottom.constant = 34 ;
//        [self.view layoutIfNeeded];
//    }
}

 //全选
- (IBAction)selectAllItems:(UIButton *)sender {

    if (_dataArray.count == 0) {
        return ;
    }

    if (_dataArray.count == self.selectedIndex.count) {

        [self.selectedIndex removeAllObjects];

        self.selectAllBtn.titleLabel.text =FUNSLocalizedString(@"全选",nil);
        [self.selectAllBtn setTitle:FUNSLocalizedString(@"全选",nil) forState:UIControlStateNormal ];
    }else {

        [self.selectedIndex removeAllObjects];
        for (int i = 0 ; i < _dataArray.count; i ++) {
            [self.selectedIndex addObject:@(i)];
        }

        self.selectAllBtn.titleLabel.text = FUNSLocalizedString(@"取消",nil);
        [self.selectAllBtn setTitle:FUNSLocalizedString(@"取消",nil) forState:UIControlStateNormal ];
    }
    [self deleteBtnRefreshTitle];
    [self.collectionView reloadData ];

}

// 删除
- (IBAction)deleteAction:(UIButton *)sender {
    if (self.selectedIndex.count == 0) {
        return ;
    }

    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:FUNSLocalizedString(@"确定删除所选中的道具？",nil) preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[self colorWithHexColorString:@"2C2E30"] forKey:@"titleTextColor"];

    __weak typeof(self)weakSelf = self ;
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf certainDeleteAction];
    }];
    [certainAction setValue:[self colorWithHexColorString:@"869DFF"] forKey:@"titleTextColor"];

    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];

    [self presentViewController:alertCon animated:YES completion:^{
    }];
}

- (void)certainDeleteAction {

    NSMutableArray *temArray = [NSMutableArray array];
    for (NSNumber *num in self.selectedIndex) {
        NSInteger index = [num integerValue];
        [temArray addObject:_dataArray[index]];
    }
    for (FUYituModel *obj in temArray) {
        [[FUYItuSaveManager shareManager].dataDataArray removeObject:obj];
        [_dataArray removeObject:obj];
    }

    [self.collectionView reloadData];
    [self.selectedIndex removeAllObjects];

    self.selectAllBtn.titleLabel.text = FUNSLocalizedString(@"全选",nil) ;
    [self.selectAllBtn setTitle:FUNSLocalizedString(@"全选",nil) forState:UIControlStateNormal ];

    [self deleteBtnRefreshTitle];
   
    if(_dataArray.count == 0){
        _noItemImage.hidden = NO;
        _noItemLabel.hidden = NO;
    }else{
        _noItemImage.hidden = YES;
        _noItemLabel.hidden = YES;
    }
    /* 更新存储 */
    [FUYItuSaveManager dataWriteToFile];
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(myItemViewDidDelete)]) {
        [self.mDelegate myItemViewDidDelete];
    }
}

- (void)deleteBtnRefreshTitle {

    if (self.selectedIndex.count == 0) {
        self.bottomView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1.0];
        self.deleteBtn.titleLabel.text = FUNSLocalizedString(@"删除",nil);
        [self.deleteBtn setTitle:FUNSLocalizedString(@"删除",nil) forState:UIControlStateNormal];
    }else {
        self.bottomView.backgroundColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0];
        self.deleteBtn.titleLabel.text = [NSString stringWithFormat:FUNSLocalizedString(@"删除(%ld)",nil), (unsigned long)self.selectedIndex.count];
        [self.deleteBtn setTitle:[NSString stringWithFormat:FUNSLocalizedString(@"删除(%ld)",nil), (unsigned long)self.selectedIndex.count] forState:UIControlStateNormal];
    }
}

- (IBAction)dismissSelf:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FUYItuMeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YItuMeItemCell" forIndexPath:indexPath];
    FUYituModel *modle = _dataArray[indexPath.row];
    UIImage *image = [FUYItuSaveManager loadImageWithVideoMid:modle.imagePathMid];
    cell.itemImage.image = image;
    
    if ([self.selectedIndex containsObject:@(indexPath.row)]) {
        cell.contentView.layer.borderWidth = 1.5;
        cell.contentView.layer.cornerRadius = 2.5;
        cell.contentView.layer.borderColor = [self colorWithHexColorString:@"869DFF"].CGColor;
    }else {
        cell.contentView.layer.borderWidth = 0;
    }
    return cell ;
}


#pragma mark ---- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.selectedIndex containsObject:@(indexPath.row)]) {
        [self.selectedIndex removeObject:@(indexPath.row)];
    }else {
        [self.selectedIndex addObject:@(indexPath.row)];
    }

    [collectionView reloadData];

    self.deleteBtn.titleLabel.text = [NSString stringWithFormat:FUNSLocalizedString(@"删除(%ld)",nil), (unsigned long)self.selectedIndex.count];
    [self.deleteBtn setTitle:[NSString stringWithFormat:FUNSLocalizedString(@"删除(%ld)",nil), (unsigned long)self.selectedIndex.count] forState:UIControlStateNormal];

    if (self.selectedIndex.count == _dataArray.count) {

        self.selectAllBtn.titleLabel.text = FUNSLocalizedString(@"取消",nil) ;
        [self.selectAllBtn setTitle:FUNSLocalizedString(@"取消",nil) forState:UIControlStateNormal ];
    }else {

        self.selectAllBtn.titleLabel.text = FUNSLocalizedString(@"全选",nil) ;
        [self.selectAllBtn setTitle:FUNSLocalizedString(@"全选",nil) forState:UIControlStateNormal ];
    }

    if (self.selectedIndex.count == 0) {
        self.bottomView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1.0];
    }else {
        self.bottomView.backgroundColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0];
    }
}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

#pragma mark  十六进制颜色
-(UIColor *)colorWithHexColorString:(NSString *)hexColorString{
    return [self colorWithHexColorString:hexColorString alpha:1.0f];
}

#pragma mark  十六进制颜色
- (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha{
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length =2;
    
    range.location =0;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&red];
    
    range.location =2;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&green];
    
    range.location =4;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *color = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
    
    return color;
}

@end
