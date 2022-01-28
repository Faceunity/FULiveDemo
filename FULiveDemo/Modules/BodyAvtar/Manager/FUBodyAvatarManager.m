//
//  FUBodyAvatarManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBodyAvatarManager.h"

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
        
        // 初始化FUScene背景
        self.sceneBackground = [[FUBackground alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"default_bg.bundle" ofType:nil] name:@"bg"];
        // 初始化FUScene
        self.scene = [[FUScene alloc] init];
        self.scene.AIConfig.bodyTrackEnable = YES;
        self.scene.AIConfig.avatarTranslationScale = FUPositionMake(0, 0, 0);
        [self.scene.AIConfig setAvatarAnimFilter:5 pos:0 angle:0];
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

- (void)loadAvatarWithIndex:(int)index {
    if (_index == index && index == -1) {
        return ; 
    }
    if (![FURenderKit shareRenderKit].currentScene) {
        // 先添加scene到FURenderKit
        [[FURenderKit shareRenderKit] addScene:self.scene completion:^(BOOL success) {
            // 再设置currentScene
            [FURenderKit shareRenderKit].currentScene = self.scene;
            self.scene.background = self.sceneBackground;
            [self loadAvatar:self.avatars[index]];
            _index = index;
        }];
    } else {
        [self loadAvatar:self.avatars[index]];
        _index = index;
    }
}

- (void)loadAvatar:(FUAvatar *)avatar {
    if (self.currentAvatar) {
        self.currentAvatar.visible = NO;
        [self.scene replaceAvatar:self.currentAvatar withNewAvatar:avatar];
    } else {
        [self.scene addAvatar:avatar];
    }
    avatar.position = self.scene.AIConfig.bodyTrackMode == FUBodyTrackModeFull ? fullPosition:halfPosition;
    [avatar setEnableHumanAnimDriver:YES];
    avatar.visible = YES;
    self.currentAvatar = avatar;
}

/// 切换模式: 半身还是全身
- (void)switchBodyTrackMode:(FUBodyTrackMode)mode {
    self.currentAvatar.position = mode == FUBodyTrackModeFull ? fullPosition:halfPosition;
    self.scene.AIConfig.bodyTrackMode = mode;
}

/// 加载抗锯齿道具
- (void)loadAntiAliasing {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa" ofType:@"bundle"];
    [FURenderKit shareRenderKit].antiAliasing = [[FUItem alloc] initWithPath:path name:@"antiAliasing"];
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FURenderKit shareRenderKit].antiAliasing = nil;
        if (self.currentAvatar) {
            [self.scene removeAvatar:self.currentAvatar];
            self.currentAvatar = nil;
        }
        [[FURenderKit shareRenderKit] removeScene:self.scene completion:^(BOOL success) {
            [FURenderKit shareRenderKit].currentScene = nil;
        }];
    });
}

- (NSArray<FUAvatar *> *)avatars {
    if (!_avatars) {
        //    NSArray <NSString *>*gestureTrackComponents = @[@"anim_eight",@"anim_fist",@"anim_greet",@"anim_gun",@"anim_heart",@"anim_hold",@"anim_korheart",@"anim_merge",@"anim_ok",@"anim_one", @"anim_palm",@"anim_rock",@"anim_six",@"anim_thumb",@"anim_two"];
        
        // setup female
        FUAvatar *femaleAvatar = [[FUAvatar alloc] init];
        
        // components
        NSArray *femaleComponents = @[@"female_hair_23",@"headnv" ,@"midBody_female",@"taozhuang_12",@"toushi_5",@"xiezi_danxie"];
        for (NSString *component in femaleComponents) {
            NSString *path = [[NSBundle mainBundle] pathForResource:component ofType:@"bundle"];
            FUItem *item = [FUItem itemWithPath:path name:component];
            if ([component isEqualToString:@"midBody_female"]) {
                item.bodyInvisibleList = [NSSet setWithObjects:@2, @3, @4, nil];
            }
            [femaleAvatar addComponent:item];
        }
        
        // gesture track components
        //    for (NSString *gestureTrackComponent in gestureTrackComponents) {
        //        NSString *path = [[NSBundle mainBundle] pathForResource:gestureTrackComponent ofType:@"bundle"];
        //        FUItem *item = [FUItem itemWithPath:path name:gestureTrackComponent];
        //        [femaleAvatar addComponent:item];
        //    }
            
        // avatar makeup
        NSString *path = [[NSBundle mainBundle] pathForResource:@"facemakeup_3" ofType:@"bundle"];
        FUAvatarMakeup *avatarMakeup = [FUAvatarMakeup itemWithPath:path name:@"facemakeup_3"];
        [femaleAvatar addComponent:avatarMakeup];
        
        // animation
        FUAnimation *femaleAnimation = [FUAnimation animationWithPath:[[NSBundle mainBundle] pathForResource:@"anim_idle" ofType:@"bundle"] name:@"anim_idle"];
        [femaleAvatar addAnimation:femaleAnimation];
        
        [femaleAvatar setColor:FURGBColorMake(255, 202, 186) forKey:@"skin_color"];
        
        
        // setup male
        FUAvatar *maleAvatar = [[FUAvatar alloc] init];
        
        // components
        NSArray *maleComponents = @[@"headnan",@"kuzi_changku_5",@"male_hair_5",@"midBody_male",@"peishi_erding_2",@"toushi_7",@"waitao_3",@"xiezi_tuoxie_2"];
        for (NSString *component in maleComponents) {
            NSString *path = [[NSBundle mainBundle] pathForResource:component ofType:@"bundle"];
            FUItem *item = [FUItem itemWithPath:path name:component];
            if ([component isEqualToString:@"midBody_male"]) {
                item.bodyInvisibleList = [NSSet setWithObjects:@2, @3, @4, nil];
            }
            [maleAvatar addComponent:item];
        }
        
        // gesture track components
        //    for (NSString *gestureTrackComponent in gestureTrackComponents) {
        //        NSString *path = [[NSBundle mainBundle] pathForResource:gestureTrackComponent ofType:@"bundle"];
        //        FUItem *item = [FUItem itemWithPath:path name:gestureTrackComponent];
        //        [maleAvatar addComponent:item];
        //    }
            
        // animation
        FUAnimation *maleAnimation = [FUAnimation animationWithPath:[[NSBundle mainBundle] pathForResource:@"anim_idle" ofType:@"bundle"] name:@"anim_idle"];
        [maleAvatar addAnimation:maleAnimation];
        
        [maleAvatar setColor:FURGBColorMake(227, 158, 132) forKey:@"skin_color"];
        
        maleAvatar.position = fullPosition;
        femaleAvatar.position = fullPosition;
        
        _avatars = @[femaleAvatar, maleAvatar];
    }
    return _avatars;
}

@end
