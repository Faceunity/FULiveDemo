//
//  FUMakeupTopCell.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMakeupTopCell.h"

@implementation FUMakeupTopCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"FUMakeUpView" owner:self options:nil][1];
        self.frame = frame;
    }
    
    return self;
}

@end
