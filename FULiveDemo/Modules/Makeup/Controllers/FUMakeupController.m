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

@interface FUMakeupController ()<FUMakeUpViewDelegate>
@property (nonatomic, strong) FUMakeUpView *makeupView ;
@end

@implementation FUMakeupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)setupView{
    
    NSString *wholePath=[[NSBundle mainBundle] pathForResource:@"makeup_whole" ofType:@"json"];
    NSData *wholeData=[[NSData alloc] initWithContentsOfFile:wholePath];
    NSDictionary *wholeDic=[NSJSONSerialization JSONObjectWithData:wholeData options:NSJSONReadingMutableContainers error:nil];
    NSArray *supArray = [FUMakeupSupModel mj_objectArrayWithKeyValuesArray:wholeDic[@"data2"]];

    _makeupView = [[FUMakeUpView alloc] init];
    _makeupView.delegate = self;
    [_makeupView setSupToSingelArr:@[@[@0,@0,@0,@0,@0,@0,@0],
                                     @[@1,@1,@1,@1,@0,@0,@0],
                                     @[@2,@2,@2,@2,@0,@0,@0],
                                     @[@3,@3,@3,@3,@0,@0,@0]]];
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



#pragma mark -  FUMakeUpViewDelegate
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

- (void)makeupViewDidSelectedItemName:(NSString *)itemName namaStr:(NSString *)namaStr isLip:(BOOL)isLip{
    if (isLip) {
        NSArray *rgba = [self jsonToLipRgbaArrayResName:itemName];
        double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
        [[FUManager shareManager] setMakeupItemLipstick:lip];
    }else{
        UIImage *namaImage = [UIImage imageNamed:itemName];
        if (!namaImage) {
            return;
        }
        [[FUManager shareManager] setMakeupItemParamImage:[UIImage imageNamed:itemName]  param:namaStr];
    }
}

-(void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr{
    [[FUManager shareManager] setMakeupItemIntensity:value param:namaStr];
}

-(void)makeupFilter:(NSString *)filterStr value:(float)filterValue{
    [FUManager shareManager].selectedFilter = filterStr ;
    [FUManager shareManager].selectedFilterLevel = filterValue;
}

#pragma  mark -  工具方法
-(NSArray *)jsonToLipRgbaArrayResName:(NSString *)resName{
    NSString *path=[[NSBundle mainBundle] pathForResource:resName ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    //解析成字典
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *rgba = [dic objectForKey:@"rgba"];
    
    if (rgba.count != 4) {
        NSLog(@"颜色json不合法");
    }
    return rgba;
}


@end
