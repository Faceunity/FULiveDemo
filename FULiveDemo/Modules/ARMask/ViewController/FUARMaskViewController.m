//
//  FUARMaskViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUARMaskViewController.h"
#import "FUARMaskViewModel.h"
#import <FUCommonUIComponent/FUItemsView.h>

@interface FUARMaskViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;

@property (nonatomic, strong, readonly) FUARMaskViewModel *viewModel;

@end

@implementation FUARMaskViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(FUHeightIncludeBottomSafeArea(84));
    }];
    
    self.itemsView.items = self.viewModel.maskItems;
    self.itemsView.selectedIndex = 1;
}

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    if (index == 0) {
        [self.viewModel releaseItem];
        [self.itemsView stopAnimation];
    } else {
        [self.viewModel loadItem:itemsView.items[index] completion:^{
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

@end
