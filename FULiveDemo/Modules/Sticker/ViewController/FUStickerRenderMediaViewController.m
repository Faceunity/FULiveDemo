//
//  FUStickerRenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUStickerRenderMediaViewController.h"
#import "FUStickerViewModel.h"
#import <FUCommonUIComponent/FUItemsView.h>


@interface FUStickerRenderMediaViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) FUStickerViewModel *viewModel;

@end

@implementation FUStickerRenderMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(118);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
    
    self.itemsView.items = self.viewModel.stickerItems;
    self.itemsView.selectedIndex = 1;
    
    [self itemsView:self.itemsView didSelectItemAtIndex:1];
    
    [self refreshDownloadButtonTransformWithHeight:38 show:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel releaseItem];
}

#pragma mark - FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    [self.viewModel loadItem:self.viewModel.stickerItems[index] completion:^{
        [self.itemsView stopAnimation];
    }];
}

#pragma mark - FURenderMediaProtocol

- (BOOL)isNeedTrack {
    return YES;
}

- (FUTrackType)trackType {
    return FUTrackTypeFace;
}

#pragma mark - Getters

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[FUItemsView alloc] init];
        _itemsView.delegate = self;
    }
    return _itemsView;
}

- (FUStickerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUStickerViewModel alloc] init];
    }
    return _viewModel;
}

@end
