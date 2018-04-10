//
//  FUItemsViewCell.m
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUItemsViewCell.h"

@implementation FUItemsViewCell

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.imageView.layer.borderWidth = 3.0 ;
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }else {
        self.imageView.layer.borderWidth = 0.0 ;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
