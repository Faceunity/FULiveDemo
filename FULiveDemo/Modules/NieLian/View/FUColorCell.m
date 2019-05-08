//
//  FUColorCell.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUColorCell.h"

@interface FUColorCell()

@end

@implementation FUColorCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _image  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _image.image = [UIImage imageNamed:@"demo_icon_selected"];
        [self.contentView addSubview:_image];
        
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}


@end
