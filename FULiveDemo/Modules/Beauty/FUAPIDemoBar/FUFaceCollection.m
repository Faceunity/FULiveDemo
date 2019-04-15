//
//  FUFaceCollection.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/28.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUFaceCollection.h"
#import "UIColor+FUDemoBar.h"
#import "NSString+DemoBar.h"

@interface FUFaceCollection ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataArray ;
@property (nonatomic, strong) UIView *footer ;

@end

@implementation FUFaceCollection

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.dataSource = self ;
    self.delegate = self ;
    [self registerClass:[FUFaceCell class] forCellWithReuseIdentifier:@"FUFaceCell"];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    _selectedIndex = 0 ;
    
    self.performance = NO ;
}

//-(void)setType:(FUFaceCollectionType)type{
//    _type = type ;
//    switch (type) {
//        case FUFaceCollectionTypeCommon:{
//
//            self.dataArray = @[@"自定义", @"默认", @"女神", @"网红", @"自然"];
//        }
//            break;
//        case FUFaceCollectionTypeCustom:{
//
//            self.dataArray = @[@"默认", @"女神", @"网红", @"自然"];
//        }
//            break ;
//    }
//    [self reloadData];
//}

-(void)setPerformance:(BOOL)performance {
    _performance = performance ;
    
    if (performance) {
        self.dataArray = @[@"默认", @"女神", @"网红", @"自然"];
    }else {
        self.dataArray = @[@"自定义", @"默认", @"女神", @"网红", @"自然"];
    }
    [self reloadData];
}


-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex ;
    [self reloadData];
}


#pragma mark ---- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count  ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUFaceCell" forIndexPath:indexPath];
    
    NSString *text = self.dataArray[indexPath.row];
    cell.label.text = [text LocalizableString];
    
    cell.label.textColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
    
    cell.line.hidden = _selectedIndex != indexPath.row ;
    
    [cell resetLineFrame];
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.frame.size.width - 104.0)/5.0, self.frame.size.height - 11.0) ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
//    switch (self.type) {
//        case FUFaceCollectionTypeCommon:{
//            return UIEdgeInsetsMake(5.0, 20.0, 5.0, 20.0) ;
//        }
//            break;
//        case FUFaceCollectionTypeCustom:{
//            CGFloat width = (self.frame.size.width - 104.0)/5.0 ;
//            return UIEdgeInsetsMake(5.0, 20.0 + width / 2.0, 5.0, 20.0 + width / 2.0) ;
//        }
//            break ;
//    }
    if (self.performance) {
        
        CGFloat width = (self.frame.size.width - 104.0)/5.0 ;
        return UIEdgeInsetsMake(5.0, 20.0 + width / 2.0, 5.0, 20.0 + width / 2.0) ;
    }
    return UIEdgeInsetsMake(5.0, 20.0, 5.0, 20.0) ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, 1.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor colorWithHexColorString:@"e5e5e5" alpha:0.2];
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedIndex = indexPath.row ;
    
    [self reloadData];
    
    if (self.performance) {
        
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(didSelectedFaceType:)]) {
            [self.mDelegate didSelectedFaceType:indexPath.row + 1];
        }
    }else {
        
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(didSelectedFaceType:)]) {
            [self.mDelegate didSelectedFaceType:indexPath.row];
        }
    }
    
//    switch (self.type) {
//        case FUFaceCollectionTypeCommon:{
//
//            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(didSelectedFaceType:)]) {
//                [self.mDelegate didSelectedFaceType:indexPath.row];
//            }
//        }
//            break;
//        case FUFaceCollectionTypeCustom:{
//
//            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(didSelectedFaceType:)]) {
//                [self.mDelegate didSelectedFaceType:indexPath.row + 1];
//            }
//        }
//            break ;
//    }
}

@end

@implementation FUFaceCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter ;
        self.label.font = [UIFont systemFontOfSize:12];
        self.label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.label];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2.0, self.frame.size.width, 2.0)];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"5EC7FE"];
        _line.layer.masksToBounds = YES ;
        _line.layer.cornerRadius = 1.0 ;
        _line.hidden = YES;
        [self addSubview:_line];
    }
    return self ;
}

- (void)resetLineFrame {
    
    if (!_line.hidden) {
        NSString *string = [self.label.text LocalizableString] ;
        CGSize size =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.label.font.pointSize]}];
        _line.frame = CGRectMake((self.frame.size.width - size.width) / 2.0, self.frame.size.height - 2.0, size.width, 2.0);
    }
}

@end

