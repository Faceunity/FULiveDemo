//
//  FUAvatarBottomColletionView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUAvatarModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUAvatarBottomColletionViewDelegate <NSObject>

@optional

- (void)avatarBottomColletionDidSelectedIndex:(NSInteger)index;
@end



@interface FUAvatarBottomBottomCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *botlabel;

@property (assign, nonatomic) BOOL isSel;


@end

@interface FUAvatarBottomColletionView : UIView

@property (nonatomic, strong) NSMutableArray<FUAvatarModel *> *dataArray;  /**道具分类数组*/

@property (assign, nonatomic) BOOL isSel;

@property (nonatomic, assign) id<FUAvatarBottomColletionViewDelegate>delegate ;

@property (assign, nonatomic,readonly) NSInteger selIndex;
@end



NS_ASSUME_NONNULL_END
