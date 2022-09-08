//
//  FUMusicFilterController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMusicFilterController.h"
#import "FUMusicFilterManager.h"
#import <FUCommonUIComponent/FUItemsView.h>

@interface FUMusicFilterController ()<FUItemsViewDelegate>
@property (strong, nonatomic) FUItemsView *itemsView;
@property (strong, nonatomic) FUMusicFilterManager *musicManager;
@end

@implementation FUMusicFilterController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.musicManager = [[FUMusicFilterManager alloc] init];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)setupView{
    self.itemsView = [[FUItemsView alloc] init];
    self.itemsView.delegate = self;
    [self.view addSubview:self.itemsView];
    self.itemsView.items = self.musicManager.musicFilterItems;
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(84 + 34);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
    
    /* 初始状态 */
    NSInteger selectedIndex = self.musicManager.musicFilterItems.count > 0 ? 1 : 0;
    self.itemsView.selectedIndex = selectedIndex ;
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /* 返回当前界面的时候，重新加载 */
    if (self.itemsView.selectedIndex < 0) {
        self.itemsView.selectedIndex = [self.musicManager.musicFilterItems indexOfObject:self.musicManager.selectedItem];
    }else {
        [self.musicManager loadItem:self.itemsView.items[self.itemsView.selectedIndex] completion:nil];
    }
}

#pragma mark -  FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    NSString *item = itemsView.items[index];
    [self.musicManager loadItem:item completion:^(BOOL finished) {
        [self.itemsView stopAnimation];
    }];

    [self.musicManager.musicItem stop];
    if (index > 0) {
        [self.musicManager.musicItem play];
    } else {
        [self.musicManager releaseItem];
    }
}

-(void)headButtonViewSegmentedChange:(UISegmentedControl *)sender{
    [super headButtonViewSegmentedChange:sender];
    [self.musicManager.musicItem play];
}

-(void)headButtonViewSwitchAction:(UIButton *)btn {
    [super headButtonViewSwitchAction:btn];
    if (self.musicManager.musicItem) {
        [self.musicManager.musicItem play];
    }
}

- (void)headButtonViewBackAction:(UIButton *)btn {
    [super headButtonViewBackAction:btn];
    [self.musicManager releaseItem];
}

#pragma mark --- Observer

- (void)applicationWillResignActive{
    [self.musicManager.musicItem stop];
}

- (void)applicationDidBecomeActive {
    if (![self.musicManager.selectedItem isEqualToString:@"noitem"]) {
        [self.musicManager.musicItem play];
    }
}
@end
