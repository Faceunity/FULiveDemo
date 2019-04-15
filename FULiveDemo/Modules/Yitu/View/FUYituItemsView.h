//
//  FUYituItemsView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUYituItemsDelegate <NSObject>

@optional

- (void)yituDidSelectedItemsIndex:(int )index;

@end

@interface FUYituItemsView : UIView



@property (nonatomic, assign) int selIndex ;

@property (nonatomic, assign) id<FUYituItemsDelegate>delegate ;


-(void)updateCollectionAndSel:(int)index;

- (void)stopAnimation ;
@end

NS_ASSUME_NONNULL_END
