//
//  FUHeadButtonView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/29.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUHeadButtonViewDelegate <NSObject>

@optional
/* 点击事件 */
-(void)headButtonViewBackAction:(UIButton *)btn;
-(void)headButtonViewSelImageAction:(UIButton *)btn;
-(void)headButtonViewBuglyAction:(UIButton *)btn;
-(void)headButtonViewSwitchAction:(UIButton *)btn;
-(void)headButtonViewSegmentedChange:(UISegmentedControl *)sender;

@end

@interface FUHeadButtonView : UIView

@property (strong, nonatomic) UIButton *mHomeBtn;
@property (strong, nonatomic) UIButton *selectedImageBtn;
@property (strong, nonatomic) UIButton *switchBtn;
@property (strong, nonatomic) UIButton *bulyBtn;
@property (strong, nonatomic) UISegmentedControl *inputSegm;

@property (weak, nonatomic) id <FUHeadButtonViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
