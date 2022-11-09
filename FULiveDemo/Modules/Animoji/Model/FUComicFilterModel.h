//
//  FUComicFilterModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/27.
//

#import <Foundation/Foundation.h>
#import <FURenderKit/FUComicFilter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUComicFilterModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) FUComicFilterStyle style;

@end

NS_ASSUME_NONNULL_END
