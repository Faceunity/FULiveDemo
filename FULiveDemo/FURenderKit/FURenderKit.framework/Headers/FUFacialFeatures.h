//
//  FUFacialFeatures.h
//  FURenderKit
//
//  Created by Chen on 2021/3/19.
//

#import "FUSticker.h"
#import "CNamaSDK.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * 面部特征
 */
@interface FUFacialFeatures : FUSticker
@property (nonatomic, assign) FUAITYPE aiType;

@property (nonatomic, assign) FUAITYPE landmarksType;

@end

NS_ASSUME_NONNULL_END
