//
//  FUHairView.h
//  FULiveDemo
//
//  Created by L on 2018/9/19.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUSlider.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUHairViewDelegate <NSObject>

@optional
- (void)hairViewDidSelectedhairIndex:(NSInteger)index;

-(void)hairViewChanageStrength:(float)strength;
@end

@interface FUHairView : UIView

@property (nonatomic, strong) NSArray *itemsArray ;

@property (nonatomic, assign) id<FUHairViewDelegate>delegate ;

@property (weak, nonatomic) IBOutlet FUSlider *slider;
@end


@interface FUHairCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end


NS_ASSUME_NONNULL_END
