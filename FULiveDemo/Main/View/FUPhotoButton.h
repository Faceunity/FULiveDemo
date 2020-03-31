//
//  PhotoButton.h
//  FULiveDemo
//
//  Created by liuyang on 2016/12/27.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, FUPhotoButtonType) {
    FUPhotoButtonTypeRecord = 1 << 0,
    FUPhotoButtonTypeTakePhoto = 1 << 1,

};

@protocol FUPhotoButtonDelegate <NSObject>

- (void)takePhoto;

- (void)startRecord;

- (void)stopRecord;

@end

@interface FUPhotoButton : UIButton

@property (nonatomic, weak) id<FUPhotoButtonDelegate> delegate;

@property (nonatomic, assign) FUPhotoButtonType type;

-(void)photoButtonFinishRecord;

@end
