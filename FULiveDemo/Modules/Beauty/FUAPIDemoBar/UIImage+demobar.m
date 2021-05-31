//
//  UIImage+demobar.m
//  FUAPIDemoBar
//
//  Created by 刘洋 on 2017/2/16.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "UIImage+demobar.h"
#import "FUAPIDemoBar.h"

@implementation UIImage (demobar)

+ (UIImage *)imageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:FUAPIDemoBar.class] compatibleWithTraitCollection:nil];
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

/**
 * 适配图片多语言文案问题
 * countrySimple 国家简写标识， == nil，获取系统分配的国家语言简写标识
 */
+ (UIImage *)localizedImageWithName:(NSString *)name countrySimple:(NSString *)countrySimple {
    UIImage *image = [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:FUAPIDemoBar.class] compatibleWithTraitCollection:nil];
    if (image) {
        return image;
    }
    
    if (countrySimple == nil) {
        NSDictionary *dic = [NSLocale componentsFromLocaleIdentifier:[NSLocale currentLocale].localeIdentifier];
        NSString *kCFLocaleLanguageCodeKey = [dic objectForKey:NSLocaleLanguageCode];
        countrySimple = kCFLocaleLanguageCodeKey;
    }
    
    if (countrySimple.length == 0) {
        image = [UIImage imageNamed:name];
    } else {
        // * 多语言图片适配规则 name + '_' + countrySimple,   图片命名必须严格按照该规则 'Style7-3_en' 
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",name,countrySimple]];
    }
    return image;
}

@end
