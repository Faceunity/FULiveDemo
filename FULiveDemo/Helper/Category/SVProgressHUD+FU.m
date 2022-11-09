//
//  SVProgressHUD+FU.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/23.
//

#import "SVProgressHUD+FU.h"

@implementation SVProgressHUD (FU)

+ (void)showInfo:(NSString *)status {
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showError:(NSString *)status {
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)showSuccess:(NSString *)status {
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD showSuccessWithStatus:status];
}

@end
