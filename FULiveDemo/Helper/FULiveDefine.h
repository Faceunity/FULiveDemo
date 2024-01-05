//
//  FULiveDefine.h
//  FULive
//
//  Created by L on 2018/8/1.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+FU.h"

#pragma mark - 宏

#define FUScreenWidth (CGRectGetWidth([UIScreen mainScreen].bounds))

#define FUScreenHeight (CGRectGetHeight([UIScreen mainScreen].bounds))

/// 状态栏高度
#define FUStatusBarHeight (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

#define FUDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define FUColorFromHexString(aHex) [UIColor colorWithHexColorString:aHex]

#define FUColorFromHexStringWithAlpha(aHex, aAlpha) [UIColor colorWithHexColorString:aHex alpha:aAlpha]

#define FUColorFromHex(aHex) [UIColor colorWithHex:aHex]

#define FUColorFromHexWithAlpha(aHex, aAlpha) [UIColor colorWithHex:aHex alpha:aAlpha]

#define FULocalizedString(key) NSLocalizedString(key, nil)

#define FUPicturePixelMaxSize ([FURenderKitManager sharedManager].devicePerformanceLevel >= FUDevicePerformanceLevelHigh ? 12746752 : 5760000)

#define FUStickersPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickers"]

#define FUStickerIconsPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickerIcons"]

#define FUStickerBundlesPath [FUDocumentPath stringByAppendingPathComponent:@"FUStickerBundles"]


#pragma mark - 枚举

/// 特效模块分组
typedef NS_ENUM(NSUInteger, FUGroup) {
    FUGroupFace = 0,
    FUGroupBody,
    FUGroupContentService
};

/// 特效模块
typedef NS_ENUM(NSUInteger, FUModule) {
    FUModuleBeauty = 0,
    FUModuleMakeup,
    FUModuleStyle,
    FUModuleSticker,
    FUModuleAnimoji,
    FUModuleHairBeauty,
    FUModuleLightMakeup,
    FUModuleARMask,
    FUModuleHilarious,
    FUModuleFaceFusion,
    FUModuleExpressionRecognition,
    FUModuleMusicFilter,
    FUModuleDistortingMirror,
    FUModuleBodyBeauty,
    FUModuleBodyAvatar,
    FUModuleSegmentation,
    FUModuleGestureRecognition,
    FUModuleGreenScreen,
    FUModuleQualityTicker
};

/// AI模型分类
typedef NS_OPTIONS(NSUInteger, FUAIModelType) {
    FUAIModelTypeFace     = 1 << 0,     // 人脸
    FUAIModelTypeHuman    = 1 << 1,     // 人体
    FUAIModelTypeHand     = 1 << 2      // 手势
};

/// 跟踪部位
typedef NS_ENUM(NSInteger, FUDetectingParts) {
    FUDetectingPartsFace = 0,   // 人脸
    FUDetectingPartsHuman,      // 人体
    FUDetectingPartsHand,       // 手势
    FUDetectingPartsNone        // 不需要跟踪
};

/// 子妆容类型
typedef NS_ENUM(NSUInteger, FUSingleMakeupType) {
    FUSingleMakeupTypeFoundation,   // 粉底
    FUSingleMakeupTypeLip,          // 口红
    FUSingleMakeupTypeBlusher,      // 腮红
    FUSingleMakeupTypeEyebrow,      // 眉毛
    FUSingleMakeupTypeEyeshadow,    // 眼影
    FUSingleMakeupTypeEyeliner,     // 眼线
    FUSingleMakeupTypeEyelash,      // 睫毛
    FUSingleMakeupTypeHighlight,    // 高光
    FUSingleMakeupTypeShadow,       // 阴影
    FUSingleMakeupTypePupil         // 美瞳
};

#pragma mark - 内联函数

static inline UIWindow * FUKeyWindow(void) {
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    return keyWindow;
}

static inline BOOL FUDeviceIsiPhoneXStyle(void) {
    UIWindow *keyWindow = FUKeyWindow();
    if (@available(iOS 11.0, *)) {
        CGFloat bottomInsets = keyWindow.safeAreaInsets.bottom;
        if (bottomInsets > 0) {
            return YES;
        }
    }
    return NO;
}

static inline CGFloat FUHeightIncludeBottomSafeArea(CGFloat height) {
    if (@available(iOS 11.0, *)) {
        height += FUKeyWindow().safeAreaInsets.bottom;
    }
    return height;
}

static inline CGFloat FUHeightIncludeTopSafeArea(CGFloat height) {
    if (@available(iOS 11.0, *)) {
        height += FUKeyWindow().safeAreaInsets.top;
    }
    return height;
}

static inline NSString * FUCurrentDateString(void) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYYMMddhhmmssSS";
    NSDate *date = [NSDate date];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

