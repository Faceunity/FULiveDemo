//
//  FUHilariousViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHilariousViewController.h"

@interface FUHilariousViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;

@property (nonatomic, strong, readonly) FUHilariousViewModel *viewModel;

@end

@implementation FUHilariousViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel.maxFaceNumber = 1;
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(FUHeightIncludeBottomSafeArea(84));
    }];
    
    self.itemsView.items = self.viewModel.hilariousItems;
    self.itemsView.selectedIndex = 1;

    [self updateBottomConstraintsOfCaptureButton:FUHeightIncludeBottomSafeArea(84) + 10 animated:NO];
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
    if (self.viewModel.hilariousTips[item]) {
        NSString *hint = self.viewModel.hilariousTips[item];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.hidden = NO;
            self.tipLabel.text = FULocalizedString(hint);
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

@end
