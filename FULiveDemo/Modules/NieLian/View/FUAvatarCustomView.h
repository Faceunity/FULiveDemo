//
//  FUAvatarCustomView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN
@class FUAvatarModel;
@interface FUAvatarCustomCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *image;

@end

@interface FUAvatarCustomView : UIView
@property (nonatomic, strong) FUAvatarModel *avatarModel;
@end

NS_ASSUME_NONNULL_END
