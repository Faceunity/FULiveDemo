//
//  FUAvatarCollectionView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarCollectionView.h"
#import <Masonry.h>
#import "FUAvatarCell.h"
#import "FUManager.h"
#import "FUAvatarPresenter.h"
#import "FUWholeAvatarModel.h"

@interface FUAvatarCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collection;

@property (assign, nonatomic) NSInteger selIndex;
@end

@implementation FUAvatarCollectionView

static NSString *cellID = @"AvatarCell";
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


-(void)setupView{
    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(60, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [self addSubview:_collection];
    
    [_collection registerClass:[FUAvatarCell class] forCellWithReuseIdentifier:cellID];
    
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [FUAvatarPresenter shareManager].wholeAvatarArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    
    if (indexPath.row == 0) {
        cell.isSel = _selIndex == indexPath.row ? YES : NO;
        cell.image1.image = nil;
        cell.image0.image = [UIImage imageNamed:@"demo_avatar_icon_cancel"];
    }else{
        FUWholeAvatarModel *modle = [FUAvatarPresenter shareManager].wholeAvatarArray[indexPath.row - 1];
        cell.isSel = _selIndex == indexPath.row ? YES : NO;
        cell.image1.image = modle.image;
        cell.image0.image = [UIImage imageNamed:@"demo_icon_template_male"];
    }
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(60, 60) ;
//}
//
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 16, 12, 16);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selIndex = indexPath.row;
    [_collection reloadData];
    if ([self.delegate respondsToSelector:@selector(avatarCollectionViewDidSel:)]) {
        [self.delegate avatarCollectionViewDidSel:(int)indexPath.row];
    }
}


-(void)updataCurrentSel:(int)index{
    _selIndex = index;
    [_collection reloadData];
    if ([self.delegate respondsToSelector:@selector(avatarCollectionViewDidSel:)]) {
        [self.delegate avatarCollectionViewDidSel:index];
    }
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}


@end
