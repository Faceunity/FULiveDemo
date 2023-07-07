//
//  FUBeautyDefine.h
//  FUBeautyUIComponent
//
//  Created by 项林平 on 2022/6/9.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#ifndef FUBeautyDefine_h
#define FUBeautyDefine_h


#define FUBeautyStringWithKey(aKey) NSLocalizedString(aKey, nil)

#pragma mark - Const

extern const CGFloat FUBeautyCategoryViewHeight;

extern const CGFloat FUBeautyFunctionViewOverallHeight;

extern const CGFloat FUBeautyFunctionSliderHeight;

extern NSString * const FUPersistentBeautySkinKey;

extern NSString * const FUPersistentBeautyShapeKey;

extern NSString * const FUPersistentBeautyFilterKey;

extern NSString * const FUPersistentBeautySelectedFilterIndexKey;


#pragma mark - Enum

typedef NS_ENUM(NSInteger, FUBeautyCategory) {
    FUBeautyCategoryNone = -1,
    FUBeautyCategorySkin = 0,       //美肤
    FUBeautyCategoryShape = 1,      //美型
    FUBeautyCategoryFilter = 2      //滤镜
};

typedef NS_ENUM(NSUInteger, FUBeautySkin) {
    FUBeautySkinBlurLevel = 0,
    FUBeautySkinColorLevel,
    FUBeautySkinRedLevel,
    FUBeautySkinSharpen,
    FUBeautySkinFaceThreed,
    FUBeautySkinEyeBright,
    FUBeautySkinToothWhiten,
    FUBeautySkinRemovePouchStrength,
    FUBeautySkinRemoveNasolabialFoldsStrength
};

typedef NS_ENUM(NSUInteger, FUBeautyShape) {
    FUBeautyShapeCheekThinning = 0,
    FUBeautyShapeCheekV,
    FUBeautyShapeCheekNarrow,
    FUBeautyShapeCheekShort,
    FUBeautyShapeCheekSmall,
    FUBeautyShapeCheekbones,
    FUBeautyShapeLowerJaw,
    FUBeautyShapeEyeEnlarging,
    FUBeautyShapeEyeCircle,
    FUBeautyShapeChin,
    FUBeautyShapeForehead,
    FUBeautyShapeNose,
    FUBeautyShapeMouth,
    FUBeautyShapeLipThick,
    FUBeautyShapeEyeHeight,
    FUBeautyShapeCanthus,
    FUBeautyShapeEyeLid,
    FUBeautyShapeEyeSpace,
    FUBeautyShapeEyeRotate,
    FUBeautyShapeLongNose,
    FUBeautyShapePhiltrum,
    FUBeautyShapeSmile,
    FUBeautyShapeBrowHeight,
    FUBeautyShapeBrowSpace,
    FUBeautyShapeBrowThick
};

#pragma mark - Inline methods

static inline CGFloat FUBeautyHeightIncludeBottomSafeArea(CGFloat height) {
    if (@available(iOS 11.0, *)) {
        height += [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return height;
}

static inline UIImage * FUBeautyImageNamed(NSString *name) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FUBeautyComponent" ofType:@"framework" inDirectory:@"Frameworks"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];;
}

#endif /* FUBeautyDefine_h */
