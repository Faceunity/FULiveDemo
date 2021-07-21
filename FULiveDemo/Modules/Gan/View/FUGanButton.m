//
//  FUGanButton.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/25.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUGanButton.h"

@implementation FUGanButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
        self.layer.cornerRadius = frame.size.width / 2;
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        // NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"加速" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0]}];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    self.titleLabel.center = CGPointMake(midX, midY + 12);
    self.imageView.center = CGPointMake(midX, midY - 7);
    
}

@end
