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

- (id)initWithFrame:(CGRect)frame withData:(NSArray<FUAvatarModel *> *)dataArray;

@property (nonatomic, assign) id<FUAvatarEditViewDelegate>delegate;

@property (assign, nonatomic) BOOL isCustomState;

@property (strong, nonatomic,readonly) FUAvatarContentColletionView *avatarContentColletionView;

@property (strong, nonatomic) FUAvatarCustomView *avatarCustomView;

/* 单个完整扭脸模型 (包含脸，鼻子，眼，嘴，头发)*/
@property (nonatomic, strong) NSArray<FUAvatarModel *> *dataArray;

@end

NS_ASSUME_NONNULL_END
