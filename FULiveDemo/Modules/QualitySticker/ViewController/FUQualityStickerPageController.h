//
//  FUQualityStickerPageController.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/16.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUQualityStickerModel, FUQualityStickerPageController, FUQualityStickerViewModel;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const FUSelectedStickerDidChangeNotification;

@protocol FUQualityStickerPageControllerDelegate <NSObject>

/// 即将选中贴纸（未下载的贴纸需要先下载再选中）
- (void)stickerPageController:(FUQualityStickerPageController *)controller willSelectSticker:(FUQualityStickerModel *)sticker;
/// 选中贴纸
- (void)stickerPageController:(FUQualityStickerPageController *)controller didSelectSticker:(FUQualityStickerModel *)sticker;
/// 贴纸下载完成
- (void)stickerPageController:(FUQualityStickerPageController *)controller didDownloadSticker:(FUQualityStickerModel *)sticker;

@end

@interface FUQualityStickerPageController : UIViewController

@property (nonatomic, weak) id<FUQualityStickerPageControllerDelegate> delegate;

@property (nonatomic, strong) FUQualityStickerViewModel *qualityStickerViewModel;

- (instancetype)initWithTag:(NSString *)tag;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
