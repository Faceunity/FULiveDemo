//
//  FUAdjustImageView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "FUYituItemModel.h"

NS_ASSUME_NONNULL_BEGIN
@class FUAdjustImageView;
@protocol FUAdjustImageViewDelegate <NSObject>
@optional
- (void)adjustImageViewFocus:(FUAdjustImageView *)view;
- (void)adjustImageViewAddOne:(FUAdjustImageView *)view;
- (void)adjustImageViewRemove:(FUAdjustImageView *)view;
@end


@interface FUAdjustImageView : UIView

@property (nonatomic, strong) NSArray *miniPoints;//精细调整后的相对titu图片点位

@property (nonatomic, assign) float minZoom;
@property (nonatomic, assign) float maxZoom;

@property (nonatomic, strong) UIImageView* imageview;

@property (nonatomic, strong) FUYituItemModel *model;

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, assign) id<FUAdjustImageViewDelegate>delegate;

@property (nonatomic,strong) UIButton *addOneBtn;

@property (nonatomic, strong) NSArray *points;

- (CGAffineTransform)getTransform;
- (CGPoint)getCenter;
/**
 获取相对view的关键点坐标

 @param view 相对view
 @return 关键点数组
 */
-(NSArray *)getConvertPointsToView:(UIView *)view;

-(CGPoint)getConvertCenterImage:(UIView *)view;

/* 模板点位被精细调整后，重设模板 */
-(void)setDefaultPoint:(NSArray *)points aboutView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
