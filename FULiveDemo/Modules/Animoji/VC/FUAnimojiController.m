//
//  FUAnimojiController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAnimojiController.h"
#import "FUAnimojiManager.h"
#import "FUAnimationFilterManager.h"

#import <FUCommonUIComponent/FUItemsView.h>

@interface FUAnimojiController ()<FUItemsViewDelegate, FUSegmentBarDelegate>
@property (strong,nonatomic) NSString *selAnmoji;
@property (strong,nonatomic) NSString *selComic;
@property (strong, nonatomic) FUItemsView *itemsView;
/* 动漫滤镜分栏*/
@property (strong, nonatomic) FUSegmentBar *segmentBarView;

@property (strong, nonatomic) FUAnimojiManager *animojManager;

@property (strong, nonatomic) FUAnimationFilterManager *animationFilterManager;

@property (nonatomic) NSInteger currentIndex;

@end

@implementation FUAnimojiController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animojManager = [[FUAnimojiManager alloc] init];
    self.animationFilterManager = [[FUAnimationFilterManager alloc] init];
    
    _currentIndex = 0;
    
    [self setupView];
    
}

-(void)setupView{
    self.segmentBarView = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, 200,[UIScreen mainScreen].bounds.size.width, 49) titles:@[@"Animoji",FUNSLocalizedString(@"动漫滤镜",nil)] configuration:[FUSegmentBarConfigurations new]];
    self.segmentBarView.delegate = self;
    [self.view addSubview:self.segmentBarView];
    
    [self.segmentBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(49 + 34);
        }else{
            make.height.mas_equalTo(49);
        }
        
    }];
    
    /* anmoji View */
    self.itemsView = [[FUItemsView alloc] init];
    self.itemsView.delegate = self;
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.segmentBarView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(84);
    }];
    
    self.itemsView.items = self.animojManager.animojiItems;
    /* 初始状态 */
    self.selAnmoji = @"resetItem";
    self.selComic = @"resetItem";
    
    self.segmentBarView.selectedIndex = _currentIndex;
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -90) ;
}

#pragma mark - FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self.itemsView startAnimation];
    if (self.currentIndex == 1){//动漫
        _selComic = itemsView.items[index];
        NSArray *array = [_selComic componentsSeparatedByString:@"toonfilter"];
        int type = [array.lastObject intValue];
        [self.animationFilterManager loadItem:_selComic type:[self comicStyleIndex:type] completion:^(BOOL flag) {
            [self.itemsView stopAnimation];
        }];
    }else{//anmoji
        _selAnmoji = itemsView.items[index];;
        [self.animojManager loadItem:_selAnmoji completion:^(BOOL finished) {
            [self.itemsView stopAnimation];
        }];
    }
}

#pragma mark - FUSegmentBarDelegate

- (void)segmentBar:(FUSegmentBar *)segmentsView didSelectItemAtIndex:(NSUInteger)index {
    if (index == 0) {
        self.itemsView.items = self.animojManager.animojiItems;
        self.itemsView.selectedIndex = [self.animojManager.animojiItems indexOfObject:self.selAnmoji];
    }else{
        self.itemsView.items = self.animationFilterManager.comicFilterItems;
        self.itemsView.selectedIndex = [self.animationFilterManager.comicFilterItems indexOfObject:self.selComic];
    }
    self.currentIndex = index;
    NSLog(@"选中---%lu",(unsigned long)index);
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
