//
//  FUGestureRecognitionViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUGestureRecognitionViewController.h"
#import "FUGestureRecognitionViewModel.h"
#import "FULocalDataManager.h"
#import <FUCommonUIComponent/FUItemsView.h>

@interface FUGestureRecognitionViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) FUGestureRecognitionViewModel *viewModel;

@end

@implementation FUGestureRecognitionViewController

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
    
    self.itemsView.items = self.viewModel.gestureRecognitionItems;
    self.itemsView.selectedIndex = 1;
    
    [self itemsView:self.itemsView didSelectItemAtIndex:1];

    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    NSString *item = self.viewModel.gestureRecognitionItems[index];
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
            [FUGestureRecognitionViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
            [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
        });
    }
}

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}

#pragma mark - Getters

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[FUItemsView alloc] init];
        _itemsView.delegate = self;
    }
    return _itemsView;
}

- (FUGestureRecognitionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUGestureRecognitionViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - Overrriding

- (void)displayPromptText {
    if (![self.baseManager handTrace]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.text = FUNSLocalizedString(@"未检测到手势",nil);
            self.noTrackLabel.hidden = NO;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.hidden = YES;
        });
    }
}

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace | FUAIModelTypeHuman | FUAIModelTypeHand;
}

@end
