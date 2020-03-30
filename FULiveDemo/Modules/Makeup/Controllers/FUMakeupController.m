//
//  FUMakeupController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/30.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMakeupController.h"
#import "FUMakeUpView.h"
#import "FUManager.h"
#import "FUMakeupSupModel.h"
#import "MJExtension.h"
#import "FUColourView.h"

@interface FUMakeupController ()<FUMakeUpViewDelegate,FUColourViewDelegate>
/* 化妆视图 */
@property (nonatomic, strong) FUMakeUpView *makeupView ;
/* 颜色选择视图 */
@property (nonatomic, strong) FUColourView *colourView;
/* 自定义调节需要保存，现有部位句柄，用户切换对道具销毁 */
@property (nonatomic,strong) NSMutableDictionary *oldHandleDic;

@end

@implementation FUMakeupController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[FUManager shareManager] loadMakeupType:@"new_face_tracker"];
    [[FUManager shareManager] loadMakeupBundleWithName:@"face_makeup"];
    [[FUManager shareManager] setMakeupItemIntensity:1 param:@"is_makeup_on"];
    
    [self setupView];
    [self setupColourView];
    
    /* 美妆道具 */
    [_makeupView setSelSupItem:1];
    
    self.canPushImageSelView = NO;
    
    
    NSDictionary* dic = @{@"tex_brow":@0,@"tex_eye":@0,@"tex_eye2":@0,@"tex_eye3":@0,@"tex_pupil":@0,@"tex_eyeLash":@0,@"tex_eyeLiner":@0,@"tex_blusher":@0,@"tex_foundation":@0,@"tex_highlight":@0,@"tex_shadow":@0};
    _oldHandleDic = [dic mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


-(void)setupColourView{
    if (iPhoneXStyle) {
        _colourView = [[FUColourView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15 - 60, self.view.frame.size.height - 250 - 182 - 10 - 34, 60, 250)];
    }else{
        _colourView = [[FUColourView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15 - 60, self.view.frame.size.height - 250 - 182 - 10, 60, 250)];
    }
    _colourView.delegate = self;
    _colourView.hidden = YES;
    [self.view addSubview:_colourView];
    
}

-(void)setupView{
    NSString *wholePath=[[NSBundle mainBundle] pathForResource:@"makeup_whole" ofType:@"json"];
    NSData *wholeData=[[NSData alloc] initWithContentsOfFile:wholePath];
    NSDictionary *wholeDic=[NSJSONSerialization JSONObjectWithData:wholeData options:NSJSONReadingMutableContainers error:nil];
    NSArray *supArray = [FUMakeupSupModel mj_objectArrayWithKeyValuesArray:wholeDic[@"data"]];

    _makeupView = [[FUMakeUpView alloc] init];
    _makeupView.delegate = self;
    [_makeupView setWholeArray:supArray];
    _makeupView.backgroundColor = [UIColor clearColor];
    _makeupView.topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _makeupView.bottomCollection.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:_makeupView];
    
    [_makeupView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(182);
    }];
    
    self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));
}


-(void)setOrientation:(int)orientation{
    [super setOrientation:orientation];
    fuSetDefaultRotationMode(orientation);
}

#pragma mark -  FUMakeUpViewDelegate

static int oldHandle = 0;
-(void)makeupViewDidSelectedSupModle:(FUMakeupSupModel *)model{
    /* bing && unbind */
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{//在美妆加载线程，确保道具加载
        /* 获取句柄 */
        int makeupHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeMakeup];
        /* 切换bundle,清空当前bind道具 */
        [FURenderer itemSetParam:makeupHandle withName:@"is_clear_makeup" value:@(1)];

        NSString *path = [[NSBundle mainBundle] pathForResource:model.makeupBundle ofType:@"bundle"];
        int subHandle = [FURenderer itemWithContentsOfFile:path];
        
        if (oldHandle) {//存在旧美妆道具，先销毁
             [FURenderer unBindItems:makeupHandle items:&oldHandle itemsCount:1];
             [FURenderer destroyItem:oldHandle];
             oldHandle = 0;
        }
        [FURenderer bindItems:makeupHandle items:&subHandle itemsCount:1];
         oldHandle = subHandle;
        
        /* 镜像设置 */
        [FURenderer itemSetParam:makeupHandle withName:@"is_flip_points" value:@(model.is_flip_points)];
        /* 切换bundle,不清空当前bind道具 */
        [FURenderer itemSetParam:makeupHandle withName:@"is_clear_makeup" value:@(0)];
        /* 设置妆容程度值 */
        [self makeupViewChangeValueSupModle:model];
    });
    
}

