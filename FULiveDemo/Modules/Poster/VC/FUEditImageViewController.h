//
//  FUEditImageViewController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/9.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, FUEditImagePushFrom) {
    FUEditImagePushFromPhoto,
    FUEditImagePushFromAlbum,
};
@interface FUEditImageViewController : UIViewController
@property (assign, nonatomic) FUEditImagePushFrom PushFrom;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (strong, nonatomic) UIImage *mPhotoImage;
@end
