//
//  FUBodyAvatarViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FUBodyAvatarViewModel.h"

@interface FUBodyAvatarViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *avatarItems;
@property (nonatomic, copy) NSArray<FUAvatar *> *avatars;

@property (nonatomic, strong) FUScene *scene;
@property (nonatomic, strong) FUBackground *sceneBackground;
@property (nonatomic, strong) FUAvatar *currentAvatar;

@end

@implementation FUBodyAvatarViewModel {
    FUPosition halfBodyPosition;
    FUPosition wholeBodyPosition;
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        // 加载抗锯齿道具
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa" ofType:@"bundle"];
        [FURenderKit shareRenderKit].antiAliasing = [[FUItem alloc] initWithPath:path name:@"antiAliasing"];
        
        // 初始化FUScene背景
        self.sceneBackground = [[FUBackground alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"default_bg" ofType:@"bundle"] name:@"scene_background"];
        
        // 初始化FUScene
        self.scene = [[FUScene alloc] init];
        self.scene.AIConfig.bodyTrackEnable = YES;
        self.scene.AIConfig.avatarTranslationScale = FUPositionMake(0, 0, 0);
        [self.scene.AIConfig setAvatarAnimFilter:5 pos:0 angle:0];
        
        // 半身和全身位置参考值
        halfBodyPosition = FUPositionMake(0.0, 0.0, FUDeviceIsiPhoneXStyle() ? -200 : -183.89);
        wholeBodyPosition = FUPositionMake(0.0, 53.14, FUDeviceIsiPhoneXStyle() ? -600 : -537.94);
        
        _selectedIndex = -1;
        
        self.wholeBody = YES;
    }
    return self;
}

#pragma mark - Private methods

- (void)loadAvatar:(FUAvatar *)avatar {
    if (self.currentAvatar) {
        self.currentAvatar.visible = NO;
        [self.scene replaceAvatar:self.currentAvatar withNewAvatar:avatar];
    } else {
        [self.scene addAvatar:avatar];
    }
    avatar.position = self.wholeBody ? wholeBodyPosition : halfBodyPosition;
    avatar.humanProcessorType = 0;
    [avatar setEnableHumanAnimDriver:YES];
    avatar.visible = YES;
    self.currentAvatar = avatar;
}

#pragma mark - Setters

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex) {
        return;
    }
    if (![FURenderKit shareRenderKit].currentScene) {
        // 先添加scene到FURenderKit
        [[FURenderKit shareRenderKit] addScene:self.scene completion:^(BOOL success) {
            // 再设置currentScene
            [FURenderKit shareRenderKit].currentScene = self.scene;
            self.scene.background = self.sceneBackground;
            // 加载Avatar
            [self loadAvatar:self.avatars[selectedIndex]];
            self->_selectedIndex = selectedIndex;
        }];
    } else {
        // 直接加载Avatar
        [self loadAvatar:self.avatars[selectedIndex]];
        _selectedIndex = selectedIndex;
    }
}

- (void)setWholeBody:(BOOL)wholeBody {
    _wholeBody = wholeBody;
    self.currentAvatar.position = wholeBody ? wholeBodyPosition : halfBodyPosition;
    self.scene.AIConfig.bodyTrackMode = wholeBody ? FUBodyTrackModeFull : FUBodyTrackModeHalf;
}

#pragma mark - Getters

- (NSArray<FUAvatar *> *)avatars {
    if (!_avatars) {
        // setup female
        FUAvatar *femaleAvatar = [[FUAvatar alloc] init];
        
        // components
        NSArray *femaleComponents = @[@"female_hair_23", @"headnv", @"midBody_female", @"taozhuang_12", @"toushi_5", @"xiezi_danxie"];
        for (NSString *component in femaleComponents) {
            NSString *path = [[NSBundle mainBundle] pathForResource:component ofType:@"bundle"];
            FUItem *item = [FUItem itemWithPath:path name:component];
            if ([component isEqualToString:@"midBody_female"]) {
                item.bodyInvisibleList = [NSSet setWithObjects:@2, @3, @4, nil];
            }
            [femaleAvatar addComponent:item];
        }
            
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
        NSArray *maleComponents = @[@"headnan", @"kuzi_changku_5", @"male_hair_5", @"midBody_male", @"peishi_erding_2", @"toushi_7", @"waitao_3", @"xiezi_tuoxie_2"];
        for (NSString *component in maleComponents) {
            NSString *path = [[NSBundle mainBundle] pathForResource:component ofType:@"bundle"];
            FUItem *item = [FUItem itemWithPath:path name:component];
            if ([component isEqualToString:@"midBody_male"]) {
                item.bodyInvisibleList = [NSSet setWithObjects:@2, @3, @4, nil];
            }
            [maleAvatar addComponent:item];
        }
            
        // animation
        FUAnimation *maleAnimation = [FUAnimation animationWithPath:[[NSBundle mainBundle] pathForResource:@"anim_idle" ofType:@"bundle"] name:@"anim_idle"];
        [maleAvatar addAnimation:maleAnimation];
        
        [maleAvatar setColor:FURGBColorMake(227, 158, 132) forKey:@"skin_color"];
        
        _avatars = @[femaleAvatar, maleAvatar];
    }
    return _avatars;
}

- (NSArray<NSString *> *)avatarItems {
    if (!_avatarItems) {
        _avatarItems = @[@"avatar_female", @"avatar_male"];
    }
    return _avatarItems;
}

#pragma mark - Overriding

- (BOOL)needsLoadingBeauty {
    return NO;
}

- (BOOL)supportCaptureAndRecording {
    return NO;
}

- (BOOL)supportSwitchingOutputFormat {
    return NO;
}

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace | FUAIModelTypeHuman;
}

- (FUDetectingParts)detectingParts {
    return FUDetectingPartsHuman;
}

- (FUModule)module {
    return FUModuleBodyAvatar;
}

@end
