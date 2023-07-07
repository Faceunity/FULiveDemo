//
//  FUGreenScreenBackgroundModel.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenBackgroundModel : NSObject

/// 背景名称
@property (nonatomic, copy) NSString *name;
/// icon
@property (nonatomic, copy) NSString *icon;
/// 视频文件名
@property (nonatomic, copy) NSString *videoName;

@end

NS_ASSUME_NONNULL_END
