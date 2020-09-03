//
//  FUBgCollectionView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2020/8/18.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUBeautyParam.h"
#import "FUDemoBarDefine.h"
#import "UIColor+FUAPIDemoBar.h"
NS_ASSUME_NONNULL_BEGIN


@protocol FUBgCollectionViewDelegate <NSObject>

// 开启滤镜
- (void)bgCollectionViewDidSelectedFilter:(FUBeautyParam *)param;
@end


@interface FUBgCollectionView : UIView

@property (nonatomic, assign) id<FUBgCollectionViewDelegate>mDelegate ;

@property (nonatomic, assign) NSInteger selectedIndex ;

@property (nonatomic, strong) NSArray<FUBeautyParam *> *filters;

@property (strong, nonatomic) UICollectionView *mBgCollectionView;

@end

@interface FUBgFilterCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel ;
@end



NS_ASSUME_NONNULL_END
