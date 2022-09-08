//
//  FULightMakeupController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FULightMakeupController.h"
#import "FULightMakeupCollectionView.h"
#import "FULightMakeupManager.h"

@interface FULightMakeupController ()<FULightMakeupCollectionViewDelegate>

/* 轻美妆选择 */
@property(nonatomic,strong)FULightMakeupCollectionView *mCollectionView;

@property (strong, nonatomic) FULightMakeupManager *lightMakeupManager;
@end

@implementation FULightMakeupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /* 加载妆容道具 */
    self.lightMakeupManager = [[FULightMakeupManager alloc] init];
    [self setupView];
}

-(void)setupView{
    /* 初始w值为卸妆状态 */
    if (self.lightMakeupManager.dataArray.count > 0) {
        [self lightMakeupCollectionView:self.lightMakeupManager.dataArray[0]];
    }
    _mCollectionView = [[FULightMakeupCollectionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 134, [UIScreen mainScreen].bounds.size.width, 134)
                                                                dataArray:self.lightMakeupManager.dataArray
                                                                 delegate:self];
    [self.view addSubview:_mCollectionView];
    
    [_mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(134 + 34);
        }else{
            make.height.mas_equalTo(134);
        }
        
    }];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 1.0;
    [_mCollectionView addSubview:effectview];
    [_mCollectionView sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_mCollectionView);
    }];

    self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));
}

#pragma  mark -  FULightMakeupCollectionViewDelegate
-(void)lightMakeupCollectionView:(FULightModel *)model{
    /* 设置所有子妆容 */
    [self.lightMakeupManager setAllSubLghtMakeupModelWithLightModel:model];
    self.baseManager.beauty.filterName = [model.selectedFilter lowercaseString];
    self.baseManager.beauty.filterLevel = model.selectedFilterLevel;
}

-(void)lightMakeupModleValue:(FULightModel *)model {
    for (FUSingleLightMakeupModel *subModel in model.makeups) {
            /* 子妆容程度值 这里程度值设置为 子程度值*滑杆值 */
        subModel.realValue = subModel.value * model.value;
        [self.lightMakeupManager setIntensityWithModel:subModel];
    }
//    self.baseManager.beauty.filterLevel = model.selectedFilterLevel;
    //根据滑动条的值修改-> 两端统一
    self.baseManager.beauty.filterLevel = model.value;
}
@end
