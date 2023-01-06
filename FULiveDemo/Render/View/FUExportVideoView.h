//
//  FUExportVideoView.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUExportVideoViewDelegate <NSObject>

- (void)exportVideoViewDidClickCancel;

@end

@interface FUExportVideoView : UIView

@property (nonatomic, weak) id<FUExportVideoViewDelegate> delegate;

- (void)setExportProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
