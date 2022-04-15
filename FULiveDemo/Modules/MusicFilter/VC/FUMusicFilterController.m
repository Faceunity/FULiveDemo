//
//  FUMusicFilterController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMusicFilterController.h"
#import "FUItemsView.h"
#import "FUMusicFilterManager.h"

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
    [self addObserver];
}

- (void)headButtonViewBackAction:(UIButton *)btn{
    [super headButtonViewBackAction:btn];
    [self.musicManager releaseItem];
}

-(void)setupView{
    self.itemsView = [[FUItemsView alloc] init];
    self.itemsView.delegate = self;
    [self.view addSubview:self.itemsView];
    [self.itemsView updateCollectionArray:self.model.items];
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
    NSString *selectItem = self.model.items.count > 0 ? self.model.items[1] : @"resetItem" ;
    self.itemsView.selectedItem = selectItem ;
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /* 返回当前界面的时候，重新加载 */
    if (!self.itemsView.selectedItem) {
        self.itemsView.selectedItem = self.musicManager.selectedItem ;
    }else {
        [self.musicManager loadItem:self.itemsView.selectedItem completion:nil];
    }
    [self.musicManager.musicItem play];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.musicManager.musicItem stop];
}

#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weak = self;
    [self.itemsView startAnimation];
    [self.musicManager loadItem:self.itemsView.selectedItem completion:^(BOOL finished) {
        [weak.itemsView stopAnimation];
    }];

    [self.musicManager.musicItem stop];
    if (![item isEqualToString:@"resetItem"]) {
        [self.musicManager.musicItem play];
    }
}

-(void)headButtonViewSegmentedChange:(UISegmentedControl *)sender{
    [super headButtonViewSegmentedChange:sender];
    [self.musicManager.musicItem play];
}

-(void)headButtonViewSwitchAction:(UIButton *)btn {
    [super headButtonViewSwitchAction:btn];
    [self.musicManager.musicItem play];
}

#pragma mark --- Observer

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive{
    if (self.navigationController.visibleViewController == self) {
        [self.musicManager.musicItem stop] ;
    }
}

- (void)didBecomeActive{
    
    if (self.navigationController.visibleViewController == self) {
        if (![self.musicManager.selectedItem isEqualToString:@"noitem"]) {
            [self.musicManager.musicItem play];
        }
    }
}
@end
