//
//  FUFilterView.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUFilterView.h"
#import "UIColor+FUDemoBar.h"
#import "UIImage+demobar.h"
#import "NSString+DemoBar.h"

@interface FUFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation FUFilterView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self ;
        [self registerClass:[FUFilterCell class] forCellWithReuseIdentifier:@"FUFilterCell"];
        
        _selectedIndex = -1 ;
    }
    return self ;
}

-(void)setType:(FUFilterViewType)type {
    _type = type ;
    [self reloadData];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex ;
    [self reloadData];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterDataSource.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUFilterCell *cell = (FUFilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FUFilterCell" forIndexPath:indexPath];
    
    NSString *filter = self.filterDataSource[indexPath.row];
    NSString *text = _filtersCHName[filter] ? _filtersCHName[filter]:filter;
    cell.titleLabel.text = [text LocalizableString] ;
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageWithName:[filter lowercaseString]];
    
    cell.imageView.layer.borderWidth = 0.0 ;
    cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    
    if (_selectedIndex == indexPath.row) {
        
        cell.imageView.layer.borderWidth = 2.0 ;
        cell.imageView.layer.borderColor = [UIColor colorWithHexColorString:@"5EC7FE"].CGColor;
        cell.titleLabel.textColor = [UIColor colorWithHexColorString:@"5EC7FE"];
    }
    
    return cell ;
}

#pragma mark ---- UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedIndex = indexPath.row ;
    [self reloadData];
    
    NSString *filter = self.filterDataSource[indexPath.row] ;
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(filterViewDidSelectedFilter:Type:)]) {
        [self.mDelegate filterViewDidSelectedFilter:filter Type:self.type];
    }
}

#pragma mark ---- UICollectionViewDelegateFlowLayout


@end


@implementation FUFilterCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
        self.imageView.layer.masksToBounds = YES ;
        self.imageView.layer.cornerRadius = 3.0 ;
        self.imageView.layer.borderWidth = 0.0 ;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor ;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, 54, frame.size.height - 54)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.titleLabel];
    }
    return self ;
}
@end
