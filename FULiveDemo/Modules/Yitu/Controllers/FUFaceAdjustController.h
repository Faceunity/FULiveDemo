//
//  FUFaceAdjustController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUYituItemModel.h"
#import "FUYituModel.h"
typedef NS_ENUM(NSUInteger, FUFaceEditModleType) {
    FUFaceEditModleTypeNew,
    FUFaceEditModleTypeReEdit,
};
NS_ASSUME_NONNULL_BEGIN
typedef void(^FUFaceAdjustEditSuccess)(FUYituModel *model);
@interface FUFaceAdjustController : UIViewController
@property(strong ,nonatomic) UIImageView *imageView;
@property(nonatomic ,assign) FUFaceEditModleType editType;

@property(copy ,nonatomic) FUFaceAdjustEditSuccess saveSuccessBlock;

/* 意图数据，重新编辑，用于更新 */
@property(strong ,nonatomic) FUYituModel *yituModle;

-(void)addAllFaceItems:(NSArray <FUYituItemModel *> *)itemModels;

@end

NS_ASSUME_NONNULL_END
