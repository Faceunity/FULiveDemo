//
//  FUFilterView.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDemoBarDefine.h"
#import "FUBeautyModel.h"


@protocol FUFilterViewDelegate <NSObject>

// 开启滤镜
- (void)filterViewDidSelectedFilter:(FUBeautyModel *)param;

@end


@interface FUFilterView : UICollectionView

@property (nonatomic, assign) FUFilterViewType type ;

@property (nonatomic, assign) id<FUFilterViewDelegate>mDelegate ;

@property (nonatomic, assign) NSInteger selectedIndex ;

@property (nonatomic, strong) NSArray<FUBeautyModel *> *filters;

-(void)setDefaultFilter:(FUBeautyModel *)filter;

@end

@interface FUFilterCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel;
@end
