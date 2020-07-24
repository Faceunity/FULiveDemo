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
    [[FUManager shareManager] loadMakeupBundleWithName:@"light_makeup"];
    [[FUManager shareManager] setMakeupItemIntensity:1 param:@"is_makeup_on"];
    [[FUManager shareManager] setMakeupItemIntensity:1 param:@"reverse_alpha"];
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
    for (FUSingleLightMakeupModel *modle in model.makeups) {
        [self setSelSubItem:modle];
    }
    /* 设置滤镜*/
    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBeauty];
    [FURenderer itemSetParam:handle withName:@"filter_name" value:[model.selectedFilter lowercaseString]];
    [FURenderer itemSetParam:handle withName:@"filter_level" value:@(model.selectedFilterLevel)]; //滤镜程度

}

-(void)lightMakeupModleValue:(FULightModel *)model{
    for (FUSingleLightMakeupModel *modle in model.makeups) {
            /* 子妆容程度值 这里程度值设置为 子程度值*滑杆值 */
        [[FUManager shareManager] setMakeupItemIntensity:modle.value *_mCollectionView.currentLightModel.value param:modle.namaValueStr];
    }
    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBeauty];
    [FURenderer itemSetParam:handle withName:@"filter_level" value:@(model.selectedFilterLevel)]; //滤镜程度
}

/* 子妆容相关参数 */
-(void)setSelSubItem:(FUSingleLightMakeupModel *)modle{
    if (modle.namaImgStr) {//贴妆容图片
        dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
            UIImage *mImage = [UIImage imageNamed:modle.namaImgStr];
            int imageWidth = (int)CGImageGetWidth(mImage.CGImage);
            int imageHeight = (int)CGImageGetHeight(mImage.CGImage);
            CFDataRef posterDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(mImage.CGImage));
            GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(posterDataFromImageDataProvider);
            
            int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeMakeup];
            
            fuCreateTexForItem(handle, (char *)[modle.namaTypeStr  UTF8String], imageData, imageWidth, imageHeight);
            free(imageData);
        });
        
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
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeMakeup];
}


@end
