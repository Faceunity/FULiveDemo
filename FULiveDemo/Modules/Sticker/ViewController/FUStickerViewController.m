//
//  FUStickerViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/26.
//

#import "FUStickerViewController.h"
#import "FUStickerComponentManager.h"

@interface FUStickerViewController ()

@end

@implementation FUStickerViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateBottomConstraintsOfCaptureButton:FUHeightIncludeBottomSafeArea(84) + 10 animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUStickerComponentManager sharedManager] addComponentViewToView:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[FUStickerComponentManager sharedManager] removeComponentView];
}

- (void)dealloc {
    [FUStickerComponentManager destory];
}

@end
