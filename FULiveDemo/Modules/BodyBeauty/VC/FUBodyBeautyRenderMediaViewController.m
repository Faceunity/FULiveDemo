//
//  FUBodyBeautyRenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/12/28.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBodyBeautyRenderMediaViewController.h"
#import "FUBodyBeautyView.h"
#import "FUBodyBeautyManager.h"
#import "FUPositionInfo.h"

@interface FUBodyBeautyRenderMediaViewController ()<FUBodyBeautyViewDelegate>

@property (nonatomic, strong) FUBodyBeautyView *bodyBeautyView;

@property (nonatomic, strong) FUBodyBeautyManager *bodyBeautyManager;

@end

@implementation FUBodyBeautyRenderMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bodyBeautyView];
    
    [self refreshDownloadButtonTransformWithHeight:98 show:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.bodyBeautyManager releaseItem];
}

#pragma mark - FUBodyBeautyViewDelegate

- (void)bodyBeautyViewDidSelectPosition:(FUPositionInfo *)position {
    if (!position.bundleKey) {
        return;
    }
    [self.bodyBeautyManager setBodyBeautyModel:position];
}

#pragma mark - Getters

- (FUBodyBeautyView *)bodyBeautyView {
    if (!_bodyBeautyView) {
        NSString *bodyBeautyPath = [[NSBundle mainBundle] pathForResource:@"BodyBeautyDefault" ofType:@"json"];
        NSData *bodyData = [[NSData alloc] initWithContentsOfFile:bodyBeautyPath];
        NSDictionary *bodyDic = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArray = [FUPositionInfo mj_objectArrayWithKeyValuesArray:bodyDic];
        _bodyBeautyView = [[FUBodyBeautyView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 134, CGRectGetWidth(self.view.bounds), 134) dataArray:dataArray];
        _bodyBeautyView.delegate = self;
    }
    return _bodyBeautyView;
}

- (FUBodyBeautyManager *)bodyBeautyManager {
    if (!_bodyBeautyManager) {
        _bodyBeautyManager = [[FUBodyBeautyManager alloc] init];
    }
    return _bodyBeautyManager;
}

@end
