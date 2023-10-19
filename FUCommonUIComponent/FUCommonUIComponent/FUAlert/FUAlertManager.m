//
//  FUAlertManager.m
//
//  Created by 项林平 on 2019/9/25.
//

#import "FUAlertManager.h"
#import "FUAlertController.h"

@implementation FUAlertManager

+ (void)showAlertWithTitle:(NSString *)titleString
                   message:(NSString *)messageString
                    cancel:(NSString *)cancelString
                   confirm:(NSString *)confirmString
              inController:(UIViewController *)viewController
            confirmHandler:(void (^)(void))confirm
             cancelHandler:(void (^)(void))cancel {
    if (!cancelString && !confirmString) {
        return;
    }
    FUAlertModel *alertModel = [[FUAlertModel alloc] initWithTitle:titleString message:messageString style:UIAlertControllerStyleAlert];
    __block UIViewController *currentViewController = viewController;
    [FUAlertController makeAlert:^(FUAlertController * _Nonnull controller) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        if (cancelString) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (cancel) {
                    cancel();
                }
            }];
            //设置Action文字颜色
            [cancelAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];
            [items addObject:cancelAction];
        }
        
        if (confirmString) {
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmString style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (confirm) {
                    confirm();
                }
            }];
            [confirmAction setValue:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] forKey:@"titleTextColor"];
            [items addObject:confirmAction];
        }
        if (!currentViewController) {
            currentViewController = [self topViewController];
        }
        if (!currentViewController) {
            NSLog(@"FUAlert: viewController can not be nil!");
            return;
        }
        controller.actionItems(items).showAlert(currentViewController);
    } alertModel:alertModel];
}
+ (void)showActionSheetWithTitle:(NSString *)titleString
                         message:(NSString *)messageString
                          cancel:(NSString *)cancelString
                    inController:(UIViewController *)viewController
                      sourceView:(UIView *)sourceView
                         actions:(NSArray<NSString *> *)actions
                   actionHandler:(void (^)(NSInteger))actionHandler {
    if (actions.count == 0) {
        return;
    }
    FUAlertModel *alertModel = [[FUAlertModel alloc] initWithTitle:titleString message:messageString style:UIAlertControllerStyleActionSheet];
    __block UIViewController *currentViewController = viewController;
    [FUAlertController makeAlert:^(FUAlertController * _Nonnull controller) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        if (cancelString) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [items addObject:cancelAction];
        }
        [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (actionHandler) {
                    actionHandler(idx);
                }
            }];
            [items addObject:alertAction];
        }];
        if (!currentViewController) {
            currentViewController = [self topViewController];
        }
        if (!currentViewController) {
            NSLog(@"FUAlert: viewController can not be nil!");
            return;
        }
        controller.actionItems(items).sourceView(sourceView).showAlert(currentViewController);
    } alertModel:alertModel];
}

+ (UIViewController *)topViewController {
    UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!root) {
        root = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    }
    return [self currentViewControllerWithRootViewController:root];
}

+ (UIViewController *)currentViewControllerWithRootViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self currentViewControllerWithRootViewController:viewController.presentedViewController];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *)viewController;
        return [self currentViewControllerWithRootViewController:navigation.visibleViewController];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBar = (UITabBarController *)viewController;
        return [self currentViewControllerWithRootViewController:tabBar.selectedViewController];
    } else {
        return viewController;
    }
}


@end
