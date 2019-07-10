//
//  FUColourFlowLayout.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/5/31.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUColourFlowLayout.h"

@implementation FUColourFlowLayout
//在这个方法中，UICollectionView还没有实例化，所以取不到其对应的frame
-(instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}
//当布局刷新的时候会自动调用这个方法
-(void)prepareLayout{
    [super prepareLayout];
    //修改滚动方向 为水平方向来滚动
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //获取对应UICollectionView的Size
    CGSize collectionSize = self.collectionView.frame.size;
    
    //定义显示ITEM的 宽 高
    CGFloat itemWidth = collectionSize.width*0.6;
    CGFloat itemHeight = collectionSize.width*0.6;
    
    //修改ITEM大小
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //设置头部和尾部的初始间距
//    CGFloat topMargin = collectionSize.height/2-itemWidth/2;
//    self.sectionInset = UIEdgeInsetsMake(topMargin,0, topMargin,0 );
    
}

//返回所的有的Item对应的属性设置
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //取出所有的Item对应的属性
    NSArray *superAttributesArray = [super layoutAttributesForElementsInRect:rect];
    
    //计算中心点
    CGFloat screenCenter = self.collectionView.contentOffset.y+self.collectionView.frame.size.height/2;
    //循环设置Item 的属性
    
    for (UICollectionViewLayoutAttributes  *attributes in superAttributesArray) {
        //计算 差值
        CGFloat deltaMargin = ABS(screenCenter - attributes.center.y);
        //计算放大比例
        CGFloat scale = 1 - deltaMargin/(self.collectionView.frame.size.height/2+attributes.size.height) * 0.9;
        //设置
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return superAttributesArray;
}

//当手指离开屏幕时会调用此方法
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //取出屏幕的中心点
    CGFloat screenCenter = proposedContentOffset.y +self.collectionView.frame.size.height/2;
    //取出可见范围内的Cell
    CGRect visibleRect = CGRectZero;
    visibleRect.size = self.collectionView.frame.size;
    visibleRect.origin = proposedContentOffset;
    
    NSArray *visibleArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    CGFloat minMargin = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attributes in visibleArray) {
        CGFloat deltaMargin = attributes.center.y - screenCenter;
        if (ABS(minMargin)>ABS(deltaMargin)) {
            minMargin = deltaMargin;
        }
    }
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + minMargin);
}

//当屏幕的可见范围发生变化 的时候
//重新刷新视图
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
