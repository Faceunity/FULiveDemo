//
//  FUDemoBar.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/26.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUBeautyModel.h"

@protocol FUAPIDemoBarDelegate <NSObject>

// 滤镜值变化
- (void)filterValueChange:(FUBeautyModel *)param;
// 美肤、美型值变化
- (void)beautyParamValueChange:(FUBeautyModel *)param;
// 显示上半部分View
-(void)showTopView:(BOOL)shown;
// 重新设置默认值
-(void)resetDefaultValue:(NSUInteger)type;
// 美型是否全部是默认参数
- (BOOL)isDefaultShapeValue;
// 美肤是否全部是默认参数
- (BOOL)isDefaultSkinValue;

@optional

// 显示提示语
- (void)filterShowMessage:(NSString *)message;

@end

@interface FUAPIDemoBar : UIView

@property (nonatomic, assign) id<FUAPIDemoBarDelegate>mDelegate ;

// 上半部分
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

// 上半部是否显示
@property (nonatomic, assign) BOOL isTopViewShow;


-(void)reloadSkinView:(NSArray<FUBeautyModel *> *)skinParams;

-(void)reloadShapView:(NSArray<FUBeautyModel *> *)shapParams;

-(void)reloadFilterView:(NSArray<FUBeautyModel *> *)filterParams;

-(void)reloadStyleView:(NSArray <FUBeautyModel *> *)styleParams defaultStyle:(FUBeautyModel *)selStyle;

/// 切换底部功能时更新界面
/// @param beautyItem 美颜类型
- (void)updateSubviews:(FUBeautyDefine)beautyItem;

// 关闭上半部分
- (void)hiddenTopViewWithAnimation:(BOOL)animation;

// 设置默认滤镜
- (void)setDefaultFilter:(FUBeautyModel *)filter;

@end
