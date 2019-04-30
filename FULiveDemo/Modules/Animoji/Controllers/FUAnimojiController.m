//
//  FUAnimojiController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAnimojiController.h"
#import "FUSegmentBarView.h"
#import "FUItemsView.h"

@interface FUAnimojiController ()<FUItemsViewDelegate>
@property (strong,nonatomic) NSString *selAnmoji;
@property (strong,nonatomic) NSString *selComic;
@property (strong, nonatomic) FUItemsView *itemsView;
/* 动漫滤镜分栏*/
@property (strong, nonatomic) FUSegmentBarView *segmentBarView;
@property (strong, nonatomic) NSArray *comicItemArray;
@end

@implementation FUAnimojiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[FUManager shareManager] loadAnimojiFaxxBundle];
    [[FUManager shareManager] set3DFlipH];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[FUManager shareManager] destoryItemAboutType:FUMNamaHandleTypeFxaa];
}

-(void)setupView{
    /* 动漫data */
    _comicItemArray = @[@"fuzzytoonfilter1",@"fuzzytoonfilter2",@"fuzzytoonfilter3",@"fuzzytoonfilter4",@"fuzzytoonfilter5",@"fuzzytoonfilter6",@"fuzzytoonfilter7",@"fuzzytoonfilter8"];
    
    /* anmoji View */
    _itemsView = [[FUItemsView alloc] init];
    _itemsView.delegate = self;
    [self.view addSubview:_itemsView];
    [self.itemsView updateCollectionArray:self.model.items];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -90) ;
    
    /* 初始状态 */
    self.itemsView.selectedItem = @"noitem" ;
    _selAnmoji = self.itemsView.selectedItem;
    
   // _selComic = _comicItemArray[0];
   // [[FUManager shareManager] loadFilterAnimoji:@"fuzzytoonfilter" style:0];//默认开启动漫
    
    __weak typeof(self)weakSelf  = self ;
    _segmentBarView = [[FUSegmentBarView alloc] initWithFrame:CGRectMake(0, 200,[UIScreen mainScreen].bounds.size.width, 49) titleArray:@[@"Animoji",NSLocalizedString(@"动漫滤镜",nil)] selBlock:^(int index) {
        if (index == 0) {
            weakSelf.itemsView.selectedItem = weakSelf.selAnmoji;
            [weakSelf.itemsView updateCollectionArray:weakSelf.model.items];
        }else{
            weakSelf.itemsView.selectedItem = weakSelf.selComic;
            [weakSelf.itemsView updateCollectionArray:weakSelf.comicItemArray];
        }
        NSLog(@"选中---%d",index);
    }];
    [self.view addSubview:_segmentBarView];
    
    [_segmentBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_segmentBarView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(84);
    }];
}

#pragma mark - FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    if (self.segmentBarView.currentBtnIndex == 1){//动漫
        _selComic = item;
        NSArray *array = [_selComic componentsSeparatedByString:@"toonfilter"];
        int type = [array.lastObject intValue];
        [[FUManager shareManager] loadFilterAnimoji:_selComic style:[self comicStyleIndex:type]];
    }else{//anmoji
        _selAnmoji = item;
        [[FUManager shareManager] loadItem:item];
        NSArray *array = [_selComic componentsSeparatedByString:@"toonfilter"];
        int type = [array.lastObject intValue];
        [[FUManager shareManager] loadFilterAnimoji:_selComic style:[self comicStyleIndex:type]];
        
    }
    [_itemsView stopAnimation];
}



#pragma  mark -  动漫滤镜顺序
-(int)comicStyleIndex:(NSInteger)index{
    switch (index) {
        case 1:
            return 0;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            return (int)index - 1;
            break;
    }
    return 0;
}

@end
