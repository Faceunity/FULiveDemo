//
//  UIColor+FU.h
//  FULive
//
//  Created by L on 2018/7/31.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FU)

/// 十六进制颜色字符串转UIColor
/// @param hexColorString 颜色字符串
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;

/// 十六进制颜色字符串转UIColor
/// @param hexColorString 颜色字符串
/// @param alpha 透明度
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(CGFloat)alpha;

/// 十六进制颜色转UIColor
/// @param hex 十六进制颜色值
+ (UIColor *)colorWithHex:(NSUInteger)hex;

/// 十六进制颜色转UIColor
/// @param hex 十六进制颜色值
/// @param alpha 透明度
+ (UIColor *)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;

@end
