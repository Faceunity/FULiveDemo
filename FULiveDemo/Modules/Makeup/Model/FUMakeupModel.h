//
//  FUSingleMakeupModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUSingleMakeupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUMakeupModel : NSObject
/* 类别名称 */
@property (nonatomic, copy) NSString* name;
/* 记录一份子妆容的所有集合
  如口红: sgArr就包含 口红1，口红2，口红3......
 */
@property (nonatomic, copy) NSArray <FUSingleMakeupModel *>* sgArr;
/* 被选中的索引 */
@property (assign, nonatomic) int singleSelIndex;
/* 颜色键值 */
@property (nonatomic, copy) NSString* colorStr;
/* 颜色值 */
@property (nonatomic, strong) NSArray* colorStrV;


@end

NS_ASSUME_NONNULL_END
