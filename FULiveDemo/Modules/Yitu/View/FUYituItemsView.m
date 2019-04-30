//
//  FUYituItemsView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUYituItemsView.h"
#import "FUItemsViewCell.h"
#import "FUYituModel.h"
#import "FUYItuSaveManager.h"
@interface FUYituItemsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collection;
@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation FUYituItemsView
{
    BOOL loading ;
}



-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.6];
        loading = NO ;
    }
    return self ;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void)setupView{
    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.6];
    loading = NO ;
    
    self.itemsArray = @[@"icon_yitu_add"];//,@"icon_yitu_delete"
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(60, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    _collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [self addSubview:_collection];
    [_collection registerNib:[UINib nibWithNibName:@"FUItemsViewCell" bundle:nil] forCellWithReuseIdentifier:@"FUItemsViewCell"];
    
}


//-(void)setItemsArray:(NSArray *)itemsArray {
//
//
//}

-(void)updateCollectionAndSel:(int)index{
    _selIndex = index;
    [self.collection reloadData];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(yituDidSelectedItemsIndex:)]) {
            [self.delegate yituDidSelectedItemsIndex:index];
        }
    });
}

//-(void)setSelectedItem:(NSString *)selectedItem {
//
//    _selectedItem = selectedItem ;
//
//    [self.collection reloadData];
//}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArray.count + [FUYItuSaveManager shareManager].dataDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUItemsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUItemsViewCell" forIndexPath:indexPath];
    NSString *imageName = nil;
    int yituCount = (int)[FUYItuSaveManager shareManager].dataDataArray.count;
    if (indexPath.row < yituCount) {
        imageName = [FUYItuSaveManager shareManager].dataDataArray[indexPath.row].imagePathMid;
        cell.imageView.image = [FUYItuSaveManager loadImageWithVideoMid:imageName];
        if (_selIndex ==  (int)indexPath.row) {
            cell.selected = YES ;
        }else {
            cell.selected = NO;
        }
    }else{
        imageName = self.itemsArray[indexPath.row - yituCount];
        cell.imageView.image = [UIImage imageNamed:imageName] ;
    }
    
    
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60) ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 16, 12, 16);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int yituCount = (int)[FUYItuSaveManager shareManager].dataDataArray.count;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (indexPath.row < yituCount) {
        _selIndex = (int)indexPath.row;
    }
    
    [collectionView reloadData];    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(yituDidSelectedItemsIndex:)]) {
            [self.delegate yituDidSelectedItemsIndex:(int)indexPath.row];
        }
    });
}


- (void)stopAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        loading = NO ;
        [self.collection reloadData];
        self.collection.userInteractionEnabled = YES ;
    });
}

@end
