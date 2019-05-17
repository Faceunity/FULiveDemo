//
//  FUAvatarContentColletionView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarContentColletionView.h"


@interface FUAvatarContentCell()
@property (strong, nonatomic) CAShapeLayer *dottedLineBorder;
@end
@implementation FUAvatarContentCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        _image  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
        _image.center = self.contentView.center;
        _image.layer.cornerRadius = 8;
        _image.layer.masksToBounds = YES;
        [self.contentView addSubview:_image];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 82, 20)];
        _titleLabel.text = NSLocalizedString(@"自定义", nil);
        _titleLabel.textColor = [UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.layer.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:252/255.0 alpha:1.0].CGColor;
        
        _dottedLineBorder  = [[CAShapeLayer alloc] init];
        _dottedLineBorder.frame = self.bounds;
        _dottedLineBorder.hidden = YES;
        [_dottedLineBorder setLineWidth:5];
        [_dottedLineBorder setFillColor:[UIColor clearColor].CGColor];
        [_dottedLineBorder setStrokeColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8];
        _dottedLineBorder.path = path.CGPath;
        [self.contentView.layer addSublayer:_dottedLineBorder];
        
        
        
    }
    
    return self;
}

-(void)setIsSel:(BOOL)isSel{
    _isSel = isSel;
    _dottedLineBorder.hidden = !isSel;

}

@end

@interface FUAvatarContentColletionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collection;

@property (assign, nonatomic) NSInteger selIndex;
@end

@implementation FUAvatarContentColletionView

static  NSString *cellID = @"colorCell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 16;
        layout.itemSize = CGSizeMake(82, 82);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frame.size.height) collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor clearColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        [self addSubview:_collection];
        [_collection registerClass:[FUAvatarContentCell class] forCellWithReuseIdentifier:cellID];
        _collection.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}
-(void)setAvatarModel:(FUAvatarModel *)avatarModel{
    _avatarModel = avatarModel;
    _selIndex = _avatarModel.bundleSelIndex;
    [CATransaction setDisableActions:YES];
    [self.collection reloadData];
    [CATransaction commit];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _avatarModel.bundles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUAvatarContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.image.image = [UIImage imageNamed:_avatarModel.bundles[indexPath.row].iconName];
    cell.isSel = indexPath.row == _selIndex ? YES :NO;
    
    if (_avatarModel.haveCustom) {
        cell.titleLabel.hidden = indexPath.row == 0 ? NO :YES;
    }else{
        cell.titleLabel.hidden = YES;
    }
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_selIndex == indexPath.row && indexPath.row != 0){
        return;
    }
    _selIndex = indexPath.row;
    [self.collection reloadItemsAtIndexPaths:[self.collection indexPathsForVisibleItems]];
    if ([self.delegate respondsToSelector:@selector(avatarContentColletionViewDidSelectedIndex:)]) {
        [self.delegate avatarContentColletionViewDidSelectedIndex:indexPath.row];
    }
    _avatarModel.bundleSelIndex = (int)_selIndex;
}


@end
