//
//  FULiveDefine.h
//  FULive
//
//  Created by L on 2018/8/1.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 宏

#define FUScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define FUScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define iPhoneXStyle ((FUScreenWidth == 375.f && FUScreenHeight == 812.f ? YES : NO) || (FUScreenWidth == 414.f && FUScreenHeight == 896.f ? YES : NO))

#define FUDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define FUStickersPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickers"]

#define FUStickerIconsPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickerIcons"]

#define FUStickerBundlesPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickerBundles"]

#define FUNSLocalizedString(Context,comment)  [NSString stringWithFormat:@"%@", [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(Context) value:nil table:nil]]

#pragma mark - 常量

static float const FUPicturePixelMaxSize = 24000000;

#pragma mark - 内联函数

static inline CGFloat FUHeightIncludeBottomSafeArea(CGFloat height) {
    if (@available(iOS 11.0, *)) {
        height += [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return height;
}

static inline NSString * FUCurrentDateString() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYYMMddhhmmssSS";
    NSDate *date = [NSDate date];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

