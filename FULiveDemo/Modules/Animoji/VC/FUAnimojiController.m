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
#import "FUAnimojiManager.h"
#import "FUAnimationFilterManager.h"

@interface FUAnimojiController ()<FUItemsViewDelegate>
@property (strong,nonatomic) NSString *selAnmoji;
@property (strong,nonatomic) NSString *selComic;
@property (strong, nonatomic) FUItemsView *itemsView;
/* 动漫滤镜分栏*/
@property (strong, nonatomic) FUSegmentBarView *segmentBarView;
@property (strong, nonatomic) NSArray *comicItemArray;

@property (strong, nonatomic) FUAnimojiManager *animojManager;

@property (strong, nonatomic) FUAnimationFilterManager *animationFilterManager;
@end

@implementation FUAnimojiController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animojManager = [[FUAnimojiManager alloc] init];
    self.animationFilterManager = [[FUAnimationFilterManager alloc] init];
    self.animojManager.animoji.flowEnable = YES;
    [self setupView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[FUManager shareManager] set3DFlipH];
    /*
    抗锯齿
    */
    [self.animojManager loadAntiAliasing];
}

-(void)setupView{
    /* 动漫data */
    _comicItemArray = @[@"resetItem",@"fuzzytoonfilter1",@"fuzzytoonfilter2",@"fuzzytoonfilter3",@"fuzzytoonfilter4",@"fuzzytoonfilter5",@"fuzzytoonfilter6",@"fuzzytoonfilter7",@"fuzzytoonfilter8"];
    
    /* anmoji View */
    _itemsView = [[FUItemsView alloc] init];
    _itemsView.delegate = self;
    [self.view addSubview:_itemsView];
//    _itemsView.backgroundColor = [UIColor colorWithRed:17/255.0 green:18/255.0 blue:38/255.0 alpha:0.95];
    [self.itemsView updateCollectionArray:self.model.items];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -90) ;
    
    /* 初始状态 */
    self.itemsView.selectedItem = @"resetItem" ;
    _selAnmoji = self.itemsView.selectedItem;
    
    __weak typeof(self)weakSelf  = self ;
    _segmentBarView = [[FUSegmentBarView alloc] initWithFrame:CGRectMake(0, 200,[UIScreen mainScreen].bounds.size.width, 49) titleArray:@[@"Animoji",FUNSLocalizedString(@"动漫滤镜",nil)] selBlock:^(int index) {
        if (index == 0) {
            weakSelf.itemsView.selectedItem = weakSelf.selAnmoji;
            [weakSelf.itemsView updateCollectionArray:weakSelf.model.items];
        }else{
            weakSelf.itemsView.selectedItem = weakSelf.selComic;
            [weakSelf.itemsView updateCollectionArray:weakSelf.comicItemArray];
        }
        NSLog(@"选中---%d",index);
    }];
    _segmentBarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_segmentBarView];
    
    [_segmentBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(49 + 34);
        }else{
            make.height.mas_equalTo(49);
        }
        
    }];
    
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_segmentBarView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(84);
    }];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 1.0;
    [self.view insertSubview:effectview atIndex:1];

    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        
        if (iPhoneXStyle) {
            make.height.mas_equalTo(84 + 49 + 34 + 1);
        }else{
            make.height.mas_equalTo(84 + 34 + 1);
        }
        
    }];
    
    
}

-(void)headButtonViewBackAction:(UIButton *)btn{
    [super headButtonViewBackAction:btn];
    [self.animojManager releaseItem];
    [self.animationFilterManager releaseItem];
}

#pragma mark - FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    [_itemsView startAnimation];
    __weak typeof(self) weak = self;
    if (self.segmentBarView.currentBtnIndex == 1){//动漫
        _selComic = item;
        NSArray *array = [_selComic componentsSeparatedByString:@"toonfilter"];
        int type = [array.lastObject intValue];
        [self.animationFilterManager loadItem:item type:[self comicStyleIndex:type] completion:^(BOOL flag) {
            [weak.itemsView stopAnimation];
        }];
    }else{//anmoji
        _selAnmoji = item;
        [self.animojManager loadItem:item completion:^(BOOL finished) {
            [weak.itemsView stopAnimation];
        }];
    }

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
