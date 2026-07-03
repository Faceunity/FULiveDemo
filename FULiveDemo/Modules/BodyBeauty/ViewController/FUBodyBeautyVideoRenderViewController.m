//
//  FUBodyBeautyVideoRenderViewController.m
//  FULiveDemo
//
//  Created by Cursor on 2026/6/30.
//

#import "FUBodyBeautyVideoRenderViewController.h"
#import "FUBodyBeautyComponentManager.h"

@implementation FUBodyBeautyVideoRenderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FUBodyBeautyComponentManager sharedManager] addComponentViewToView:self.view];
    [self updateBottomConstraintsOfDownloadButton:[FUBodyBeautyComponentManager sharedManager].componentViewHeight];
}

@end
