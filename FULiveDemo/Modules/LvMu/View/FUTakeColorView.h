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

@interface FUTakeColorView : UIView

-(instancetype)initWithFrame:(CGRect)frame didChangeBlock:(FUTakeColorChange)block;

-(void)actionRect:(CGRect )rect;

@end

NS_ASSUME_NONNULL_END
