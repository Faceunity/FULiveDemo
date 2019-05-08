//
//  FUCollectionViewCell.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarCell.h"

@interface FUAvatarCell()
@property (strong, nonatomic) CAShapeLayer *dottedLineBorder;
@end
@implementation FUAvatarCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _image0  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.contentView addSubview:_image0];
        
        _image1  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.contentView addSubview:_image1];
        
        _dottedLineBorder  = [[CAShapeLayer alloc] init];
        _dottedLineBorder.frame = self.bounds;
        [_dottedLineBorder setLineWidth:2];
        [_dottedLineBorder setFillColor:[UIColor clearColor].CGColor];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5];
        _dottedLineBorder.path = path.CGPath;
        [self.contentView.layer addSublayer:_dottedLineBorder];
    }
    
    return self;
}
-(void)setIsSel:(BOOL)isSel{
    _isSel = isSel;
    if (isSel) {
//        _botlabel.textColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0];
        [_dottedLineBorder setStrokeColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor];
        
        
    }else{
//        _botlabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [_dottedLineBorder setStrokeColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    }
}
@end
