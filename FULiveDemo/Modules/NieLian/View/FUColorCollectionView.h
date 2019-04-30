//
//  FUColorCollectionView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUColorCollectionViewDelegate <NSObject>
    
    @optional
    
- (void)colorCollectionViewDidSelectedIndex:(NSInteger)index;
    @end

@class FUAvatarModel;
@interface FUColorCollectionView : UIView
@property (nonatomic, strong) FUAvatarModel *avatarModel;
    
@property (assign, nonatomic,readonly) NSInteger selIndex;
    
@property (nonatomic, assign) id<FUColorCollectionViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
