//
//  FUStickersPageController.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/16.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUStickerModel;
@class FUStickersPageController;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const FUSelectedStickerDidChangeNotification;

@protocol FUStickersPageControllerDelegate <NSObject>
/// 选中贴纸
- (void)stickerPageController:(FUStickersPageController *)controller didSelectSticker:(FUStickerModel *)sticker;
/// 加载贴纸效果
- (void)stickerPageController:(FUStickersPageController *)controller shouldLoadSticker:(FUStickerModel *)sticker;
@end

@interface FUStickersPageController : UIViewController

@property (nonatomic, weak) id<FUStickersPageControllerDelegate> delegate;

- (instancetype)initWithTag:(NSString *)tag;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
