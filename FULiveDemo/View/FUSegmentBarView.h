//
//  FUSegmentBarView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/11/12.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FUSegmentBarView : UIView

@property (nonatomic,assign,readonly) int currentBtnIndex;

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *>*)titlArray selBlock:(void(^)(int index))didSelBtnIndex;
@end
