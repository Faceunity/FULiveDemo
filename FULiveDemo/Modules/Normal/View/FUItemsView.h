//
//  FUItemsView.h
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FUItemsViewDelegate <NSObject>

@optional

- (void)itemsViewDidSelectedItem:(NSString *)item;

@end

@interface FUItemsView : UIView

@property (nonatomic, strong) NSArray *itemsArray ;

@property (nonatomic, strong) NSString *selectedItem ;

@property (strong, nonatomic) UICollectionView *collection;

@property (nonatomic, assign) id<FUItemsViewDelegate>delegate ;


-(void)updateCollectionArray:(NSArray *)itemArray;

- (void)stopAnimation ;
@end
