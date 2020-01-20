//
//  FUMakeupSupModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/11.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUSingleMakeupModel.h"

NS_ASSUME_NONNULL_BEGIN


///  整体妆容模型
@interface FUMakeupSupModel : NSObject<NSCopying,NSMutableCopying>
/* 妆容nama */
@property (copy, nonatomic) NSString *name;
/* 妆容icon */
@property (copy, nonatomic) NSString *imageStr;
/* 妆容上加的滤镜名称 */
@property (nonatomic, strong) NSString *selectedFilter;
/* 选中滤镜的 level*/
@property (nonatomic, assign) double selectedFilterLevel;
/* cell 选中记录 */
@property (assign, nonatomic) BOOL isSel;
/* 组合妆程度值 */
@property (nonatomic, assign) float value;
/* 工程路径下，美妆bundle 名称 */
@property (nonatomic, strong) NSString *makeupBundle;

/* 组合妆程度值 */
@property (nonatomic, assign) int is_flip_points;

/* 组合妆对应所有子妆容
 
 注意：针对整体妆容想要进一步预览和修改子妆容添加，
 
 makeups里包括：口红，腮红，眉毛.....
 FUSingleMakeupModel 对应一个部位数据modle
 */
@property (nonatomic, copy) NSMutableArray <FUSingleMakeupModel *>* makeups;

@end



NS_ASSUME_NONNULL_END
