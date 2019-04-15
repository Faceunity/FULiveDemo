//
//  FUYItuMeItemCell.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/19.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUYItuMeItemCell.h"
#import <Masonry.h>

@implementation FUYItuMeItemCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _itemImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.contentView addSubview:_itemImage];
        
        [_itemImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(5);
            make.right.bottom.equalTo(self.contentView).offset(-5);
        }];
    }
    
    return self;
}

@end
