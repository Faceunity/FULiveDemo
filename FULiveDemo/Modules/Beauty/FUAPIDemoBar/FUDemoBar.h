//
//  FUDemoBar.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/26.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUMakeUpView.h"

@protocol FUDemoBarDelegate <NSObject>

// 美颜参数改变
- (void)beautyParamChanged;

// 滤镜程度改变
- (void)filterValueChange:(float)value ;

// 显示提示语
- (void)showMessage:(NSString *)message ;

// 显示上半部分View
-(void)showTopView:(BOOL)shown;

-(void)restDefaultValue:(int)type;
@end

@interface FUDemoBar : UIView

/**     美肤参数    **/
/** 精准美肤 (0、1)    */
@property (nonatomic, assign) BOOL skinDetect ;
/** 美肤类型 (0、1、) 清晰：0，朦胧：1    */
@property (nonatomic, assign) NSInteger heavyBlur;
/** 磨皮(0.0 - 6.0)    */
@property (nonatomic, assign) double blurLevel;
/** 美白 (0~1)    */
@property (nonatomic, assign) double colorLevel;
/** 红润 (0~1)    */
@property (nonatomic, assign) double redLevel;
/** 亮眼 (0~1)    */
@property (nonatomic, assign) double eyeBrightLevel;
/** 美牙 (0~1)    */
@property (nonatomic, assign) double toothWhitenLevel;


/**     美型参数    **/
/** 脸型 (0~1)  女神：0，网红：1，自然：2，默认：3，自定义：4 */
//@property (nonatomic, assign) NSInteger faceShape;

/* v脸 (0~1) */
@property (nonatomic, assign) double vLevel;
/* 鹅蛋 (0~1) */
@property (nonatomic, assign) double eggLevel;
/* 窄脸(0~1) */
@property (nonatomic, assign) double narrowLevel;
/* 小脸 (0~1) */
@property (nonatomic, assign) double smallLevel;
/* 大眼 (0~1)    */
@property (nonatomic, assign) double enlargingLevel;
/** 瘦脸 (0~1)    */
@property (nonatomic, assign) double thinningLevel;
///** 大眼 (0~1) --  新版美颜*/
//@property (nonatomic, assign) double enlargingLevel_new;
///** 瘦脸 (0~1) --  新版美颜*/
//@property (nonatomic, assign) double thinningLevel_new;
/**下巴 (0~1)*/
@property (nonatomic, assign) double chinLevel;
/**额头 (0~1)*/
@property (nonatomic, assign) double foreheadLevel;
/**鼻子 (0~1)*/
@property (nonatomic, assign) double noseLevel;
/**嘴型 (0~1)*/
@property (nonatomic, assign) double mouthLevel;

@property (nonatomic,assign) int selMakeupIndex;

/**滤镜名称数组*/
@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;

/**美颜滤镜名称数组*/
@property (nonatomic, strong) NSArray<NSString *> *beautyFiltersDataSource;

/**滤镜中文名称数组*/
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *filtersCHName;

/* 选中的滤镜 */
@property (nonatomic, strong) NSString *selectedFilter;
@property (nonatomic, assign)   double  selectedFilterLevel;

@property (nonatomic, assign) id<FUDemoBarDelegate>mDelegate ;

// 关闭上半部分
-(void)hiddenTopViewWithAnimation:(BOOL)animation ;

// 上半部是否显示
@property (nonatomic, assign) BOOL isTopViewShow ;

@property (nonatomic, strong) FUMakeUpView *makeupView;
@end
