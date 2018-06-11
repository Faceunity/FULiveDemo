//
//  FULiveCell.h
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FULiveModel ;
@interface FULiveCell : UICollectionViewCell

@property (nonatomic, strong) FULiveModel *model ;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@end
