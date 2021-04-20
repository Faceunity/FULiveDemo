//
//  FUFaceRectInfo.h
//  FURenderKit
//
//  Created by Chen on 2021/1/26.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
NS_ASSUME_NONNULL_BEGIN

@interface FUFaceRectInfo : NSObject
+ (instancetype)faceWithId:(int)faceId rect:(CGRect)rect;

@property (nonatomic, assign) int faceId;
@property (nonatomic, assign) CGRect rect;//人脸脸所在图片上的位置
@end

NS_ASSUME_NONNULL_END
