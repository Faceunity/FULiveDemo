//
//  AppDelegate.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/21.
//

#import "AppDelegate.h"

#import "FUNavigationController.h"
#import "FUHomepageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    FUHomepageViewController *homepageController = [[FUHomepageViewController alloc] init];
    FUNavigationController *navigationController = [[FUNavigationController alloc] initWithRootViewController:homepageController];
    self.window.rootViewController = navigationController;
    
    return YES;
}

/// 绿幕和人像分割特殊处理

- (void)applicationWillResignActive:(UIApplication *)application {
    if ([FURenderKit shareRenderKit].greenScreen.videoPath) {
        [[FURenderKit shareRenderKit].greenScreen stopVideoDecode];
    }
    if ([FURenderKit shareRenderKit].segmentation.videoPath) {
        [[FURenderKit shareRenderKit].segmentation stopVideoDecode];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([FURenderKit shareRenderKit].greenScreen.videoPath) {
        [[FURenderKit shareRenderKit].greenScreen startVideoDecode];
    }
    if ([FURenderKit shareRenderKit].segmentation.videoPath) {
        [[FURenderKit shareRenderKit].segmentation startVideoDecode];
    }
}

@end
