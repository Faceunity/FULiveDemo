//
//  FURenderModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/16.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface FURenderModel : NSObject<YYModel>

+ (NSArray *)modelArrayWithJSON:(id)json;

@end
    
NS_ASSUME_NONNULL_END
