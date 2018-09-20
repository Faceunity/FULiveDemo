//
//  PhotoButton.h
//  FULiveDemo
//
//  Created by liuyang on 2016/12/27.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoButtonDelegate <NSObject>

- (void)takePhoto;

- (void)startRecord;

- (void)stopRecord;

@end

@interface PhotoButton : UIButton

@property (nonatomic, weak) id<PhotoButtonDelegate> delegate;

@end
