//
//  FUHilariousViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHilariousViewController.h"
#import "FUHilariousViewModel.h"
#import "FULocalDataManager.h"
#import <FUCommonUIComponent/FUItemsView.h>

@interface FUHilariousViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) FUHilariousViewModel *viewModel;

@end

@implementation FUHilariousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.baseManager setMaxFaces:1];
    
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
    
    self.itemsView.items = self.viewModel.hilariousItems;
    self.itemsView.selectedIndex = 1;
    
    [self.viewModel loadItem:self.viewModel.hilariousItems[1] completion:nil];

    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    NSString *item = self.viewModel.hilariousItems[index];
    if (index == 0) {
        [self.viewModel releaseItem];
        [self.itemsView stopAnimation];
    } else {
        [self.viewModel loadItem:item completion:^{
            [self.itemsView stopAnimation];
        }];
    }
    // 道具提示处理
    NSString *hint = [FULocalDataManager stickerTipsJsonData][item];
    if (hint && hint.length != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.hidden = NO;
            self.tipLabel.text = FUNSLocalizedString(hint, nil);
            [FUHilariousViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
            [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
        });
    }
}

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[FUItemsView alloc] init];
        _itemsView.delegate = self;
    }
    return _itemsView;
}

- (FUHilariousViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUHilariousViewModel alloc] init];
    }
    return _viewModel;
}

@end
