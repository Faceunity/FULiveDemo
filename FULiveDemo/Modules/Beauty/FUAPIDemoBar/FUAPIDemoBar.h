//
//  FUAPIDemoBar.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/26.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDemoBar.h"

@protocol FUAPIDemoBarDelegate <NSObject>

@optional
// 美颜参数改变
- (void)demoBarBeautyParamChanged;
// 滤镜程度改变
- (void)demoBarFilterValueChange:(float)value ;
// 显示提示语
- (void)demoBarShouldShowMessage:(NSString *)message ;
// 显示上半部分View
-(void)demoBarDidShowTopView:(BOOL)shown ;

-(void)restDefaultValue:(int)type;
@end

@interface FUAPIDemoBar : UIView

@property (nonatomic, strong) FUDemoBar *demoBar ;

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

/* v脸 (0~1) */
@property (nonatomic, assign) double vLevel;
/* 鹅蛋 (0~1) */
@property (nonatomic, assign) double eggLevel;
/* 窄脸(0~1) */
@property (nonatomic, assign) double narrowLevel;
/* 小脸 (0~1) */
@property (nonatomic, assign) double smallLevel;
/** 脸型 (0~1)  女神：0，网红：1，自然：2，默认：3，自定义：4 */
//@property (nonatomic, assign) NSInteger faceShape;
/** 大眼 (0~1)    */
@property (nonatomic, assign) double enlargingLevel;
/** 瘦脸 (0~1)    */
@property (nonatomic, assign) double thinningLevel;
/** 大眼 (0~1) --  新版美颜*/
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


/**滤镜名称数组*/
@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;
/**美颜滤镜名称数组*/
@property (nonatomic, strong) NSArray<NSString *> *beautyFiltersDataSource;
/**滤镜中文名称数组*/
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *filtersCHName;
/* 选中的滤镜 */
@property (nonatomic, strong) NSString *selectedFilter;
/* 选中滤镜的 level*/
@property (nonatomic, assign) double selectedFilterLevel;

@property (nonatomic, assign) id<FUAPIDemoBarDelegate>delegate ;


// 隐藏上半部分
- (void)hiddeTopView ;
// 上半部是否显示
@property (nonatomic, assign) BOOL isTopViewShow ;

@end
