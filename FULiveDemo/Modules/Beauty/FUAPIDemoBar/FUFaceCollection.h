//
//  FUFaceCollection.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/28.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDemoBarDefine.h"


@protocol FUFaceCollectionDelegate <NSObject>

- (void)didSelectedFaceType:(NSInteger)index ;
@end

@interface FUFaceCollection : UICollectionView

//@property (nonatomic, assign) FUFaceCollectionType type ;

// 性能优先，默认为 NO
@property (nonatomic, assign) BOOL performance ;

@property (nonatomic, assign) NSInteger selectedIndex ;

@property (nonatomic, assign) id<FUFaceCollectionDelegate>mDelegate ;
@end

@interface FUFaceCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label ;
@property (nonatomic, strong) UIView *line ;
- (void)resetLineFrame ;
@end
