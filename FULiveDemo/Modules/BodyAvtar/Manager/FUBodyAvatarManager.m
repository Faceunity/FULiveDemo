//
//  FUBodyAvatarManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBodyAvatarManager.h"
#import <FURenderKit/FURenderKit.h>

@interface FUBodyAvatarManager () {
    int _index;
    FUPosition halfPosition;
    FUPosition fullPosition;
}

@property (nonatomic, strong, nullable) FUScene *scene;
@property (nonatomic, strong) FUBackground *sceneBackground;
@property (nonatomic, copy) NSArray<FUAvatar *> *avatars;
@property (nonatomic, strong) FUAvatar *currentAvatar;

@end

@implementation FUBodyAvatarManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _index = -1;
        [self setupPosition];
        [self loadAntiAliasing];
        [self setupScene];
        [self setupAvatars];
        [self loadAvatarWithIndex:0];
        [self switchBodyTrackMode:FUBodyTrackModeFull];
        
        [FURenderKit shareRenderKit].scene = self.scene;

    }
    return self;
}

- (void)setupPosition{
    fullPosition = FUPositionMake(0.0, 53.14, -537.94);
    halfPosition = FUPositionMake(0.0, 0, -183.89);
    if (iPhoneXStyle) {
        fullPosition.z = -600;
        halfPosition.z = -200;
    }
}

- (void)setupScene {
    self.scene = [[FUScene alloc] init];
    self.scene.AIConfig.bodyTrackEnable = YES;
}

- (void)setupAvatars {
    
    // setup little bear
    FUAvatar *bearAvatar = [[FUAvatar alloc] init];
    NSString *bearPath = [[NSBundle mainBundle] pathForResource:@"xiong" ofType:@"bundle"];
    FUItem *bearItem = [FUItem itemWithPath:bearPath name:@"xiong"];
    [bearAvatar addComponent:bearItem];
    
    NSString *bearAnimationPath = [[NSBundle mainBundle] pathForResource:@"xiong_animation" ofType:@"bundle"];
    FUAnimation *bearAnimation = [FUAnimation animationWithPath:bearAnimationPath name:@"xiong_animation"];
    [bearAvatar addAnimation:bearAnimation];
    
    NSString *bearLightPath = [[NSBundle mainBundle] pathForResource:@"xiong_light" ofType:@"bundle"];
    FUAnimation *bearLight = [FUAnimation animationWithPath:bearLightPath name:@"xiong_light"];
    [bearAvatar addAnimation:bearLight];
    
    NSArray <NSString *>*gestureTrackComponents = @[@"anim_eight",@"anim_fist",@"anim_greet",@"anim_gun",@"anim_heart",@"anim_hold",@"anim_korheart",@"anim_merge",@"anim_ok",@"anim_one", @"anim_palm",@"anim_rock",@"anim_six",@"anim_thumb",@"anim_two"];
    
    // setup female
    FUAvatar *femaleAvatar = [[FUAvatar alloc] init];
    
    // components
    NSArray *femaleComponents = @[@"female_hair_23",@"headnv" ,@"midBody_female",@"taozhuang_12",@"toushi_5",@"xiezi_danxie"];
    for (NSString *component in femaleComponents) {
        NSString *path = [[NSBundle mainBundle] pathForResource:component ofType:@"bundle"];
        FUItem *item = [FUItem itemWithPath:path name:component];
        [femaleAvatar addComponent:item];
    }
    
    // gesture track components
    for (NSString *gestureTrackComponent in gestureTrackComponents) {
        NSString *path = [[NSBundle mainBundle] pathForResource:gestureTrackComponent ofType:@"bundle"];
        FUItem *item = [FUItem itemWithPath:path name:gestureTrackComponent];
        [femaleAvatar addComponent:item];
    }
    
    // avatar makeup
    NSString *path = [[NSBundle mainBundle] pathForResource:@"facemakeup_3" ofType:@"bundle"];
    FUAvatarMakeup *avatarMakeup = [FUAvatarMakeup itemWithPath:path name:@"facemakeup_3"];
    [femaleAvatar addComponent:avatarMakeup];
    
    // animation
    FUAnimation *femaleAnimation = [FUAnimation animationWithPath:[[NSBundle mainBundle] pathForResource:@"anim_idle" ofType:@"bundle"] name:@"anim_idle"];
    [femaleAvatar addAnimation:femaleAnimation];
    
    
    // setup male
    FUAvatar *maleAvatar = [[FUAvatar alloc] init];
    
    // components
    NSArray *maleComponents = @[@"headnan",@"kuzi_changku_5",@"male_hair_5",@"midBody_male",@"peishi_erding_2",@"toushi_7",@"waitao_3",@"xiezi_tuoxie_2"];
    for (NSString *component in maleComponents) {
        NSString *path = [[NSBundle mainBundle] pathForResource:component ofType:@"bundle"];
        FUItem *item = [FUItem itemWithPath:path name:component];
        [maleAvatar addComponent:item];
    }
    
    // gesture track components
    for (NSString *gestureTrackComponent in gestureTrackComponents) {
        NSString *path = [[NSBundle mainBundle] pathForResource:gestureTrackComponent ofType:@"bundle"];
        FUItem *item = [FUItem itemWithPath:path name:gestureTrackComponent];
        [maleAvatar addComponent:item];
    }
    
    // animation
    FUAnimation *maleAnimation = [FUAnimation animationWithPath:[[NSBundle mainBundle] pathForResource:@"anim_idle" ofType:@"bundle"] name:@"anim_idle"];
    [maleAvatar addAnimation:maleAnimation];
    
    maleAvatar.position = fullPosition;
    femaleAvatar.position = fullPosition;
    
    self.avatars = @[bearAvatar, femaleAvatar, maleAvatar];
    
}


