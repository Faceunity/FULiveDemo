//
//  FUMakeUpView.h
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FUMakeUpViewDelegate <NSObject>

@optional

// 点击事件
-(void)makeupViewDidSelectedItemWithType:(NSInteger)typeIndex itemName:(NSString *)itemName value:(float)value ;
// 滑动事件
- (void)makeupViewDidChangeValue:(float)value Type:(NSInteger)typeIndx ;
// 显示上半部分View
-(void)makeupViewDidShowTopView:(BOOL)shown ;
@end

@interface FUMakeUpView : UIView
@property (nonatomic, assign) id<FUMakeUpViewDelegate>delegate ;

// 隐藏上半部分View
-(void)hiddenMakeupViewTopView ;
@end


@interface FUMakeupTopCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView ;
@end


@interface FUMakeupBottomCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name ;
@end
