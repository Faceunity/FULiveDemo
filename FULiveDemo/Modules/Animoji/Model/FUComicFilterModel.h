//
//  FUComicFilterModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/27.
//

#import "FURenderModel.h"
#import <FURenderKit/FUComicFilter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUComicFilterModel : FURenderModel

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) FUComicFilterStyle style;

@end

NS_ASSUME_NONNULL_END
