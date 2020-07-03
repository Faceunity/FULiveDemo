//
//  FUBGSegmentationController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/6/25.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUBGSegmentationController.h"
#import "FUItemsView.h"
#import "FUSelectedImageController.h"
#import <CoreMotion/CoreMotion.h>

@interface FUBGSegmentationController ()<FUItemsViewDelegate>
@property (strong, nonatomic) FUItemsView *itemsView;

@end

@implementation FUBGSegmentationController

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
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /* 返回当前界面的时候，重新加载 */
    if (!self.itemsView.selectedItem) {
        self.itemsView.selectedItem = [FUManager shareManager].selectedItem;
    }else {
        [[FUManager shareManager] loadItem:self.itemsView.selectedItem completion:nil];
    }
    
}

//-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    [super didOutputVideoSampleBuffer:sampleBuffer];
//    double *rotation = [self get4ElementsFormDeviceMotion];
//    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
//    [FURenderer itemSetParamdv:handle  withName:@"motion_rotation" value:rotation length:4];
//}

#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item {
    [[FUManager shareManager] loadItem:item  completion:nil];
    [self.itemsView stopAnimation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [[FUManager shareManager] hintForItem:item];
        self.tipLabel.hidden = hint == nil;
        if (hint && hint.length != 0) {
            self.tipLabel.text = NSLocalizedString(hint, nil);
        }
        [FUBGSegmentationController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}

/* 切换前后置 */
-(void)headButtonViewSwitchAction:(UIButton *)btn{
    [super headButtonViewSwitchAction:btn];
    
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"camera_mode" value:btn.selected?1:0];
 }

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)displayPromptText{
    int res    = fuHumanProcessorGetNumResults();
    dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.text = NSLocalizedString(@"未检测到人体",nil);
           self.noTrackLabel.hidden = res > 0 ? YES : NO;
    }) ;
}


/* 获取方向四元素 */
//-(double *)get4ElementsFormDeviceMotion{
//    double *quaternion = (double *)malloc(4 * sizeof(double));
//    
//    quaternion[3] = self.motionManager.deviceMotion.attitude.quaternion.w;
//    quaternion[0] = self.motionManager.deviceMotion.attitude.quaternion.x;
//    quaternion[1] = self.motionManager.deviceMotion.attitude.quaternion.y;
//    quaternion[2] = self.motionManager.deviceMotion.attitude.quaternion.z;
//    return quaternion;
//}

-(void)dealloc{
    NSLog(@"dealloc--------");
        [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeItem];
}

@end
