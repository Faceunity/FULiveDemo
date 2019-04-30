//
//  FUAvatarContentColletionView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUAvatarModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol FUAvatarContentColletionViewDelegate <NSObject>

@optional

- (void)avatarContentColletionViewDidSelectedIndex:(NSInteger)index;
@end


@interface FUAvatarContentCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *image;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (assign, nonatomic) BOOL isSel;
@end

NS_ASSUME_NONNULL_END



NS_ASSUME_NONNULL_BEGIN

@interface FUAvatarContentColletionView : UIView
@property (nonatomic, strong) FUAvatarModel *avatarModel;

@property (nonatomic, assign) id<FUAvatarContentColletionViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
