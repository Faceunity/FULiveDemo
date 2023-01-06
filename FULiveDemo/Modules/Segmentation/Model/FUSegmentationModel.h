//
//  FUSegmentationModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FURenderModel.h"

typedef NS_ENUM(NSUInteger, FUSegmentationType) {
    FUSegmentationTypeDefault = 0,  // 默认本地加载
    FUSegmentationTypeImage,        // 自定义图片
    FUSegmentationTypeVideo         // 自定义视频
};

NS_ASSUME_NONNULL_BEGIN

@interface FUSegmentationModel : FURenderModel

@property (nonatomic, assign) FUSegmentationType type;

@property (nonatomic, copy, nullable) NSString *name;
/// 是否自定义
@property (nonatomic, assign) BOOL isCustom;
/// 自定义保存的图片或者视频预览图
@property (nonatomic, strong, nullable) UIImage *image;
/// 自定义视频保存的链接
@property (nonatomic, strong, nullable) NSURL *videoURL;

@end

NS_ASSUME_NONNULL_END
