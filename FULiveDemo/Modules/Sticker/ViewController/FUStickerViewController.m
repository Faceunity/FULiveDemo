//
//  FUStickerViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/15.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUStickerViewController.h"
#import "FUSelectedImageController.h"
#import "FUStickerViewModel.h"
#import <FUCommonUIComponent/FUItemsView.h>

@interface FUStickerViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) FUStickerViewModel *viewModel;

@end

@implementation FUStickerViewController

#pragma mark - Life cycle

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
    
    self.itemsView.items = self.viewModel.stickerItems;
    self.itemsView.selectedIndex = 1;

    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
    
    self.headButtonView.selectedImageBtn.hidden = NO;
    [self.headButtonView.selectedImageBtn setImage:[UIImage imageNamed:@"相册icon"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.itemsView.selectedIndex > 0) {
        [self.viewModel loadItem:self.itemsView.items[self.itemsView.selectedIndex] completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel releaseItem];
}

#pragma mark -  FUItemsViewDelegate

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

#pragma mark - Overriding

- (BOOL)needsPresetSelections {
    return NO;
}

- (void)didClickSelPhoto {
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    vc.type = FUModuleTypeSticker;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
