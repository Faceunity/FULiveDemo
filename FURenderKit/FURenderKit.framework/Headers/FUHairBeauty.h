//
//  FUHairItem.h
//  FURenderKit
//
//  Created by Chen on 2021/1/15.
//

#import "FUItem.h"
#import "FUStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUHairBeauty : FUItem
/**
 * 单色美发道具 index 对应的值范围 0 - 7，渐变色美发道具，index对应的值范围 0 - 4
 */
@property (nonatomic, assign) int index;
/**
 * 0对应无效果，1对应最强效果，中间连续过渡。
 */
@property (nonatomic, assign) double strength;

@end

@interface FUHairBeauty (normal)
@property (nonatomic, assign) FULABColor normalColor;
@property (nonatomic, assign) double shine;
@end


@interface FUHairBeauty (gradient)
@property (nonatomic, assign) FULABColor gradientColor0;
@property (nonatomic, assign) FULABColor gradientColor1;

@property (nonatomic, assign) double shine0;
@property (nonatomic, assign) double shine1;
@end

NS_ASSUME_NONNULL_END
