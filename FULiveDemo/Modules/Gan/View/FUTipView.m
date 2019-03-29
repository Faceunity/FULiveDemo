//
//  FUTipView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/27.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUTipView.h"

@implementation FUTipView

- (IBAction)okBtnClick:(id)sender {
    
    if (_didClick) {
        _didClick(0);
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
    
}


@end
