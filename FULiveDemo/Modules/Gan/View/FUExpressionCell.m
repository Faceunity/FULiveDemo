//
//  FUExpressionCell.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/24.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUExpressionCell.h"

@interface FUExpressionCell()
@property (strong, nonatomic) CAShapeLayer *dottedLineBorder;
@end

@implementation FUExpressionCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _topImage.layer.cornerRadius = 3.0;
        _topImage.clipsToBounds = YES;
        [self.contentView addSubview:_topImage];
        
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 20)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor whiteColor];
        _botlabel.font = [UIFont systemFontOfSize:10];
        _botlabel.text = @"default";
        [self.contentView addSubview:_botlabel];
        
        _dottedLineBorder  = [[CAShapeLayer alloc] init];
        _dottedLineBorder.frame = self.bounds;
        [_dottedLineBorder setLineWidth:2];
        [_dottedLineBorder setFillColor:[UIColor clearColor].CGColor];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_topImage.frame cornerRadius:5];
        _dottedLineBorder.path = path.CGPath;
        [self.contentView.layer addSublayer:_dottedLineBorder];
    }
    return self;
}

-(void)setIsSel:(BOOL)isSel{
    _isSel = isSel;
    if (isSel) {
        _botlabel.textColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0];
        [_dottedLineBorder setStrokeColor:_botlabel.textColor.CGColor];

        
    }else{
        _botlabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [_dottedLineBorder setStrokeColor:_botlabel.textColor.CGColor];
    }
}


@end
