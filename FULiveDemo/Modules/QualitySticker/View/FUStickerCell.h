//
//  FUStickerCell.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/16.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUStickerModel;                                                                       

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *selectedTipView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *downloadIcon;
@property (weak, nonatomic) IBOutlet UIImageView *loadImage;

@property (nonatomic, strong) FUStickerModel *model ;

@end

NS_ASSUME_NONNULL_END
