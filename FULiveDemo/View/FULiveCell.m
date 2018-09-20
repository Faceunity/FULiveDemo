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
        
    }
    return self ;
}


-(void)setModel:(FULiveModel *)model {
    _model = model ;
    
    self.title.text = _model.title ;
    self.image.image = [UIImage imageNamed:_model.title];
    self.bottomImage.image = _model.enble ? [UIImage imageNamed:@"bottomImage"] : [UIImage imageNamed:@"bottomImage_gray"] ;
}

@end
