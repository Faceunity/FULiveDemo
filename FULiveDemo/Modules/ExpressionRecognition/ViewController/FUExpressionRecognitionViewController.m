//
//  FUExpressionRecognitionViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUExpressionRecognitionViewController.h"
#import "FUExpressionRecognitionViewModel.h"
#import "FULocalDataManager.h"
#import <FUCommonUIComponent/FUItemsView.h>

@interface FUExpressionRecognitionViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) FUExpressionRecognitionViewModel *viewModel;

@end

@implementation FUExpressionRecognitionViewController

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
    
    self.itemsView.items = self.viewModel.expressionRecognitionItems;
    self.itemsView.selectedIndex = 1;
    
    [self.viewModel loadItem:self.viewModel.expressionRecognitionItems[1] completion:nil];

    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    NSString *item = self.viewModel.expressionRecognitionItems[index];
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
            [FUExpressionRecognitionViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
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

- (FUExpressionRecognitionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUExpressionRecognitionViewModel alloc] init];
    }
    return _viewModel;
}

@end
