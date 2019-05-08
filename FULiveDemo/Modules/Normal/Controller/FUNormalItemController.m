//
//  FUNormalItemController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUNormalItemController.h"
#import "FUItemsView.h"
#import "FUSelectedImageController.h"

@interface FUNormalItemController ()<FUItemsViewDelegate>
@property (strong, nonatomic) FUItemsView *itemsView;
@end

@implementation FUNormalItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
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
    [self itemsViewDidSelectedItem:selectItem];
    
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
        self.itemsView.selectedItem = [FUManager shareManager].selectedItem ;
    }else {
        [[FUManager shareManager] loadItem:self.itemsView.selectedItem];
    }

}

#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    [[FUManager shareManager] loadItem:item];
    [self.itemsView stopAnimation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [[FUManager shareManager] hintForItem:item];
        self.tipLabel.hidden = hint == nil;
        if (hint && hint.length != 0) {
            self.tipLabel.text = NSLocalizedString(hint, nil);
        }
        [FUNormalItemController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:5];
    });
}

- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}


#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
