//
//  FUBlurTypeSelView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/8.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUBlurTypeSelView.h"

static const float cellW = 44;
@interface FUBlurTypeSelView()<UICollectionViewDelegate,UICollectionViewDataSource>
/** UICollectionView */
@property (strong, nonatomic) UICollectionView *collection;

@property (strong, nonatomic) NSArray *images;

@property (strong, nonatomic) NSArray *selImages;

@property (nonatomic, assign) int selIndex;
@end


@implementation FUBlurTypeSelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake((self.frame.size.width - cellW)/2, 0, cellW, self.frame.size.height) collectionViewLayout:flowLayout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;
    [self addSubview:_collection];
    [_collection registerClass:[FUBlurTypeCell class] forCellWithReuseIdentifier:@"blurTypeCell"];
    
    _images = @[@"demo_icon_list_hazy_buffing_nor",@"demo_icon_list_clear_buffing_nor",@"demo_icon_list_fine_buffing_nor"];
    _selImages = @[@"demo_icon_list_hazy_buffing_sel",@"demo_icon_list_clear_buffing_sel",@"demo_icon_list_fine_buffing_sel"];
}


-(void)setSelblurType:(int)blurType{
    
    _selIndex = [self IndexForblurType:blurType];
    [self.collection reloadData];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUBlurTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"blurTypeCell" forIndexPath:indexPath];
    if((int)indexPath.row == _selIndex){
        cell.mImageView.image = [UIImage imageNamed:_selImages[indexPath.row]];
    }else{
        cell.mImageView.image = [UIImage imageNamed:_images[indexPath.row]];
    }
    
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellW, cellW) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selIndex = (int)indexPath.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(blurTypeSelViewDidSelIndex:)]) {
        int brulType = [self blurTypeForIndex:(int)indexPath.row];
        [self.delegate blurTypeSelViewDidSelIndex:brulType];
    }
    [self.collection reloadData];
}


-(int)blurTypeForIndex:(int)index{
    switch (index) {
        case 0:
            return 1;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

-(int)IndexForblurType:(int)index{
    switch (index) {
        case 0:
            return 1;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}


@end


@implementation FUBlurTypeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 22)];
        self.mImageView.center = self.contentView.center;
        [self.contentView addSubview:self.mImageView];
        
        self.contentView.layer.cornerRadius = frame.size.width/2;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.74];
    }
    
    return self;
}

@end
