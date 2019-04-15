//
//  FUGanEditBarView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/24.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUGanEditBarViewDelegate <NSObject>

@optional
-(void)ganEditFunctionalModeIndex:(int)index;
-(void)ganEditExpressionIndex:(int)index;
@end

@interface FUGanEditBarView : UIView

@property (assign,nonatomic) id<FUGanEditBarViewDelegate> delegate;

@property (assign, nonatomic) NSInteger currentModeType;


-(void)updataCurrentSel:(int)index;

@end

NS_ASSUME_NONNULL_END
