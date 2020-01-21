//
//  FUMusicFilterController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMusicFilterController.h"
#import "FUItemsView.h"
#import "FUMusicPlayer.h"
@interface FUMusicFilterController ()<FUItemsViewDelegate>
@property (strong, nonatomic) FUItemsView *itemsView;
@end

@implementation FUMusicFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self addObserver];
}

-(void)setupView{
    _itemsView = [[FUItemsView alloc] init];
    _itemsView.delegate = self;
    [self.view addSubview:_itemsView];
    [self.itemsView updateCollectionArray:self.model.items];
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(84);
    }];
    
    /* 初始状态 */
    NSString *selectItem = self.model.items.count > 0 ? self.model.items[0] : @"noitem" ;
    self.itemsView.selectedItem = selectItem ;
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /* 返回当前界面的时候，重新加载 */
    if (!self.itemsView.selectedItem) {
        self.itemsView.selectedItem = [FUManager shareManager].selectedItem ;
    }else {
        [[FUManager shareManager] loadItem:self.itemsView.selectedItem completion:nil];
    }
     [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];    
    [self.mCamera removeAudio];
    [[FUMusicPlayer sharePlayer] stop];
}

#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    [[FUManager shareManager] loadItem:item completion:nil];
    [[FUMusicPlayer sharePlayer] stop];
    if (![item isEqualToString:@"noitem"]) {
        [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
    }
    [self.itemsView stopAnimation];
}



-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    [super didOutputVideoSampleBuffer:sampleBuffer];
    [[FUManager shareManager] musicFilterSetMusicTime];
}


-(void)headButtonViewSegmentedChange:(UIButton *)btn{
    [super headButtonViewSwitchAction:btn];
    [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
}

-(void)headButtonViewSwitchAction:(UIButton *)btn{
    [super headButtonViewSwitchAction:btn];
    [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
}

#pragma mark --- Observer

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive{
    if (self.navigationController.visibleViewController == self) {
        [[FUMusicPlayer sharePlayer] stop] ;
    }
}

- (void)didBecomeActive{
    
    if (self.navigationController.visibleViewController == self) {
        if (![[FUManager shareManager].selectedItem isEqualToString:@"noitem"]) {
            [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"] ;
        }
    }
}

-(void)dealloc{
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeItem];
}

@end
