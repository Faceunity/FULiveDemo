//
//  FUPosterCell.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/8.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUPosterCell.h"

@implementation FUPosterCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
}

@end
