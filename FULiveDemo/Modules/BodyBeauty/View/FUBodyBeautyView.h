//
//  FUBodyBeautyView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/2.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUPosition.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUBodyBeautyViewDelegate <NSObject>
@optional
- (void)bodyBeautyViewDidSelectPosition:(FUPosition *)position;

@end

@interface FUBodyBeautyView : UIView

@property (assign,nonatomic) id<FUBodyBeautyViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray <FUPosition *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
