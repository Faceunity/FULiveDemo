//
//  FULightMakeupController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FULightMakeupController.h"
#import "FULightMakeupCollectionView.h"
#import "MJExtension.h"
#import "FUManager.h"

@interface FULightMakeupController ()<FULightMakeupCollectionViewDelegate>

/* 轻美妆选择 */
@property(nonatomic,strong)FULightMakeupCollectionView *mCollectionView;

@end

@implementation FULightMakeupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    /* 加载妆容道具 */
    [[FUManager shareManager] loadBundleWithName:@"light_makeup" aboutType:FUNamaHandleTypeMakeup];
}

-(void)setupView{
    /* 加载所有妆容数据 */
    NSString *lightMakeupPath=[[NSBundle mainBundle] pathForResource:@"lightMakeup" ofType:@"json"];
    NSData *lightMakeupData=[[NSData alloc] initWithContentsOfFile:lightMakeupPath];
    NSDictionary *lightMakeupDic=[NSJSONSerialization JSONObjectWithData:lightMakeupData options:NSJSONReadingMutableContainers error:nil];
    NSArray <FULightModel *>*dataArray = [FULightModel mj_objectArrayWithKeyValuesArray:lightMakeupDic[@"data"]];
    
    /* 初始w值为卸妆状态 */
    [self lightMakeupCollectionView:dataArray[0]];
    
    _mCollectionView = [[FULightMakeupCollectionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 134, [UIScreen mainScreen].bounds.size.width, 134) dataArray:dataArray delegate:self];
    [self.view addSubview:_mCollectionView];
    
    self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));

}


#pragma  mark -  FULightMakeupCollectionViewDelegate

-(void)lightMakeupCollectionView:(FULightModel *)model{
    /* 设置所有子妆容 */
    for (FUSingleLightMakeupModel *modle in model.makeups) {
        [self setSelSubItem:modle];
    }
    /* 设置滤镜*/
    [FUManager shareManager].selectedFilter = model.selectedFilter ;
    [FUManager shareManager].selectedFilterLevel = model.selectedFilterLevel;
}

-(void)lightMakeupModleValue:(FULightModel *)model{
    for (FUSingleLightMakeupModel *modle in model.makeups) {
            /* 子妆容程度值 这里程度值设置为 子程度值*滑杆值 */
        [[FUManager shareManager] setMakeupItemIntensity:modle.value *_mCollectionView.currentLightModel.value param:modle.namaValueStr];
    }
    [FUManager shareManager].selectedFilterLevel = model.selectedFilterLevel;
}

/* 子妆容相关参数 */
-(void)setSelSubItem:(FUSingleLightMakeupModel *)modle{
    if (modle.namaImgStr) {//贴妆容图片
         [[FUManager shareManager] setMakeupItemParamImageName:modle.namaImgStr param:modle.namaTypeStr];
    }
     /* 子妆容程度值 这里程度值设置为 子程度值*滑杆值 */
    [[FUManager shareManager] setMakeupItemIntensity:modle.value *_mCollectionView.currentLightModel.value param:modle.namaValueStr];
    
    if (modle.makeType == FUMakeupModelTypeLip) {
        [[FUManager shareManager] setMakeupItemIntensity:modle.lip_type param:@"lip_type"];
        [[FUManager shareManager] setMakeupItemIntensity:modle.is_two_color param:@"is_two_color"];
        [[FUManager shareManager] setMakeupItemStr:modle.colorStr valueArr:modle.colorStrV];
    }
}





-(void)dealloc{
    [[FUManager shareManager] destoryItems];
}


@end
