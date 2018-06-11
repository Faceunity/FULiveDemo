//
//  FUAPIDemoBar.h
//  FUAPIDemoBar
//
//  Created by L on 2018/4/12.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoBarType.h"

//! Project version number for FUDemoBar.
FOUNDATION_EXPORT double FUDemoBarVersionNumber;

//! Project version string for FUDemoBar.
FOUNDATION_EXPORT const unsigned char FUDemoBarVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FUDemoBar/PublicHeader.h>


@protocol FUAPIDemoBarDelegate <NSObject>

@optional
- (void)demoBarDidSelectedItem:(NSString *)itemName;

- (void)demoBarDidSelectedFilter:(NSString *)filter;

- (void)demoBarBeautyParamChanged;

-(void)demoBarDidShowTopView:(BOOL)shown;

- (void)demoBarDidShouldShowTip:(NSString *)tip ;
@end

@interface FUAPIDemoBar : UIView

@property (nonatomic, assign) id<FUAPIDemoBarDelegate>delegate ;

@property (nonatomic, assign) FUAPIDemoBarType demoBarType ;

@property (nonatomic, assign) BOOL skinDetectEnable ;   // 精准美肤

@property (nonatomic, assign) NSInteger blurShape;      // 美肤类型 (0、1、) 清晰：0，朦胧：1
@property (nonatomic, assign) double blurLevel;         // 磨皮
@property (nonatomic, assign) double whiteLevel;        // 美白
@property (nonatomic, assign) double redLevel;          // 红润
@property (nonatomic, assign) double eyelightingLevel;  // 亮眼
@property (nonatomic, assign) double beautyToothLevel;  // 美牙

@property (nonatomic, assign) NSInteger faceShape;        // 脸型 (0、1、2) 女神：0，网红：1，自然：2
@property (nonatomic, assign) double enlargingLevel;      /**大眼 (0~1)*/
@property (nonatomic, assign) double thinningLevel;       /**瘦脸 (0~1)*/

@property (nonatomic, assign) double enlargingLevel_new;      /**大眼 (0~1) --  新版美颜*/
@property (nonatomic, assign) double thinningLevel_new;       /**瘦脸 (0~1) --  新版美颜*/

@property (nonatomic, assign) double jewLevel;            /**下巴 (0~1)*/
@property (nonatomic, assign) double foreheadLevel;       /**额头 (0~1)*/
@property (nonatomic, assign) double noseLevel;           /**鼻子 (0~1)*/
@property (nonatomic, assign) double mouthLevel;          /**嘴型 (0~1)*/

@property (nonatomic, strong) NSArray<NSString *> *itemsDataSource ; /**道具名称数组*/
@property (nonatomic, copy) NSString *selectedItem ;                 /**选中的道具名称*/

@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;     /**滤镜名称数组*/
@property (nonatomic, strong) NSArray<NSString *> *beautyFiltersDataSource;     /**美颜滤镜名称数组*/
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *filtersCHName;       /**滤镜中文名称数组*/
@property (nonatomic, strong) NSString *selectedFilter; /* 选中的滤镜 */
@property (nonatomic, assign, readonly) double selectedFilterLevel; /* 选中滤镜的 level*/

- (void)setFilterLevel:(double)level forFilter:(NSString *)filter;
@end
