//
//  FUHairManager.h
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUHairBeauty.h>
typedef NS_ENUM(NSUInteger, FUHairModel) {
    FUHairModelModelNormal,
    FUHairModelModelGradient
};
NS_ASSUME_NONNULL_BEGIN

@interface FUHairManager : FUMetaManager
@property (nonatomic, strong, nullable) FUHairBeauty *hair;

- (void)loadItemWithPath:(NSString *)path;
@property (nonatomic, assign) NSUInteger curMode;
@end

NS_ASSUME_NONNULL_END
