//
//  FUNormalItemController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUNormalItemController.h"
#import "FUSelectedImageController.h"
#import "FUStickerManager.h"
#import "FUItemsView.h"

@interface FUNormalItemController ()<FUItemsViewDelegate>

@property (strong, nonatomic) FUItemsView *itemsView;
@property (nonatomic, strong) FUStickerManager *stickerManager;

@end

@implementation FUNormalItemController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.stickerManager = [[FUStickerManager alloc] init];
    self.stickerManager.type = self.type;
    
    [self setupView];
    
    [self.headButtonView.selectedImageBtn setImage:[UIImage imageNamed:@"相册icon"] forState:UIControlStateNormal];
}

- (void)headButtonViewBackAction:(UIButton *)btn{
    [super headButtonViewBackAction:btn];
    [self.stickerManager releaseItem];
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

    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
    
    /* 贴纸界面打开图片选择 */
    if(self.model.type == FULiveModelTypeItems){
        self.headButtonView.selectedImageBtn.hidden = NO;
    }
}


-(void)viewWillAppear:(BOOL)animated {
    /* 返回当前界面的时候，重新加载 */
    if (!self.itemsView.selectedItem) {
            /* 初始状态 */
        NSString *selectItem = self.model.items.count > 0 ? self.model.items[1] : @"resetItem" ;
        self.itemsView.selectedItem = selectItem ;
        dispatch_async(self.stickerManager.loadQueue, ^{
            [self itemsViewDidSelectedItem:selectItem indexPath:nil];
        });
        
    }else {
        [self.stickerManager loadItem:self.stickerManager.selectedItem completion:nil];
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.stickerManager releaseItem];
}


#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weak = self;
    [self.itemsView startAnimation];
    [self.stickerManager loadItem:item
                       completion:^(BOOL finished) {
        [weak.itemsView stopAnimation];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [self.stickerManager getStickTipsWithItemName:item];
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
        if ([self.stickerManager.selectedItem isEqualToString:@"resetItem"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noTrackLabel.hidden = YES;
            });
        } else {
            int res  = fuHandDetectorGetResultNumHands();
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noTrackLabel.text = FUNSLocalizedString(@"未检测到手势",nil);
                self.noTrackLabel.hidden = res > 0 ? YES : NO;
            }) ;
        }

    } else {
        [super displayPromptText];
    }
}

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)dealloc {
    NSLog(@"normal dealloc");
}



@end
