//
//  FUSwipeSelView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUSwipeSelViewDelegate <NSObject>

@optional
-(void)swipeSelViewDidSelIndex:(int)index;

@end

@interface FUSwipeSelView : UIView
@property (assign,nonatomic) id<FUSwipeSelViewDelegate> delegate;
/** UICollectionView */
@property (strong, nonatomic) UICollectionView *collection;

- (void)setSelCell:(int)index;

-(NSInteger)collectionViewCellNumber;

-(void)registerCellClass;

-(UICollectionViewCell *)dequeueReusableCellIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END
