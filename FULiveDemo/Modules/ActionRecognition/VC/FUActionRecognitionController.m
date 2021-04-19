//
//  FUActionRecognitionController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/6/2.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUActionRecognitionController.h"
#import "FUActionRecogManager.h"
@interface FUActionRecognitionController ()
@property (nonatomic, strong) FUActionRecogManager *actionRecogManager;
@end

@implementation FUActionRecognitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.actionRecogManager = [[FUActionRecogManager alloc] init];
    
    self.headButtonView.hidden = YES;
    
    self.photoBtn.hidden = YES;
    
    self.renderView.userInteractionEnabled = NO;
    
    if(iPhoneXStyle){
        self.actionRecogManager.actionRecogn.edgeDistance = 0.15;
    }
}


- (void)headButtonViewBackAction:(UIButton *)btn {
    [super headButtonViewBackAction:btn];
    [self.actionRecogManager releaseItem];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    bool iSclickBack = CGRectContainsPoint(CGRectMake(0, 0, 100, 100), point);
    if (iSclickBack) {
        [self.actionRecogManager releaseItem];
        [self.baseManager setOnCameraChange];
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
