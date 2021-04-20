//
//  FULiveCell.m
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FULiveCell.h"
#import "FULiveModel.h"
#import <Lottie/Lottie.h>

@interface FULiveCell()

@property (strong, nonatomic) UIImageView *bgImage;
@property (nonatomic, strong) LOTAnimationView *lotAnimationView;

@end

@implementation FULiveCell
-(void)setModel:(FULiveModel *)model {
    _model = model ;
    
    self.title.text = FUNSLocalizedString(_model.title, nil) ;
    self.image.image = [UIImage imageNamed:_model.title] ;
    self.bottomImage.image = _model.enble ? [UIImage imageNamed:@"bottomImage"] : [UIImage imageNamed:@"bottomImage_gray"];
    
    self.image.hidden = _model.animationIcon;
    self.animotionView.hidden = !_model.animationIcon;
    self.backgroundView.hidden = !_model.animationIcon;
    if(_model.animationIcon){
        UIImage *image =  [UIImage imageNamed:@"bg_card_small_elements"];
        self.bgImageView.image = image;
        self.lotAnimationView = [LOTAnimationView animationNamed:self.model.animationNamed];
        self.lotAnimationView.frame = CGRectMake(0, 10, 101, 122);
        self.lotAnimationView.loopAnimation = YES;
        [self.animotionView addSubview:self.lotAnimationView];
        [self.lotAnimationView play];
    } else {
        self.bgImageView.image = nil;
        [self.lotAnimationView removeFromSuperview];
    }
}

@end
