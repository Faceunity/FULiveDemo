//
//  FULiveCell.m
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FULiveCell.h"
#import "FULiveModel.h"

@implementation FULiveCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self ;
}


-(void)setModel:(FULiveModel *)model {
    _model = model ;
    
    self.title.text = _model.title ;
    self.title.textColor = _model.enble ? [UIColor colorWithRed:97.0/255.0 green:202.0/255.0 blue:244.0/255.0 alpha:1.0] : [UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1.0];
    self.image.image = [UIImage imageNamed:_model.imageName];
}

@end
