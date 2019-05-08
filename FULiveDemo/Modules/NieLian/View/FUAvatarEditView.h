//
//  FUAvatarEditView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUAvatarContentColletionView.h"
#import "FUAvatarCustomView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUAvatarEditViewDelegate <NSObject>

@optional
-(void)avatarEditViewDidCustom:(BOOL)isCustomStata;

@end

@interface FUAvatarEditView : UIView

@property (nonatomic, assign) id<FUAvatarEditViewDelegate>delegate;

@property (assign, nonatomic) BOOL isCustomState;

@property (strong, nonatomic,readonly) FUAvatarContentColletionView *avatarContentColletionView;


@end

NS_ASSUME_NONNULL_END
