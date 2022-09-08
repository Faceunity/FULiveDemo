//
//  FUStickerCell.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/16.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStickerCell.h"

#import "FUStickerModel.h"

#import "FUStickerHelper.h"

#import <UIImageView+WebCache.h>

@implementation FUStickerCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectedTipView.layer.masksToBounds = YES;
    self.selectedTipView.layer.cornerRadius = 25.5;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 22;
}

-(void)setModel:(FUStickerModel *)model {
    _model = model ;
    
    NSLog(@"model.iconURLString: %@", model.iconURLString);
    
    if (!model.iconURLString) {
        // icon网络链接为空
        self.imageView.image = [UIImage imageNamed:@"sticker_placeholder"];
    } else {
        NSString *iconPath = [[FUStickerIconsPath stringByAppendingPathComponent:model.tag] stringByAppendingPathComponent:model.iconId];
        BOOL hasDownloadIcon = [[NSFileManager defaultManager] fileExistsAtPath:iconPath];
        if (hasDownloadIcon) {
            // 已经保存了icon，直接设置本地icon
            NSData *iconData = [NSData dataWithContentsOfFile:iconPath];
            self.imageView.image = [UIImage imageWithData:iconData];
        } else {
            // 未保存时需要设置网络图片
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconURLString] placeholderImage:[UIImage imageNamed:@"sticker_placeholder"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error || !image) {
                    return;
                }
                // 网络图片数据保存到本地
                NSString *iconDirectoryPath = [FUStickerIconsPath stringByAppendingPathComponent:model.tag];
                if (![[NSFileManager defaultManager] fileExistsAtPath:iconDirectoryPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:iconDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSData *imageData = UIImagePNGRepresentation(image);
                [imageData writeToFile:iconPath atomically:YES];
            }];
        }
    }
    
    if ([FUStickerHelper downloadStatusOfSticker:model]) {
        self.imageView.alpha = 1.0 ;
        self.downloadIcon.hidden = YES ;
        self.loadImage.hidden = YES ;
    } else {
        if (model.isLoading) {
            self.downloadIcon.hidden = YES;
            self.loadImage.hidden = NO ;
            self.imageView.alpha = 0.5 ;
            [self startLoadingAnimation];
        } else {
            self.imageView.alpha = 1.0 ;
            self.downloadIcon.hidden = NO;
            self.loadImage.hidden = YES ;
        }
    }
}

#pragma mark - Animation
- (void)startLoadingAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1 ;
    [self.loadImage.layer addAnimation:animation forKey:nil];
}

- (void)stopLoadingAnimation {
    [self.loadImage.layer removeAllAnimations];
}

#pragma mark - Setters
- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.selectedTipView.layer.borderWidth = 1.5;
        self.selectedTipView.layer.borderColor = [UIColor colorWithHexColorString:@"1FB2FF"].CGColor;
    } else {
        self.selectedTipView.layer.borderWidth = 0;
        self.selectedTipView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
