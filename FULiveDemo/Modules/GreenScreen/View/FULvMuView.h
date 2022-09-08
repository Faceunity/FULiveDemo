//
//  FULvMuView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2020/8/13.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUGreenScreenModel.h"
#import "FUGreenScreenSafeAreaModel.h"
#import "FUTakeColorView.h"

@class FUGreenScreenModel, FUGreenScreenBgModel;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUTakeColorState) {
    FUTakeColorStateRunning,
    FUTakeColorStateStop,
};

@class FULvMuView;
@protocol FULvMuViewDelegate <NSObject>

- (void)beautyCollectionView:(FULvMuView *)beautyView didSelectedParam:(FUGreenScreenModel *)param;

/// 选中安全区域
- (void)lvmuViewDidSelectSafeArea:(FUGreenScreenSafeAreaModel *)model;

/// 取消安全区域
- (void)lvmuViewDidCancelSafeArea;

-(void)lvmuViewShowTopView:(BOOL)show;

- (void)colorDidSelected:(UIColor *)color;

- (void)didSelectedParam:(FUGreenScreenModel *)param;


- (void)takeColorState:(FUTakeColorState)state;

- (void)getPoint:(CGPoint)point;

//从外面获取全局的取点背景view，为了修复取点view加载Window上的系统兼容性问题
- (UIView *)takeColorBgView;

@end


@interface FULvMuView : UIView
@property (nonatomic, assign) id<FULvMuViewDelegate>mDelegate ;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger colorSelectedIndex;

@property (strong, nonatomic) FUTakeColorView *mTakeColorView;

@property (assign, nonatomic) BOOL isHidenTop;

//刷新绿慕collection数据
- (void)reloadDataSoure:(NSArray <FUGreenScreenModel *> *)dataSource;

//刷新绿慕背景collection数据
- (void)reloadBgDataSource:(NSArray <FUGreenScreenBgModel *> *)dataSource;

-(void)destoryLvMuView;

-(void)hidenTop:(BOOL)isHiden;

-(void)restUI;

- (void)setTakeColor:(UIColor *)color;

@end

@interface FULvMuCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel ;
@end


@interface FULvMuColorCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bgImageView ;
@property (nonatomic, strong) UILabel *titleLabel ;

@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
