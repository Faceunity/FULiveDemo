//
//  UIColor+FU.h
//  FULive
//
//  Created by L on 2018/7/31.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FU)

/** 十六进制颜色  */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;

/** 十六进制颜色:含alpha   */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha;
@end
