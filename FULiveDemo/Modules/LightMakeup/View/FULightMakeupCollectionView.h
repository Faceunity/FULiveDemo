//
//  FULightMakeupCollectionView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FULightModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol FULightMakeupCollectionViewDelegate <NSObject>
@optional
- (void)lightMakeupCollectionView:(FULightModel *)model;

- (void)lightMakeupModleValue:(FULightModel *)model;
@end
@interface FULightMakeupCollectionView : UIView

@property(nonatomic,strong) FULightModel *currentLightModel;

-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray <FULightModel *> *)dataArray delegate:(id<FULightMakeupCollectionViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
