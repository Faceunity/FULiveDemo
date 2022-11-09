//
//  FUNavigationController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/22.
//

#import "FUNavigationController.h"

@interface FUNavigationController ()

@end

@implementation FUNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏NavigationBar
    self.navigationBarHidden = YES;
}

#pragma mark - Overriding

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
