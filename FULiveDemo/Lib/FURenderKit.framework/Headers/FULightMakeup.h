//
//  FULightMakeup.h
//  FURenderKit
//
//  Created by Chen on 2021/1/14.
//

#import "FUItem.h"
#import "FUStruct.h"
#import <UIKit/UIImage.h>
#import "FUMakeupValueDefine.h"


NS_ASSUME_NONNULL_BEGIN

@interface FULightMakeup : FUItem
@property (nonatomic, assign) BOOL isMakeupOn; //0 关 1开
@property (nonatomic, assign) FUMakeupLipType lipType;//口红类型  0雾面 2润泽 3珠光 6高性能（不支持双色）
@property (nonatomic, assign) BOOL isTwoColor;//口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0
@property (nonatomic, assign) BOOL makeupLipMask;//嘴唇优化效果开关，1.0为开 0为关
@end
@interface FULightMakeup (image)
@property (nonatomic, strong) UIImage *subEyebrowImage;//眉毛
@property (nonatomic, strong) UIImage *subEyeshadowImage;//眼影
@property (nonatomic, strong) UIImage *subPupilImage;//美瞳
@property (nonatomic, strong) UIImage *subEyelashImage;//睫毛
@property (nonatomic, strong) UIImage *subHightLightImage;//高光
@property (nonatomic, strong) UIImage *subEyelinerImage;//眼线
@property (nonatomic, strong) UIImage *subBlusherImage;//腮红
@end

@interface FULightMakeup (intensity)
@property (nonatomic, assign) double intensityLip;//口红
@property (nonatomic, assign) double intensityBlusher;//腮红
@property (nonatomic, assign) double intensityEyeshadow;//眼影
@property (nonatomic, assign) double intensityEyeliner;//眼线
@property (nonatomic, assign) double intensityEyelash;//睫毛
@property (nonatomic, assign) double intensityPupil;//美瞳
@property (nonatomic, assign) double intensityEyebrow;//眉毛
@end

@interface FULightMakeup (Color)
@property (nonatomic, assign) FUColor makeUpLipColor;//口红颜色
@end

@interface FULightMakeup (landMark)
@property (nonatomic, assign) int isUserFix; //这个参数控制是否使用修改过得landmark点，如果设为1为使用，0为不使用
@property (nonatomic, assign) FULandMark fixMakeUpData;//这个参数为一个数组，需要客户端传递一个数组进去，传递的数组的长度为 150*人脸数，也就是将所有的点位信息存储的数组中传递进来。
@end
NS_ASSUME_NONNULL_END
