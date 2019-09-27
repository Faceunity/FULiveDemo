//
//  FUPositionCell.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/2.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUPositionCell.h"

@implementation FUPositionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 44, 44)];
        [self.contentView addSubview:_topImage];
        
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, 50, 20)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor whiteColor];
        _botlabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_botlabel];
    }
    
    return self;
}
@end
