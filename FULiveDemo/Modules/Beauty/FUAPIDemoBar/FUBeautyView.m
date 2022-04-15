//
//  FUBeautyView.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUBeautyView.h"
#import "UIImage+demobar.h"
#import "UIColor+FU.h"

@interface FUBeautyView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@end

@implementation FUBeautyView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self ;
    self.dataSource = self ;
    [self registerClass:[FUBeautyCell class] forCellWithReuseIdentifier:@"FUBeautyCell"];
    
    _selectedIndex = -1;
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUBeautyCell" forIndexPath:indexPath];
    FUBeautyModel *modle = self.dataArray[indexPath.row] ;
    NSString *imageName;
    UIColor *titleColor;
    BOOL opened = YES;
    
    if (modle.iSStyle101) {
        opened = fabs(modle.mValue - 0.5) > 0.01 ? YES : NO;
    }else{
        opened = fabs(modle.mValue - 0) > 0.01 ? YES : NO;
    }
    BOOL selected = _selectedIndex == indexPath.row ;
    if (selected) {
        imageName = opened ? [modle.mTitle stringByAppendingString:@"-3"] : [modle.mTitle stringByAppendingString:@"-2"];
    }else {
        imageName = opened ? [modle.mTitle stringByAppendingString:@"-1"] : [modle.mTitle stringByAppendingString:@"-0"] ;
    }
    titleColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
    
    /* icon 未找到, 尝试处理 多语言图片 */
    UIImage *imageIcon = [UIImage imageWithName:imageName];
    if (imageIcon == nil) {
        imageIcon = [UIImage localizedImageWithName:imageName countrySimple:nil];
    }
    cell.imageView.image = imageIcon;
    cell.titleLabel.text = FUNSLocalizedString(modle.mTitle, nil);
    cell.titleLabel.textColor = titleColor;
    return cell ;
}

#pragma mark ---- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUBeautyModel *model = _dataArray[indexPath.row];
    if (_selectedIndex == indexPath.row) {
        return;
    }
    _selectedIndex = indexPath.row;
    [self reloadData];
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyCollectionView:didSelectedParam:)]) {
        [self.mDelegate beautyCollectionView:self didSelectedParam:model];
    }
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(16, 16, 6, 16) ;
}

@end


@implementation FUBeautyCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageView.layer.masksToBounds = YES ;
        self.imageView.layer.cornerRadius = frame.size.width / 2.0 ;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, frame.size.width + 2, frame.size.width + 20, frame.size.height - frame.size.width - 2)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:self.titleLabel ];
    }
    return self ;
}

@end
