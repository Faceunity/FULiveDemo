//
//  FUActionRecognitionController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/6/2.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUActionRecognitionController.h"
#import "FUManager.h"

@interface FUActionRecognitionController ()

@end

@implementation FUActionRecognitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[FUManager shareManager] loadBundleWithName:@"actiongame_ai" aboutType:FUNamaHandleTypeItem];
   
    self.headButtonView.hidden = YES;
    
    self.photoBtn.hidden = YES;
    
    self.renderView.userInteractionEnabled = NO;
    
    if(iPhoneXStyle){
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"edge_distance" value:0.15];
    }
    
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    bool iSclickBack = CGRectContainsPoint(CGRectMake(0, 0, 100, 100), point);
    if (iSclickBack) {
//        [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeItem];
        [FURenderer onCameraChange];
        [[FUManager shareManager] destoryItems];
        [self.navigationController popViewControllerAnimated:YES];
    }
    return ;
}


-(void)displayPromptText{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackLabel.hidden = YES;
    }) ;
}


@end
