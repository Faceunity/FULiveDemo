//
//  FUBodyBeautyController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/2.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUBodyBeautyController.h"
#import "FUBodyBeautyView.h"
#import "FUPositionInfo.h"
#import "MJExtension.h"
#import <CoreMotion/CoreMotion.h>
#import "FUSelectedImageController.h"
#import "FUBodyBeautyManager.h"

@interface FUBodyBeautyController ()<FUBodyBeautyViewDelegate>
@property(nonatomic,strong)FUBodyBeautyView *mBodyBeautyView;
@property (nonatomic, strong) FUBodyBeautyManager *bodyBeautyManager;
@end

@implementation FUBodyBeautyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bodyBeautyManager = [[FUBodyBeautyManager alloc] init];

    [self setupView];
 
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -100);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.bodyBeautyManager loadItem];
    [super viewWillAppear:animated];
}

-(void)setupView{
    NSArray *dataArray = self.bodyBeautyManager.dataArray;
    
    _mBodyBeautyView = [[FUBodyBeautyView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 134, [UIScreen mainScreen].bounds.size.width, 134) dataArray:dataArray];
    _mBodyBeautyView.delegate = self;
    [self.view addSubview:_mBodyBeautyView];
    
    [_mBodyBeautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(134 + 34);
        }else{
            make.height.mas_equalTo(134);
        }
        
    }];
    
    _mBodyBeautyView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_mBodyBeautyView insertSubview:effectview atIndex:0];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_mBodyBeautyView);
    }];

}

-(void)headButtonViewBackAction:(UIButton *)btn{
    [super headButtonViewBackAction:btn];
    [self.bodyBeautyManager releaseItem];
}


-(void)displayPromptText{
    BOOL result = [self.baseManager bodyTrace];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackLabel.text = FUNSLocalizedString(@"未检测到人体",nil);
        self.noTrackLabel.hidden = result;
    }) ;
}

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma  mark -  FUBodyBeautyViewDelegate
-(void)bodyBeautyViewDidSelectPosition:(FUPositionInfo *)position{
    if (!position.bundleKey) {
        return;
    }
    
    NSLog(@"------%@------%lf",position.bundleKey,position.value);
    [self.bodyBeautyManager setBodyBeautyModel:position];
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
