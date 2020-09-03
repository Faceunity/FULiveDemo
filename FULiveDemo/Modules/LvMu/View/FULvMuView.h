//
//  FULvMuView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2020/8/13.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "FUBeautyParam.h"


NS_ASSUME_NONNULL_BEGIN

@class FULvMuView;
@protocol FULvMuViewDelegate <NSObject>

- (void)beautyCollectionView:(FULvMuView *)beautyView didSelectedParam:(FUBeautyParam *)param;

-(void)lvmuViewShowTopView:(BOOL)show;

- (void)colorDidSelectedR:(float)r G:(float)g B:(float)b A:(float)a;

- (void)didSelectedParam:(FUBeautyParam *)param;

@end


@interface FULvMuView : UIView
@property (nonatomic, assign) id<FULvMuViewDelegate>mDelegate ;

@property (nonatomic, assign) NSInteger selectedIndex ;
@property (nonatomic, assign) NSInteger colorSelectedIndex ;

@property (nonatomic, strong) NSMutableArray <FUBeautyParam *>*dataArray;

-(void)destoryLvMuView;

-(void)hidenTop:(BOOL)isHiden;

-(void)restUI;


@end

@interface FULvMuCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel ;
@end


@interface FULvMuColorCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel ;

@property (nonatomic, strong) UIColor *color;
@end


NS_ASSUME_NONNULL_END
