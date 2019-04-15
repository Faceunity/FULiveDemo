//
//  FUYituModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/18.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUYituModel : NSObject

@property (nonatomic,assign) float width;
@property (nonatomic,assign) float height;
@property (nonatomic, strong) NSArray* group_points;
@property (nonatomic, strong) NSArray* group_type;
@property (nonatomic, copy) NSString* imagePathMid;
@end

NS_ASSUME_NONNULL_END
