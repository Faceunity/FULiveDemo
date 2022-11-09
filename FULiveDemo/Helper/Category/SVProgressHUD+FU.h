//
//  SVProgressHUD+FU.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/23.
//

#import <SVProgressHUD/SVProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVProgressHUD (FU)

+ (void)showInfo:(NSString *)status;

+ (void)showError:(NSString *)status;

+ (void)showSuccess:(NSString *)status;

@end

NS_ASSUME_NONNULL_END
