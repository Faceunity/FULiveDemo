//
//  FUBlurTypeSelView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/8.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FUBlurTypeSelViewDelegate <NSObject>

@optional
-(void)blurTypeSelViewDidSelIndex:(int)index;

@end

@interface FUBlurTypeSelView : UIView
@property (assign,nonatomic) id<FUBlurTypeSelViewDelegate> delegate;
-(void)setSelblurType:(int)blurType;

@end

@interface FUBlurTypeCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *mImageView;


@end

NS_ASSUME_NONNULL_END
