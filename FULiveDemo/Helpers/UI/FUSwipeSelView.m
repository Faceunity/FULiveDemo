//
//  FUSwipeSelView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUSwipeSelView.h"
#import "FUSwipeFlowLayout.h"

static const float cellW = 40;
@interface FUSwipeSelView()<UICollectionViewDelegate,UICollectionViewDataSource>
@end


@implementation FUSwipeSelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
//    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    
    /* 颜色collection */
    FUSwipeFlowLayout *layout = [[FUSwipeFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake((self.frame.size.width - cellW)/2, 0, cellW, self.frame.size.height) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;

    CGFloat collectionViewHeight = CGRectGetHeight(_collection.bounds);
    [_collection setContentInset:UIEdgeInsetsMake(collectionViewHeight/2, 0, collectionViewHeight/2,0)];
    [self addSubview:_collection];
    
    [self registerCellClass];
    
    [self setSelCell:4];
    
    /* 中间指示圈 */
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    CGFloat radius = cellW/2 + 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.collection.center radius:radius startAngle:0 endAngle:2.0f*M_PI clockwise:NO];
    layer.path = [path CGPath];
    [self.layer addSublayer:layer];
}


-(void)setSelCell:(int)index{
    float y = index * (cellW + 10) + cellW / 2 - self.collection.frame.size.height / 2;
    CGPoint offset = CGPointMake(0,y);
    [self.collection setContentOffset:offset animated:YES];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self collectionViewCellNumber];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  [self dequeueReusableCellIndexPath:indexPath];
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellW, cellW) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat collectionViewHeight = CGRectGetHeight(self.collection.frame);
    [collectionView setContentInset:UIEdgeInsetsMake(collectionViewHeight / 2, 0, collectionViewHeight / 2, 0)];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGPoint offset = CGPointMake(0,  cell.center.y - collectionViewHeight / 2);
    [collectionView setContentOffset:offset animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeSelViewDidSelIndex:)]) {
        [self.delegate swipeSelViewDidSelIndex:(int)indexPath.row];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 选中\点击对应的按钮
    NSUInteger index = (scrollView.contentOffset.y + self.collection.frame.size.height / 2 - cellW / 2) / (cellW + 10);
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeSelViewDidSelIndex:)]) {
        [self.delegate swipeSelViewDidSelIndex:(int)index];
    }
}

-(NSInteger)collectionViewCellNumber{
    NSLog(@"子类实现");
    return  0;
}

-(void)registerCellClass
{
    NSLog(@"子类需要注册cell");
}

-(UICollectionViewCell *)dequeueReusableCellIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"子类实现");
    return nil;
}


@end

