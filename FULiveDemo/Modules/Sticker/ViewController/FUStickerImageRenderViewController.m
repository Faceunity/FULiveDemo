//
//  FUStickerImageRenderViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/9.
//

#import "FUStickerImageRenderViewController.h"
#import "FUStickerComponentManager.h"

@interface FUStickerImageRenderViewController ()

@end

@implementation FUStickerImageRenderViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUStickerComponentManager sharedManager] addComponentViewToView:self.view];
}

@end
