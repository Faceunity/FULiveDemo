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
@property (nonatomic, strong) FUAvatarModel *oldAvatarModel;
/* 恢复默认0 */
-(void)resetDefaultValue;
/* 值是否有变化 */
-(BOOL)isParamValueChange;
@end

NS_ASSUME_NONNULL_END
