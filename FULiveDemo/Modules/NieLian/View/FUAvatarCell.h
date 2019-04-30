//
//  FUCollectionViewCell.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUAvatarCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *image0;
@property (strong, nonatomic)  UIImageView *image1;

@property (assign, nonatomic) BOOL isSel;

@end

NS_ASSUME_NONNULL_END
