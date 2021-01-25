//
//  FUNormalItemController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUNormalItemController.h"
#import "FUSelectedImageController.h"

@interface FUNormalItemController ()

@end

@implementation FUNormalItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
    [self.headButtonView.selectedImageBtn setImage:[UIImage imageNamed:@"相册icon"] forState:UIControlStateNormal];
}


/* 不需要进入分辨率选择 */
-(BOOL)onlyJumpImage{
    return YES;
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
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 1.0;
    [self.itemsView addSubview:effectview];
    [self.itemsView sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_itemsView);
    }];
    

    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
    
    /* 贴纸界面打开图片选择 */
    if(self.model.type == FULiveModelTypeItems){
        self.headButtonView.selectedImageBtn.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /* 返回当前界面的时候，重新加载 */
    if (!self.itemsView.selectedItem) {
            /* 初始状态 */
        NSString *selectItem = self.model.items.count > 0 ? self.model.items[0] : @"noitem" ;
        self.itemsView.selectedItem = selectItem ;
        [self itemsViewDidSelectedItem:selectItem];
    }else {
        [[FUManager shareManager] loadItem:self.itemsView.selectedItem completion:nil];
    }
}

#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    [[FUManager shareManager] loadItem:item completion:^(BOOL finished) {
        
        [self.itemsView stopAnimation];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [[FUManager shareManager] hintForItem:item];
        self.tipLabel.hidden = hint == nil;
        if (hint && hint.length != 0) {
            self.tipLabel.text = FUNSLocalizedString(hint, nil);
        }
        [FUNormalItemController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}


-(void)displayPromptText{
    if(self.model.type == FULiveModelTypeGestureRecognition){
        int res  = fuHandDetectorGetResultNumHands();
        dispatch_async(dispatch_get_main_queue(), ^{
                self.noTrackLabel.text = FUNSLocalizedString(@"未检测到手势",nil);
               self.noTrackLabel.hidden = res > 0 ? YES : NO;
        }) ;
        
    }else{
        [super displayPromptText];
    }
    
}

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)dealloc{
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeItem];
    
    NSLog(@"normalll dealloc");
}



@end