- (int)aiHumanProcessorNums {
    int ret = [FUAIKit aiHumanProcessorNums];
    return ret;
}

- (FUAvatar *)currentAvatar {
    if (_index >= 0 && _index < self.avatars.count ) {
        return self.avatars[_index];
    }
    return nil;
}
FUAvatar *curA = nil;
- (void)loadAvatarWithIndex:(int)index {
    if (_index == index && index == -1) {
        return ; 
    }
    
    FUAvatar *newAvatar = self.avatars[index];
    newAvatar.visible = NO;
    if (self.currentAvatar) {
        self.currentAvatar.visible = NO;
        [self.scene replaceAvatar:self.currentAvatar withNewAvatar:newAvatar];
    }else{
        [self.scene addAvatar:newAvatar];
    }
    if (index == 0) {
        // 处理小熊Avatar
        // **这里临时处理了图形Y坐标到视图Y坐标的转换
        newAvatar.position = FUPositionMake(25.2, iPhoneXStyle ? (56.14 - 50.0*24.0/72.0) : 56.14, -537.94);
        self.scene.background = nil;
        self.scene.AIConfig.avatarTranslationScale = FUPositionMake(0.45, 0.45, 0.25);
        [self.scene.AIConfig setAvatarAnimFilter:7 pos:0.05 angle:0.1];
    } else {
        newAvatar.position = self.scene.AIConfig.bodyTrackMode == FUBodyTrackModeFull ? fullPosition:halfPosition;
        curA.position = FUPositionMake(25.2, 0, -537.94);
        self.scene.background = self.sceneBackground;
        self.scene.AIConfig.avatarTranslationScale = FUPositionMake(0, 0, 0);
        [self.scene.AIConfig setAvatarAnimFilter:5 pos:0 angle:0];
    }
    newAvatar.visible = YES;
    _index = index;
}

//切换模式: 半身还是全身
- (void)switchBodyTrackMode:(FUBodyTrackMode)mode {
    self.currentAvatar.position = mode == FUBodyTrackModeFull ? fullPosition:halfPosition;
    self.scene.AIConfig.bodyTrackMode = mode;
}

//加载抗锯齿道具
- (void)loadAntiAliasing {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa" ofType:@"bundle"];
    [FURenderKit shareRenderKit].antiAliasing = [[FUItem alloc] initWithPath:path name:@"antiAliasing"];
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FURenderKit shareRenderKit].antiAliasing = nil;
        [FURenderKit shareRenderKit].scene = nil;
        [self.scene unload];
    });
}

- (FUBackground *)sceneBackground {
    if (!_sceneBackground) {
        _sceneBackground = [[FUBackground alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"default_bg.bundle" ofType:nil] name:@"bg"];
    }
    return _sceneBackground;
}

@end
