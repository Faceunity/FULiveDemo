//
//  FUItemsView.m
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUItemsView.h"
#import "FUItemsViewCell.h"

@interface FUItemsView ()

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@end

@implementation FUItemsView
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

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.collection.frame = CGRectMake(0, 4, self.frame.size.width, self.frame.size.height - 4) ;
}

-(void)setItemsArray:(NSArray *)itemsArray {
    
    NSMutableArray *array = [itemsArray mutableCopy];
    [array insertObject:@"noitem" atIndex:0];
    _itemsArray = [array copy] ;
    
    [self.collection reloadData];
}

-(void)setSelectedItem:(NSString *)selectedItem {
    
    _selectedItem = selectedItem ;
    
    [self.collection reloadData];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArray.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUItemsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUItemsViewCell" forIndexPath:indexPath];
    
    NSString *imageName = self.itemsArray[indexPath.row] ;
    
    cell.imageView.image = [UIImage imageNamed:imageName] ;
    
    if ([self.selectedItem isEqualToString:imageName]) {
        
        cell.selected = YES ;
        if (loading) {
            [cell.indicator startAnimating];
        }else {
            [cell.indicator stopAnimating];
        }
    }else {
        
        cell.selected = NO ;
        [cell.indicator stopAnimating];
    }
    
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *imageName = self.itemsArray[indexPath.row] ;
    
    if (imageName == self.selectedItem) {
        
        return ;
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    collectionView.userInteractionEnabled = NO ;
    
    self.selectedItem = imageName ;
    loading = YES ;
    
    [collectionView reloadData];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemsViewDidSelectedItem:)]) {
            [self.delegate itemsViewDidSelectedItem:imageName];
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
