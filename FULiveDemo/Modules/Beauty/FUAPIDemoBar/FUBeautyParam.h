//
//  FUBeautyParam.h
//  FULiveDemo
//
//  Created by 孙慕 on 2020/1/7.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyParam : NSObject
@property (nonatomic,copy)NSString *mTitle;

@property (nonatomic,copy)NSString *mParam;

@property (nonatomic,assign) double mValue;

@property (nonatomic,copy)NSString *mImageStr;


/* 双向的参数  0.5是原始值*/
@property (nonatomic,assign) BOOL iSStyle101;

/* 默认值用于，设置默认和恢复 */
@property (nonatomic,assign)float defaultValue;
@end

NS_ASSUME_NONNULL_END
