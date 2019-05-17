//
//  FUColorCollectionView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUColorCollectionView.h"
#import "FUColorCell.h"
#import "FUAvatarPresenter.h"
#import "FUColor.h"
#import "FUAvatarModel.h"
#import "FUManager.h"

@interface FUColorCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collection;

@property (assign, nonatomic) NSInteger selIndex;
@end

@implementation FUColorCollectionView

static  NSString *cellID = @"colorCell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 16;
        layout.itemSize = CGSizeMake(40, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60) collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor clearColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        [self addSubview:_collection];
        [_collection registerClass:[FUColorCell class] forCellWithReuseIdentifier:cellID];
        _collection.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}


-(void)setAvatarModel:(FUAvatarModel *)avatarModel{
    _avatarModel = avatarModel;
    _selIndex = avatarModel.colorsSelIndex;
    [self.collection reloadData];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _avatarModel.colors.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    
    cell.image.hidden = _selIndex == indexPath.row ? NO:YES;
    FUAvatarColor *color = _avatarModel.colors[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:color.r/255.0 green:color.g/255.0 blue:color.b/255.0 alpha:1.0];  //[FUColor colorWithHexString:_colors[indexPath.row] alpha:1.0];
    
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selIndex = indexPath.row;
    _avatarModel.colorsSelIndex = (int)_selIndex;

    [_collection reloadData];
    if ([self.delegate respondsToSelector:@selector(colorCollectionViewDidSelectedIndex:)]) {
        [self.delegate colorCollectionViewDidSelectedIndex:(int)indexPath.row];
    }
}

@end
