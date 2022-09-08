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

#define FUPicturePixelMaxSize ([FUManager shareManager].devicePerformanceLevel == FUDevicePerformanceLevelHigh ? 12746752 : 5760000)

#pragma mark - 常量

extern NSString * const FUPersistentBeautyKey;

#pragma mark - 枚举

typedef NS_ENUM(NSUInteger, FUGroupType) {
    FUGroupTypeFace = 0,
    FUGroupTypeBody,
    FUGroupTypeContentService
};

//typedef NS_ENUM(NSUInteger, FULiveModelType) {
//    FULiveModelTypeBeautifyFace             = 0,
//    FULiveModelTypeMakeUp,
//    FULiveModelTypeItems,
//    FULiveModelTypeAnimoji,
//    FULiveModelTypeHair,
//    FULiveModelTypeLightMakeup,
//    FULiveModelTypeARMarsk,
//    FULiveModelTypeHilarious,
//    FULiveModelTypePoster,//海报换脸
//    FULiveModelTypeExpressionRecognition,
//    FULiveModelTypeMusicFilter,
//    FULiveModelTypeHahaMirror,
//    FULiveModelTypeBody,
//    FULiveModelTypeWholeAvatar,
//    FULiveModelTypeBGSegmentation,
//    FULiveModelTypeGestureRecognition,
//    FULiveModelTypeLvMu,
//    FULiveModelTypeQSTickers
//};

typedef NS_ENUM(NSUInteger, FUModuleType) {
    FUModuleTypeBeauty = 0,
    FUModuleTypeMakeup,
    FUModuleTypeSticker,
    FUModuleTypeAnimoji,
    FUModuleTypeHair,
    FUModuleTypeLightMakeup,
    FUModuleTypeARMask,
    FUModuleTypeHilarious,
    FUModuleTypePoster,
    FUModuleTypeExpressionRecognition,
    FUModuleTypeMusicFilter,
    FUModuleTypeDistortingMirror,
    FUModuleTypeBody,
    FUModuleTypeWholeAvatar,
    FUModuleTypeSegmentation,
    FUModuleTypeGestureRecognition,
    FUModuleTypeGreenScreen,
    FUModuleTypeQualityTicker
};

/// AI模型分类
typedef NS_OPTIONS(NSUInteger, FUAIModelType) {
    FUAIModelTypeFace     = 1 << 0,     // 人脸
    FUAIModelTypeHuman    = 1 << 1,     // 人体
    FUAIModelTypeHand     = 1 << 2      // 手势
};

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

