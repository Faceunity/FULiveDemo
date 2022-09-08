//
//  FUDistortingMirrorViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUDistortingMirrorViewController.h"
#import "FUDistortingMirrorViewModel.h"
#import "FULocalDataManager.h"
#import <FUCommonUIComponent/FUItemsView.h>

@interface FUDistortingMirrorViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) FUDistortingMirrorViewModel *viewModel;

@end

@implementation FUDistortingMirrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(84 + 34);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
    
    self.itemsView.items = self.viewModel.distortingMirrorItems;
    self.itemsView.selectedIndex = 1;
    
    [self.viewModel loadItem:self.viewModel.distortingMirrorItems[1] completion:nil];

    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    NSString *item = self.viewModel.distortingMirrorItems[index];
    if (index == 0) {
        [self.viewModel releaseItem];
        [self.itemsView stopAnimation];
    } else {
        [self.viewModel loadItem:item completion:^{
            [self.itemsView stopAnimation];
        }];
    }
}

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[FUItemsView alloc] init];
        _itemsView.delegate = self;
    }
    return _itemsView;
}

- (FUDistortingMirrorViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUDistortingMirrorViewModel alloc] init];
    }
    return _viewModel;
}

@end
