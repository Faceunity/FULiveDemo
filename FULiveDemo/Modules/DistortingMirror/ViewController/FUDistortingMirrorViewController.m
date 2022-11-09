//
//  FUDistortingMirrorViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUDistortingMirrorViewController.h"

@interface FUDistortingMirrorViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;

@property (nonatomic, strong, readonly) FUDistortingMirrorViewModel *viewModel;

@end

@implementation FUDistortingMirrorViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(FUHeightIncludeBottomSafeArea(84));
    }];
    
    self.itemsView.items = self.viewModel.distortingMirrorItems;
    self.itemsView.selectedIndex = 1;

    [self updateBottomConstraintsOfCaptureButton:FUHeightIncludeBottomSafeArea(84) + 10 animated:NO];
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
@end
