//
//  FUAlertManager.h
//
//  Created by 项林平 on 2019/9/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUAlertManager : NSObject

/// Alert
/// @param titleString title
/// @param messageString message
/// @param cancelString 取消
/// @param confirmString 确定
/// @param viewController 控制器
/// @param confirm 确定闭包
/// @param cancel 取消闭包
+ (void)showAlertWithTitle:(nullable NSString *)titleString
                   message:(nullable NSString *)messageString
                    cancel:(nullable NSString *)cancelString
                   confirm:(nullable NSString *)confirmString
              inController:(nullable UIViewController *)viewController
            confirmHandler:(nullable void (^)(void))confirm
             cancelHandler:(nullable void (^)(void))cancel;

/// ActionSheet
/// @param titleString title
/// @param messageString message
/// @param cancelString 取消
/// @param viewController 控制器
/// @param sourceView 设备为iPad时需要传入
/// @param actions 选项
/// @param actionHandler 选项闭包
+ (void)showActionSheetWithTitle:(nullable NSString *)titleString
                         message:(nullable NSString *)messageString
                          cancel:(nullable NSString *)cancelString
                    inController:(nullable UIViewController *)viewController
                      sourceView:(nullable UIView *)sourceView
                         actions:(NSArray<NSString *> *)actions
                   actionHandler:(nullable void (^)(NSInteger index))actionHandler;

@end

NS_ASSUME_NONNULL_END
