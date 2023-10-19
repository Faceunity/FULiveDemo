//
//  FUMakeupDefine.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/7.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#ifndef FUMakeupDefine_h
#define FUMakeupDefine_h

#pragma mark - ENUM

/// 子妆容类型
typedef NS_ENUM(NSUInteger, FUSubMakeupType) {
    FUSubMakeupTypeFoundation,   // 粉底
    FUSubMakeupTypeLip,          // 口红
    FUSubMakeupTypeBlusher,      // 腮红
    FUSubMakeupTypeEyebrow,      // 眉毛
    FUSubMakeupTypeEyeShadow,    // 眼影
    FUSubMakeupTypeEyeliner,     // 眼线
    FUSubMakeupTypeEyelash,      // 睫毛
    FUSubMakeupTypeHighlight,    // 高光
    FUSubMakeupTypeShadow,       // 阴影
    FUSubMakeupTypePupil         // 美瞳
};

#pragma mark - Inline methods

static inline CGFloat FUMakeupHeightIncludeBottomSafeArea(CGFloat height) {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        height += keyWindow.safeAreaInsets.bottom;
    }
    return height;
}

static inline NSBundle * FUMakeupBundle(void) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FUMakeupComponent" ofType:@"framework" inDirectory:@"Frameworks"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return bundle;
}

static inline NSString * FUMakeupStringWithKey(NSString *key) {
    return [FUMakeupBundle() localizedStringForKey:key value:nil table:@"FUMakeupComponent"];
}

static inline UIImage * FUMakeupImageNamed(NSString *name) {
    return [UIImage imageNamed:name inBundle:FUMakeupBundle() compatibleWithTraitCollection:nil];;
}

#endif /* FUMakeupDefine_h */
