//
//  FUBGSaveModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/23.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FUBGSaveModelTypeImage,
    FUBGSaveModelTypeVideo,
} FUBGSaveModelType;

@interface FUBGSaveModel : NSObject<NSCoding>

/* 类别名称 */
@property (nonatomic, copy) NSString* pathName;

@property (nonatomic, assign) FUBGSaveModelType type;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIImage *iconImage;
@end

NS_ASSUME_NONNULL_END
