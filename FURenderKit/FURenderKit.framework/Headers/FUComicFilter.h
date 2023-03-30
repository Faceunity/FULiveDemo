//
//  FUAnimationFIlterItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/13.
//

#import "FUItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 动漫滤镜风格
typedef NS_ENUM(NSInteger, FUComicFilterStyle) {
    FUComicFilterStyleNone = -1,        // 无
    FUComicFilterStyleCartoon = 0,      // 动漫
    FUComicFilterStyleSketch = 1,       // 素描
    FUComicFilterStylePortrait = 2,     // 人像
    FUComicFilterStylePainting = 3,     // 油画
    FUComicFilterStyleSandPainting = 4, // 沙画
    FUComicFilterStylePenDrawing = 5,   // 钢笔画
    FUComicFilterStylePencilDrawing = 6,// 铅笔画
    FUComicFilterStyleGraffiti = 7      // 涂鸦
};

@interface FUComicFilter : FUItem

/// 动漫滤镜风格
/// @see FUComicFilterStyle
@property (nonatomic, assign) FUComicFilterStyle style;

@end

NS_ASSUME_NONNULL_END
