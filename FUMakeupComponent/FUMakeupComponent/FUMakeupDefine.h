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

#define FUMakeupStringWithKey(aKey) NSLocalizedString(aKey, nil)

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
        height += [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return height;
}

static inline UIImage * FUMakeupImageNamed(NSString *name) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FUMakeupComponent" ofType:@"framework" inDirectory:@"Frameworks"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];;
}

#endif /* FUMakeupDefine_h */
