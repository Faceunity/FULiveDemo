//
//  FUMakeUpView.h
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUSingleMakeupModel.h"

@protocol FUMakeUpViewDelegate <NSObject>

@optional

// 点击事件
-(void)makeupViewDidSelectedItemName:(NSString *)itemName namaStr:(NSString *)namaStr isLip:(BOOL)isLip;
// 滑动事件
- (void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr;

-(void)makeupFilter:(NSString *)filterStr value:(float)filterValue;

// 自定义选择
- (void)makeupCustomShow:(BOOL)isShow;

@end

@class FUMakeupSupModel;
@interface FUMakeUpView : UIView
@property (nonatomic, assign,readonly) int supIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollection;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *noitemBtn;
@property (nonatomic, assign) id<FUMakeUpViewDelegate>delegate ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLeadingLayoutConstraint;

/* 组合妆数组 */
-(void)setWholeArray:(NSArray <FUMakeupSupModel *> *)dataArray;
/* 组合妆，对应子妆容表 */
-(void)setSupToSingelArr:(NSArray *)supTosingeArr;

-(void)setDefaultSupItem:(int)index;

@end

