//
//  FUBeautyFilterModel.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyFilterModel : NSObject

@property (nonatomic, assign) NSInteger filterIndex;
@property (nonatomic, copy) NSString *filterName;
@property (nonatomic, assign) float filterLevel;

@end

NS_ASSUME_NONNULL_END
