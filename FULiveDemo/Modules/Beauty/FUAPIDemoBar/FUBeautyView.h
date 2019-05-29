//
//  FUBeautyView.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDemoBarDefine.h"

@protocol FUBeautyViewDelegate <NSObject>

// 美型页点击
- (void)shapeViewDidSelectedIndex:(NSInteger)index ;

// 美肤页点击
- (void)skinViewDidSelectedIndex:(NSInteger)index ;

// 精准美肤变化
- (void)skinDetectChanged:(BOOL)detect ;
// 清晰磨皮 朦胧磨皮切换
- (void)heavyBlurChange:(NSInteger)heavyBlur ;

@end

@interface FUBeautyView : UICollectionView

@property (nonatomic, assign) FUBeautyViewType type ;

@property (nonatomic, assign) id<FUBeautyViewDelegate>mDelegate ;

@property (nonatomic, assign, readonly) NSInteger selectedIndex ;

/** 脸型 (0~1)  女神：0，网红：1，自然：2，默认：3，自定义：4 */
@property (nonatomic, assign) NSInteger faceShape;

// 控制 精准美肤选项
@property (nonatomic, assign) BOOL skinDetect ;

/** 美肤类型 (0、1、) 清晰：0，朦胧：1    */
@property (nonatomic, assign) NSInteger heavyBlur;

@property (nonatomic, strong) NSDictionary *openedDict ;
@end


@interface FUBeautyCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *titleLabel ;
@end
