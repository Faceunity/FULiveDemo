//
//  FUQualitySticker.h
//  FURenderKit
//
//  Created by Chen on 2021/4/14.
//

#import "FUSticker.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUQualitySticker : FUSticker
@property (nonatomic, assign) BOOL isFlipPoints; //点位镜像，0为关闭，1为开启
@property (nonatomic, assign) BOOL is3DFlipH; //翻转模型

/// 精品贴纸点击屏幕特殊效果
- (void)clickToChange;

@end

NS_ASSUME_NONNULL_END
