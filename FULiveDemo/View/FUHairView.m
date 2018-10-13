//
//  FUHairView.m
//  FULiveDemo
//
//  Created by L on 2018/9/19.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUHairView.h"
#import "FUMakeupSlider.h"

@interface FUHairView ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger selectedIndex ;
}
@property (nonatomic, strong) NSMutableDictionary *paramDic ;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet FUMakeupSlider *slider;
@end

@implementation FUHairView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.collection.delegate = self ;
    self.collection.dataSource = self ;
    
    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.6];
    self.paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    selectedIndex = 1 ;
}

- (IBAction)sliderValueChange:(FUMakeupSlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hairViewDidSelectedhairIndex:Strength:)]) {
        [self.delegate hairViewDidSelectedhairIndex:selectedIndex - 1 Strength:sender.value];
    }
    
    NSString *imageName = self.itemsArray[selectedIndex] ;
    [self.paramDic setObject:@(sender.value) forKey:imageName];
}

-(void)setItemsArray:(NSArray *)itemsArray {
    
    NSMutableArray *array = [itemsArray mutableCopy];
    [array insertObject:@"noitem" atIndex:0];
    _itemsArray = [array copy] ;
    
    [self.collection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArray.count ;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUHairCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUHairCell" forIndexPath:indexPath];
    
    NSString *imageName = self.itemsArray[indexPath.row] ;
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    cell.imageView.layer.borderWidth = indexPath.row == selectedIndex ? 3.0 : 0.0 ;
    cell.imageView.layer.borderColor = indexPath.row == selectedIndex ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor : [UIColor clearColor].CGColor;
    
    return cell;
}


#pragma mark --- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == selectedIndex) {
        return ;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    selectedIndex = indexPath.row ;
    [collectionView reloadData];
    
    if (indexPath.row == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hairViewDidSelectedhairIndex:Strength:)]) {
            [self.delegate hairViewDidSelectedhairIndex:-1 Strength:0];
        }
        
        self.slider.hidden = YES ;
    }else {
        
        float strength = 0.5 ;
        NSString *imageName = self.itemsArray[selectedIndex] ;
        if ([self.paramDic.allKeys containsObject:imageName]) {
            strength = [[self.paramDic objectForKey:imageName] floatValue] ;
        }else {
            [self.paramDic setObject:@(0.5) forKey:imageName];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(hairViewDidSelectedhairIndex:Strength:)]) {
            [self.delegate hairViewDidSelectedhairIndex:indexPath.row - 1 Strength:strength];
        }
        
        self.slider.hidden = NO ;
        self.slider.value = strength ;
    }
}


@end



@implementation FUHairCell

@end
