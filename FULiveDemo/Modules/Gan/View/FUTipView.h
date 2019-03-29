//
//  FUTipView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/27.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FUTipViewDidClick)(int index);

@interface FUTipView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;

@property (copy, nonatomic) FUTipViewDidClick didClick;
@end

NS_ASSUME_NONNULL_END
