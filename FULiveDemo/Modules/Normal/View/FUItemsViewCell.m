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
        self.imageView.layer.borderColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor;
    }else {
        self.imageView.layer.borderWidth = 0.0 ;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
