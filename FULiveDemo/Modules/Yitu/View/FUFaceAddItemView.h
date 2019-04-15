//
//  FUFaceAddItemView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUAdjustImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUYituItemsDelegate <NSObject>

@optional

- (void)yituAddItemView:(FUFacialFeaturesType )type;

@end

@interface FUFaceAddItemView : UIView
@property (nonatomic, assign) id<FUYituItemsDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
