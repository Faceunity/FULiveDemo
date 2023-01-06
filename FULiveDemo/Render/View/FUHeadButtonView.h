//
//  FUHeadButtonView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/29.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUHeadButtonViewDelegate <NSObject>

@optional
/* 点击事件 */
-(void)headButtonViewBackAction:(UIButton *)btn;
-(void)headButtonViewSelImageAction:(UIButton *)btn;
-(void)headButtonViewBuglyAction:(UIButton *)btn;
-(void)headButtonViewSwitchAction:(UIButton *)btn;
-(void)headButtonViewSegmentedChange:(NSUInteger)index;

@end

@interface FUHeadButtonView : UIView

@property (strong, nonatomic) UIButton *homeButton;
@property (strong, nonatomic) UIButton *selectedImageButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *bulyButton;
@property (strong, nonatomic) FUSegmentedControl *segmentedControl;

@property (weak, nonatomic) id <FUHeadButtonViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
