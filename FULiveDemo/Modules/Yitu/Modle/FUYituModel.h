//
//  FUYituModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/18.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUYituItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUYituModel : NSObject

@property (nonatomic,assign) float width;
@property (nonatomic,assign) float height;
@property (nonatomic, strong) NSArray* group_points;
@property (nonatomic, strong) NSArray* group_type;
@property (nonatomic, copy) NSString* imagePathMid;


/* 保存UI状态，用于再次编译 */
@property (nonatomic, strong) NSArray <FUYituItemModel *> *itemModels;


@end

NS_ASSUME_NONNULL_END
