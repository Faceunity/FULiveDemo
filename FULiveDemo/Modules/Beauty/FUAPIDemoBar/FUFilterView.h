//
//  FUFilterView.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDemoBarDefine.h"


@protocol FUFilterViewDelegate <NSObject>

// 开启滤镜
- (void)filterViewDidSelectedFilter:(NSString *)filterName Type:(FUFilterViewType)type;
@end


@interface FUFilterView : UICollectionView

@property (nonatomic, assign) FUFilterViewType type ;

@property (nonatomic, assign) id<FUFilterViewDelegate>mDelegate ;

@property (nonatomic, strong) NSArray <NSString *>*filterDataSource ;

@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *filtersCHName;

@property (nonatomic, assign) NSInteger selectedIndex ;
@end

@interface FUFilterCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel ;
@end
