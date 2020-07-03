//
//  FUBodCollectionView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2020/6/22.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUBodyItemsDelegate <NSObject>

@optional

- (void)bodyDidSelectedItemsIndex:(int )index;

@end

@interface FUBodCollectionView : UIView



@property (nonatomic, assign) int selIndex;

@property (nonatomic, assign) id<FUBodyItemsDelegate>delegate ;


-(void)setItemsArray:(NSArray *)itemsArray;
-(void)updateCollectionAndSel:(int)index;

- (void)stopAnimation ;
@end

NS_ASSUME_NONNULL_END