-(void)makeupViewChangeValueSupModle:(FUMakeupSupModel *)model{
    for (int i = 0; i < model.makeups.count; i ++) {
        [self makeupViewDidChangeValue:model.value * model.makeups[i].value namaValueStr:model.makeups[i].namaValueStr];
    }
    /* 修改美颜的滤镜 */
    
    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBeauty];
    if (!model.selectedFilter || [model.selectedFilter isEqualToString:@""]) {
        
        FUBeautyParam *param = [FUManager shareManager].seletedFliter;
        [FURenderer itemSetParam:handle withName:@"filter_name" value:[param.mParam lowercaseString]];
        [FURenderer itemSetParam:handle withName:@"filter_level" value:@(param.mValue)]; //滤镜程度
    }else{
        [FURenderer itemSetParam:handle withName:@"filter_name" value:[model.selectedFilter lowercaseString]];
        [FURenderer itemSetParam:handle withName:@"filter_level" value:@(model.value)]; //滤镜程度
    }

}


-(void)makeupCustomShow:(BOOL)isShow{
    if (isShow) {
        [UIView animateWithDuration:0.2 animations:^{
            self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -150), CGAffineTransformMakeScale(0.8, 0.8)) ;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));
        }];
    }
}

-(void)makeupViewDidSelectedNamaStr:(NSString *)namaStr valueArr:(NSArray *)valueArr{
    [[FUManager shareManager] setMakeupItemStr:namaStr valueArr:valueArr];
}

-(void)makeupViewDidSelectedNamaStr:(NSString *)namaStr bundleName:(NSString *)bundleName{
    if (!namaStr || !bundleName) {
        return;
    }
    
   dispatch_async([FUManager shareManager].asyncLoadQueue, ^{//在美妆加载线程，确保道具加载
  
    
    int makeupHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeMakeup];
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    int subHandle = [FURenderer itemWithContentsOfFile:path];
       NSLog(@"makeup-----subhandle(%d)",subHandle);
    int oldSubHandle = [[_oldHandleDic valueForKey:namaStr] intValue];
    if (oldSubHandle) {//存在旧美妆道具，先销毁
         [FURenderer unBindItems:makeupHandle items:&oldSubHandle itemsCount:1];
         [FURenderer destroyItem:oldSubHandle];
        [_oldHandleDic setValue:@(0) forKey:namaStr];;
    }
    [FURenderer bindItems:makeupHandle items:&subHandle itemsCount:1];
    [_oldHandleDic setValue:@(subHandle) forKey:namaStr];;
    
   });
}


-(void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr{
    
    [[FUManager shareManager] setMakeupItemIntensity:value param:namaStr];
}

-(void)makeupViewSelectiveColorArray:(NSArray<NSArray *> *)colors selColorIndex:(int)index{
    [_colourView setDataColors:colors];
    [_colourView setSelCell:index];
}

//-(void)makeupFilter:(NSString *)filterStr value:(float)filterValue{
//    if (!filterStr) {
//        return;
//    }
//    [FUManager shareManager].selectedFilter = filterStr ;
//    [FUManager shareManager].selectedFilterLevel = filterValue;
//}

-(void)makeupSelColorStata:(BOOL)stata{
    _colourView.hidden = stata ? NO :YES;
}


-(void)makeupViewDidSelTitle:(NSString *)nama{
    self.tipLabel.hidden = NO;
    self.tipLabel.text = NSLocalizedString(nama, nil);
    [FUMakeupController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
    [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1 ];
}

- (void)dismissTipLabel{
    self.tipLabel.hidden = YES;
}

#pragma  mark -  FUColourViewDelegate
-(void)colourViewDidSelIndex:(int)index{
    [_makeupView changeSubItemColorIndex:index];
}

/* 所有子妆修改 */
-(void)makeupAllValue:(float)value{
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_blusher"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_eyeBrow"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_eye"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_eyeLiner"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_eyelash"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_pupil"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_lip"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_foundation"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_highlight"];
    [[FUManager shareManager] setMakeupItemIntensity:value param:@"makeup_intensity_shadow"];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_makeupView.topHidden) {
        [_makeupView hiddenTopCollectionView:YES];
        _colourView.hidden = YES;
    }
}

-(void)dealloc{
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeMakeup];
    
//    [[FUManager shareManager] setDefaultFilter];

}

@end
