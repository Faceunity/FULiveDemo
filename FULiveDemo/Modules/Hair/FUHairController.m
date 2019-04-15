//
//  FUHairController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUHairController.h"
#import "FUHairView.h"

@interface FUHairController ()<FUHairViewDelegate>
@property (nonatomic, strong) FUHairView *hairView ;

@end

@implementation FUHairController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)setupView{
     _hairView = [[FUHairView alloc] init];
    _hairView.delegate = self;
    _hairView.itemsArray = self.model.items;
    [self.view addSubview:_hairView];
    [_hairView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(134);
    }];
    
    /* 初始状态 */
    [[FUManager shareManager] loadItem:@"hair_gradient"];
    [[FUManager shareManager] setHairColor:0];
    [[FUManager shareManager] setHairStrength:0.5];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -100) ;
}

#pragma mark - FUHairViewDelegate
-(void)hairViewDidSelectedhairIndex:(NSInteger)index{
    if (index == -1) {
        [[FUManager shareManager] setHairColor:0];
        [[FUManager shareManager] setHairStrength:0.0];
    }else{
        if(index < 5) {//渐变色
            [[FUManager shareManager] loadItem:@"hair_gradient"];
            [[FUManager shareManager] setHairColor:(int)index];
            [[FUManager shareManager] setHairStrength:self.hairView.slider.value];
        }else{
            [[FUManager shareManager] loadItem:@"hair_color"];
            [[FUManager shareManager] setHairColor:(int)index - 5];
            [[FUManager shareManager] setHairStrength:self.hairView.slider.value];
        }
    }
}

-(void)hairViewChanageStrength:(float)strength{
    [[FUManager shareManager] setHairStrength:strength];
}




@end
