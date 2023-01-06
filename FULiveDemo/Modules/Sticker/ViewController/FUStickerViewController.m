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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUStickerComponentManager sharedManager] addComponentViewToView:self.view];
}

#pragma mark - FUHeadButtonViewDelegate

- (void)headButtonViewBackAction:(UIButton *)btn {
    [FUStickerComponentManager destory];
    [super headButtonViewBackAction:btn];
}

@end
