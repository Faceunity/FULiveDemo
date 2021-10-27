//
//  FUMakeUpView.h
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUSingleMakeupModel.h"
#import "FUMakeupSupModel.h"
#import "FUMakeUpDefine.h"


@class FUMakeupModel, FUMakeupSupModel;

@protocol FUMakeUpViewDelegate <NSObject>

@optional

- (void)makeupViewDidSelectedModel:(FUSingleMakeupModel *)model type:(UIMAKEUITYPE)type;
/* 当前样式的所有可选颜色 */
- (void)makeupViewSelectiveColorArray:(NSArray <NSArray *> *)colors selColorIndex:(int)index;
/* 切换的妆容t类型标题 */
- (void)makeupViewDidSelTitle:(NSString *)nama;

/* 组合妆想要的滤镜 */
- (void)makeupFilter:(NSString *)filterStr value:(float)filterValue;
// 自定义选择
- (void)makeupCustomShow:(BOOL)isShow;

- (void)makeupSelColorState:(BOOL)state;

// 显示上半部分View
-(void)showTopView:(BOOL)shown;

/* 整体妆容模型数据 */
-(void)makeupViewDidSelectedSupModle:(FUMakeupSupModel *)model;
/* 修改参数 */
-(void)makeupViewChangeValueSupModle:(FUMakeupSupModel *)model;


@end

@class FUMakeupSupModel;
@interface FUMakeUpView : UIView
@property (nonatomic, assign) int supIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollection;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *noitemBtn;
//RAC 下 改weak 好点
@property (nonatomic, assign) id<FUMakeUpViewDelegate>delegate ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLeadingLayoutConstraint;

@property (strong, nonatomic) FUSingleMakeupModel *currentModel;

@property (nonatomic, assign) BOOL topHidden;


/**
 * 刷新子妆装数据
 */
- (void)reloadDataArray:(NSArray <FUMakeupModel *>*)dataArray;

/**
 * 刷新组合装数据
 */
- (void)reloadSupArray:(NSArray <FUMakeupSupModel *>*)supArray;

-(void)setSelSupItem:(int)index;
/* 改变子妆容颜色 */
-(void)changeSubItemColorIndex:(int)index;

-(void)hiddenTopCollectionView:(BOOL)isHidden;

@end

