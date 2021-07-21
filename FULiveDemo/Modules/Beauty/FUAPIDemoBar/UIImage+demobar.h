//
//  UIImage+demobar.h
//  FUAPIDemoBar
//
//  Created by 刘洋 on 2017/2/16.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (demobar)
+ (UIImage *)imageWithName:(NSString *)name;

/**
 * 适配图片多语言文案问题
 * countrySimple 国家简写标识， countrySimple == nil，获取系统分配的国家语言简写标识,  countrySimple == @""表示不加国家简写后缀
 * 多语言图片适配规则 name + '_' + countrySimple,   图片命名必须严格按照该规则 'Style7-3_en' 
 */
+ (UIImage *)localizedImageWithName:(NSString *)name countrySimple:(NSString *)countrySimple;
@end
