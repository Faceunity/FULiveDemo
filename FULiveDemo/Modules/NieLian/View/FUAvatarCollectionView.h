//
//  FUAvatarCollectionView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUAvatarCollectionViewDelegate <NSObject>

@optional
-(void)avatarCollectionViewDidSel:(int)index;

@end

@interface FUAvatarCollectionView : UIView
@property (strong, nonatomic,readonly) UICollectionView *collection;

@property (nonatomic, assign) id<FUAvatarCollectionViewDelegate>delegate;

@property (assign, nonatomic,readonly) NSInteger selIndex;

/* 设置默认 */
-(void)updataCurrentSel:(int)index;
@end

NS_ASSUME_NONNULL_END
