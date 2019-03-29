//
//  FUGifEditView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/25.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUGifEditViewDelegate <NSObject>

@optional
-(void)ganGifDidClickAddImage;
-(void)ganGifDidClickRemoveImage;
-(void)ganGifDidSelOneImage;
-(void)ganGifDidPlay;
-(void)ganGifDidQuickenPlay;

@end

@interface FUGifEditView : UIView
@property (strong, nonatomic) UIImageView *selImageView;
@property (assign, nonatomic) int selIndex;
@property (assign,nonatomic) id<FUGifEditViewDelegate> delegate;
@property (nonatomic,strong,readonly) NSMutableArray *imageArr;//当前图片数
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *quickenBtn;

-(void)addGifImage:(UIImage *)image;

-(void)updataSelImage:(UIImage *)image;

-(void)setSelIndex:(int)selIndex;
@end

NS_ASSUME_NONNULL_END
