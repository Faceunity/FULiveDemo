//
//  FUGreenScreenDefine.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/11.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#ifndef FUGreenScreenDefine_h
#define FUGreenScreenDefine_h

#pragma mark - Const

extern const CGFloat FUGreenScreenCategoryViewHeight;

extern const CGFloat FUGreenScreenFunctionViewHeight;

extern const CGFloat FUGreenScreenFunctionViewOverallHeight;

extern const CGFloat FUFUGreenScreenBackgroundViewHeight;

#pragma mark - Enum

typedef NS_ENUM(NSInteger, FUGreenScreenCategory) {
    FUGreenScreenCategoryNone = -1,
    FUGreenScreenCategoryKeying = 0,        //抠像
    FUGreenScreenCategoryBackground = 1     //背景
};

typedef NS_ENUM(NSUInteger, FUGreenScreenKeyingType) {
    FUGreenScreenKeyingTypeColor,           //关键颜色
    FUGreenScreenKeyingTypeChromaThres,     //相似度
    FUGreenScreenKeyingTypeChromaThrest,    //平滑度
    FUGreenScreenKeyingTypeAlphaL,          //祛色度
    FUGreenScreenKeyingTypeSafeArea         //安全区域
};

#pragma mark - Inline methods

static inline CGFloat FUGreenScreenHeightIncludeBottomSafeArea(CGFloat height) {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        height += keyWindow.safeAreaInsets.bottom;
    }
    return height;
}

static inline NSBundle * FUGreenScreenBundel(void) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FUGreenScreenComponent" ofType:@"framework" inDirectory:@"Frameworks"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return bundle;
}

static inline NSString * FUGreenScreenStringWithKey(NSString *key) {
    return [FUGreenScreenBundel() localizedStringForKey:key value:nil table:@"FUGreenScreenComponent"];
}

static inline UIImage * FUGreenScreenImageNamed(NSString *name) {
    return [UIImage imageNamed:name inBundle:FUGreenScreenBundel() compatibleWithTraitCollection:nil];;
}

#endif /* FUGreenScreenDefine_h */


