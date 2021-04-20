//
//  FUFigureStylePaintingController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUFigureStylePaintingController.h"
#import "FUItemsView.h"
#import "FUSelectedImageController.h"
#import <CoreMotion/CoreMotion.h>
#import "FUStyleSelView.h"
#import "FUFigureStylePaintingManager.h"

@interface FUFigureStylePaintingController ()<FUItemsViewDelegate,FUSwipeSelViewDelegate>
@property (strong, nonatomic) FUItemsView *itemsView;

@property (strong, nonatomic) FUStyleSelView *mStyleSelView;

@property (strong, nonatomic) FUFigureStylePaintingManager *figureStyleManager;
@end

@implementation FUFigureStylePaintingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.figureStyleManager = [[FUFigureStylePaintingManager alloc] init];
    [self setupView];
    
    self.headButtonView.selectedImageBtn.hidden = YES;
    
}

-(void)setupView{
    _itemsView = [[FUItemsView alloc] init];
    _itemsView.delegate = self;
    [self.view addSubview:_itemsView];
    [self.itemsView updateCollectionArray:self.model.items];
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(84 + 34);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
    
    [self setupStyleSelView];
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 1.0;
    [self.itemsView addSubview:effectview];
    [self.itemsView sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_itemsView);
    }];
    
    
    /* 初始状态 */
    NSString *selectItem = self.model.items.count > 0 ? self.model.items[0] : @"noitem" ;
    self.itemsView.selectedItem = selectItem ;
    [self itemsViewDidSelectedItem:selectItem];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
    
}

-(void)setupStyleSelView{
    if (iPhoneXStyle) {
        _mStyleSelView = [[FUStyleSelView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15 - 60, self.view.frame.size.height - 250 - 182 - 10 - 34, 60, 250)];
    }else{
        _mStyleSelView = [[FUStyleSelView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15 - 60, self.view.frame.size.height - 250 - 182 - 10, 60, 250)];
    }
    _mStyleSelView.delegate = self;
    [_mStyleSelView setDataTitles:@[@"C",@"A",@"B"]];
//    _mStyleSelView.hidden = YES;
    [_mStyleSelView setSelCell:1];
    [self.view addSubview:_mStyleSelView];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /* 返回当前界面的时候，重新加载 */
    if (!self.itemsView.selectedItem) {
        NSString *selectItem = self.model.items.count > 0 ? self.model.items[0] : @"resetItem" ;
        self.itemsView.selectedItem = selectItem;
    }else {
        [self.figureStyleManager loadItem:self.figureStyleManager.selectedItem completion:nil];
    }
    
}

#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    __weak typeof(self) weak = self;
    [self.figureStyleManager loadItem:item
                       completion:^(BOOL finished) {
        [weak.itemsView stopAnimation];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [self.figureStyleManager getStickTipsWithItemName:item];
        self.tipLabel.hidden = hint == nil;
        if (hint && hint.length != 0) {
            self.tipLabel.text = FUNSLocalizedString(hint, nil);
        }
        [FUFigureStylePaintingController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}
#pragma mark -  StyleSelView
- (void)swipeSelViewDidSelIndex:(int)index{
    NSLog(@"1111");
}


- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}

/* 切换前后置 */
-(void)headButtonViewSwitchAction:(UIButton *)btn{
    [super headButtonViewSwitchAction:btn];
    [self.figureStyleManager changeCameraMode];
 }

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
