//
//  FUTakeColorView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2020/8/18.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FUTakeColorChange)(UIColor *color);

typedef void(^FUTakeColorComplete)(void);


@protocol FUTakeColorViewDataSource <NSObject>

// 开启滤镜
- (UIColor *)takeColorView:(CGPoint )screenP;
@end


@interface FUTakeColorView : UIView

@property(nonatomic,strong)UIView *perView;

@property(nonatomic,assign)id<FUTakeColorViewDataSource> dataSource;



-(instancetype)initWithFrame:(CGRect)frame didChangeBlock:(FUTakeColorChange)block complete:(FUTakeColorComplete)complete;

-(void)actionRect:(CGRect )rect;

-(void)toucheSetPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
