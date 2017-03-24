//
//  FUAPIDemoBar.h
//  FUAPIDemoBar
//
//  Created by 刘洋 on 2017/1/10.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for FUDemoBar.
FOUNDATION_EXPORT double FUDemoBarVersionNumber;

//! Project version string for FUDemoBar.
FOUNDATION_EXPORT const unsigned char FUDemoBarVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FUDemoBar/PublicHeader.h>


@protocol FUAPIDemoBarDelegate <NSObject>

@optional
- (void)demoBarDidSelectedItem:(NSString *)item;

- (void)demoBarDidSelectedFilter:(NSString *)filter;

- (void)demoBarBeautyParamChanged;

@end


@interface FUAPIDemoBar : UIView

@property (nonatomic, assign) id<FUAPIDemoBarDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedBlur;

@property (nonatomic, assign) double redLevel;

@property (nonatomic, assign) double faceShapeLevel;

@property (nonatomic, assign) NSInteger faceShape;

@property (nonatomic, assign) double beautyLevel;

@property (nonatomic, assign) double thinningLevel;

@property (nonatomic, assign) double enlargingLevel;

@property (nonatomic, strong) NSString *selectedItem;

@property (nonatomic, strong) NSString *selectedFilter;

@property (nonatomic, strong) NSArray<NSString *> *itemsDataSource;

@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;

@end
