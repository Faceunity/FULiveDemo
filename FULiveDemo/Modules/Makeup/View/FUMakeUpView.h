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

/* 美妆样式图 */
- (void)makeupViewDidSelectedNamaStr:(NSString *)namaStr imageName:(NSString *)imageName;
/* 妆容颜色 */
- (void)makeupViewDidSelectedNamaStr:(NSString *)namaStr valueArr:(NSArray *)valueArr;
// 滑动事件
- (void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr;
/* 当前样式的所有可选颜色 */
- (void)makeupViewSelectiveColorArray:(NSArray <NSArray *> *)colors selColorIndex:(int)index;
/* 切换的妆容t类型标题 */
- (void)makeupViewDidSelTitle:(NSString *)nama;

/* 组合妆想要的滤镜 */
- (void)makeupFilter:(NSString *)filterStr value:(float)filterValue;
// 自定义选择
- (void)makeupCustomShow:(BOOL)isShow;

- (void)makeupSelColorStata:(BOOL)stata;

@end

@class FUMakeupSupModel;
@interface FUMakeUpView : UIView
@property (nonatomic, assign,readonly) int supIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollection;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *noitemBtn;
@property (nonatomic, assign) id<FUMakeUpViewDelegate>delegate ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLeadingLayoutConstraint;

@property (strong, nonatomic) FUSingleMakeupModel *currentModel;

@property (nonatomic, assign) BOOL topHidden;


/* 组合妆数组 */
-(void)setWholeArray:(NSArray <FUMakeupSupModel *> *)dataArray;

-(void)setSelSupItem:(int)index;
/* 改变子妆容颜色 */
-(void)changeSubItemColorIndex:(int)index;

-(void)hiddenTopCollectionView:(BOOL)isHidden;

@end

