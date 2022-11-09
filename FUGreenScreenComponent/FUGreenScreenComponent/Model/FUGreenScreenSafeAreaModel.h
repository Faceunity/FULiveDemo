//
//  FUGreenScreenSafeAreaModel.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenSafeAreaModel : NSObject

/// 是否本地数据
@property (nonatomic, assign) BOOL isLocal;
/// icon名称
@property (nonatomic, copy) NSString *iconName;
/// 图片名称
@property (nonatomic, copy, nullable) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
