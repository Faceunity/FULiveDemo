//
//  FUHairBeautyViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/5.
//

#import "FUHairBeautyViewController.h"

#import "FUHairBeautyView.h"

@interface FUHairBeautyViewController ()<FUItemsViewDelegate, FUHairBeautyViewDelegate>

@property (nonatomic, strong) FUHairBeautyView *hairView;

@property (nonatomic, strong, readonly) FUHairBeautyViewModel *viewModel;

@end

@implementation FUHairBeautyViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.hairView];
    
    [self updateBottomConstraintsOfCaptureButton:CGRectGetHeight(self.hairView.frame) + 10 animated:NO];
}

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    if (index == self.viewModel.selectedIndex || index < 0 || index >= self.viewModel.hairItems.count) {
        return;
    }
    self.viewModel.selectedIndex = index;
    self.hairView.slider.hidden = index == 0;
    if (!self.hairView.slider.hidden) {
        self.hairView.slider.value = self.viewModel.strength;
    }
}

-(void)hairBeautyViewChangedStrength:(double)strength {
    self.viewModel.strength = strength;
}

- (FUHairBeautyView *)hairView {
    if (!_hairView) {
        _hairView = [[FUHairBeautyView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - FUHeightIncludeBottomSafeArea(134), CGRectGetWidth(self.view.bounds), FUHeightIncludeBottomSafeArea(134)) topSpacing:50];
        _hairView.delegate = self;
        _hairView.hairDelegate = self;
        _hairView.items = self.viewModel.icons;
        _hairView.selectedIndex = self.viewModel.selectedIndex;
        _hairView.slider.value = self.viewModel.strength;
    }
    return _hairView;
}

@end
