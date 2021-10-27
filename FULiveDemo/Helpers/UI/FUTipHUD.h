//
//  FUTipHUD.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/4/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUTipHUD : NSObject

+ (void)showTips:(NSString *)tipsString;

@end

@interface FUInsertsLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets;

@end

NS_ASSUME_NONNULL_END
