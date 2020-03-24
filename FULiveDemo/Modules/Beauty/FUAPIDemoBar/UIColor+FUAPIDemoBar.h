//
//  UIColor+FUDemoBar.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FUAPIDemoBar)

/**
 *  十六进制颜色
 */
+ (UIColor *)fu_colorWithHexColorString:(NSString *)hexColorString;

/**
 *  十六进制颜色:含alpha
 */
+ (UIColor *)fu_colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha;
@end
