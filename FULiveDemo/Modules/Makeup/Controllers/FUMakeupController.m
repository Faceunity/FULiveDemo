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
@end

@implementation FUMakeupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FUManager shareManager] loadMakeupType:@"new_face_tracker"];
    [[FUManager shareManager] loadMakeupBundleWithName:@"face_makeup"];
    
    [self setupView];
    [self setupColourView];
    
    /* 美妆道具 */
    [_makeupView setSelSupItem:1];
    
    self.canPushImageSelView = NO;
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
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeMakeupType name:@"orientation" value:orientation];
}

#pragma mark -  FUMakeUpViewDelegate

static int oldHandle = 0;
-(void)makeupViewDidSelectedSupModle:(FUMakeupSupModel *)model{
    /* bing && unbind */
    dispatch_async([FUManager shareManager].makeupQueue, ^{//在美妆加载线程，确保道具加载
        /* 子妆容重设 0 */
//        [self makeupAllValue:0];
        
        int makeupHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeMakeup];
        NSString *path = [[NSBundle mainBundle] pathForResource:model.makeupBundle ofType:@"bundle"];
        int subHandle = [FURenderer itemWithContentsOfFile:path];
        
        if (oldHandle) {//存在旧美妆道具，先销毁
             [FURenderer unBindItems:makeupHandle items:&oldHandle itemsCount:1];
             [FURenderer destroyItem:oldHandle];
             oldHandle = 0;
        }
        [FURenderer bindItems:makeupHandle items:&subHandle itemsCount:1];
        oldHandle = subHandle;
    });
    
    /* 修改值 */
    [self makeupAllValue:0];
    [self makeupViewChangeValueSupModle:model];

}

-(void)makeupViewChangeValueSupModle:(FUMakeupSupModel *)model{
    for (int i = 0; i < model.makeups.count; i ++) {
        [self makeupViewDidChangeValue:model.value * model.makeups[i].value namaValueStr:model.makeups[i].namaValueStr];
    }
    /* 修改美颜的滤镜 */
    if (!model.selectedFilter || [model.selectedFilter isEqualToString:@""]) {
        [FUManager shareManager].selectedFilter = @"origin";
    }else{
        [FUManager shareManager].selectedFilter = model.selectedFilter;
        [FUManager shareManager].selectedFilterLevel = model.selectedFilterLevel;
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

-(void)makeupViewDidSelectedNamaStr:(NSString *)namaStr imageName:(NSString *)imageName{
    if (!namaStr || !imageName) {
        return;
    }
    [[FUManager shareManager] setMakeupItemParamImageName:imageName  param:namaStr];
}


-(void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr{
    
    [[FUManager shareManager] setMakeupItemIntensity:value param:namaStr];
}

-(void)makeupViewSelectiveColorArray:(NSArray<NSArray *> *)colors selColorIndex:(int)index{
    [_colourView setDataColors:colors];
    [_colourView setSelCell:index];
}

-(void)makeupFilter:(NSString *)filterStr value:(float)filterValue{
    if (!filterStr) {
        return;
    }
    [FUManager shareManager].selectedFilter = filterStr ;
    [FUManager shareManager].selectedFilterLevel = filterValue;
}

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
//    [[FUManager shareManager] setDefaultFilter];

}

@end
