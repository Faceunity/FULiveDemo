//
//  FUBeautyModel.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/24.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUBeautyDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyModel : NSObject
@property (nonatomic,copy)NSString *mTitle;

@property (nonatomic, assign) NSUInteger mParam;

@property (nonatomic,assign) double mValue;

@property (nonatomic, strong) NSString *strValue;

@property (nonatomic,copy)NSString *mImageStr;

/* 双向的参数  0.5是原始值*/
@property (nonatomic,assign) BOOL iSStyle101;

/* 默认值用于，设置默认和恢复 */
@property (nonatomic, assign)float defaultValue;

//参数强度取值比例 进度条因为是归一化 所以要 除以ratio
@property (nonatomic, assign) float ratio;

//标识类型
@property (nonatomic, assign) FUBeautyDefine type;
@end

NS_ASSUME_NONNULL_END
