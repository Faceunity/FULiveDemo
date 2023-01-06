//
//  FUVideoComponentDefines.h
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/16.
//

#ifndef FUVideoComponentDefines_h
#define FUVideoComponentDefines_h

/// 弱引用对象
#define FUWeakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;

/// 强引用对象
#define FUStrongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;

/// 视频方向
typedef NS_ENUM(NSInteger, FUVideoOrientation) {
    FUVideoOrientationPortrait = 0,
    FUVideoOrientationLandscapeRight,
    FUVideoOrientationUpsideDown,
    FUVideoOrientationLandscapeLeft
};

#endif /* FUVideoComponentDefines_h */
