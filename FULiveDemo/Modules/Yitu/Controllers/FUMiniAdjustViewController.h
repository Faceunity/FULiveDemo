//
//  FUMakeUpAdjustViewController.h
//  FULive
//
//  Created by L on 2018/8/31.
//  Copyright © 2018年 faceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FUMiniAdjustViewController : UIViewController

@property (nonatomic, strong) UIImage *image ;

@property (nonatomic, strong) NSMutableArray *pointsArray;

@property (nonatomic, assign) CGPoint preCenter ;
@property (copy, nonatomic) void(^adjustedLandmarksSuccessBlock) (NSMutableArray *array);
@end


@interface FULandmarksAdjustMode : NSObject

@property (nonatomic, strong) NSArray *screenPoints ;
@property (nonatomic, strong) NSArray *landmarks ;
@end
