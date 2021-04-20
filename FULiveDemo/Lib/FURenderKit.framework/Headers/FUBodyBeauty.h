//
//  FUBodyBeauty.h
//  FURenderKit
//
//  Created by Chen on 2021/1/15.
//

#import "FUItem.h"

NS_ASSUME_NONNULL_BEGIN
@interface FUBodyBeauty : FUItem
@property (nonatomic, assign) double bodySlimStrength; //瘦身
@property (nonatomic, assign) double legSlimStrength;  //长腿
@property (nonatomic, assign) double waistSlimStrength; //瘦腰:
@property (nonatomic, assign) double shoulderSlimStrength; //美肩
@property (nonatomic, assign) double hipSlimStrength; //美臀
@property (nonatomic, assign) double headSlim;  //小头
@property (nonatomic, assign) double legSlim;  //瘦腿
@property (nonatomic, assign) int debug; //是否开启debug点位
@property (nonatomic, assign) int clearSlim;  //重置:清空所有的美体效果，恢复为默认值

/**
 * 取值范围 0 ~ 3
 */
@property (nonatomic, assign) int orientation;

@end


NS_ASSUME_NONNULL_END
