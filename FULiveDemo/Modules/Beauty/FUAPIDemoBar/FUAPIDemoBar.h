//
//  FUDemoBar.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/26.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUBeautyParam.h"

@protocol FUAPIDemoBarDelegate <NSObject>

// 滤镜程度改变
- (void)filterValueChange:(FUBeautyParam *)param;

- (void)beautyParamValueChange:(FUBeautyParam *)param;
// 显示提示语
- (void)filterShowMessage:(NSString *)message ;

// 显示上半部分View
-(void)showTopView:(BOOL)shown;

-(void)restDefaultValue:(int)type;


@end

@interface FUAPIDemoBar : UIView

@property (nonatomic, assign) id<FUAPIDemoBarDelegate>mDelegate ;

// 上半部分
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, assign) int selBottomIndex;

-(void)reloadSkinView:(NSArray<FUBeautyParam *> *)skinParams;

-(void)reloadShapView:(NSArray<FUBeautyParam *> *)shapParams;

-(void)reloadFilterView:(NSArray<FUBeautyParam *> *)filterParams;
/* 风格 */
-(void)reloadStyleView:(NSArray<FUBeautyParam *> *)styleParams defaultStyle:(FUBeautyParam *)selStyle;
// 关闭上半部分
-(void)hiddenTopViewWithAnimation:(BOOL)animation;

// 上半部是否显示
@property (nonatomic, assign) BOOL isTopViewShow ;

-(void)setDefaultFilter:(FUBeautyParam *)filter;

-(void)setDefaultStyle:(int)index;


@end
