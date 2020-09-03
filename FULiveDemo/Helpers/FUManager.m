//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import "FURenderer.h"
#import "authpack.h"
#import "FULiveModel.h"
#import <sys/utsname.h>
#import <CoreMotion/CoreMotion.h>
#import "FUMusicPlayer.h"
#import "FUImageHelper.h"
#import "FURenderer+header.h"

@interface FUManager ()
{
    int items[FUNamaHandleTotal];
    
    /* 记录暂时不需要render句柄，用于实现：重新加载道具，暂时不用业务 */
    int oldItems[FUNamaHandleTotal];
    int frameID;
    /* 捏脸头道具加载慢，编辑内销毁保存句柄不销毁*/
    int avtarStrongHandle;
}

@property (nonatomic, strong) CMMotionManager *motionManager;
/* 重力感应道具 */
@property (nonatomic,assign) BOOL isMotionItem;
/* 当前加载的道具资源 */
@property (nonatomic,copy) NSString *currentBoudleName;
/* 需提示item */
@property (nonatomic, strong) NSDictionary *hintDic;
/* 带屏幕方向的道具 */
@property (nonatomic, strong)NSArray *deviceOrientationItems;
/* 3d 渲染后图片转正 */
@property (nonatomic, strong) FURotatedImage *mRotatedImage;
@end

static FUManager *shareManager = NULL;

@implementation FUManager

+ (FUManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupDeviceMotion];
        _asyncLoadQueue = dispatch_queue_create("com.faceLoadItem", DISPATCH_QUEUE_SERIAL);
        /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
         还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
        
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

        [[FURenderer shareRenderer] setupWithData:nil dataSize:0 ardata:nil authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];

        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        
        NSLog(@"---%lf",endTime);
        
        /* 加载AI模型 */
        [self loadAIModle];
//        fuSetLogLevel(1);
        dispatch_async(_asyncLoadQueue, ^{
            
            NSData *tongueData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tongue.bundle" ofType:nil]];
            int ret0 = fuLoadTongueModel((void *)tongueData.bytes, (int)tongueData.length) ;
            NSLog(@"fuLoadTongueModel %@",ret0 == 0 ? @"failure":@"success" );
     
        });
        
        /* 美颜 */
        [self setupFilterData];
        [self setupShapData];
        [self setupSkinData];
        
        self.enableGesture = NO;
        self.enableMaxFaces = NO;
        
        /* 提示语句 */
        [self setupItmeHintData];
        /* 道具加载model */
        [self setupItemDataSource];
        
        // 默认竖屏
        self.deviceOrientation = 0 ;
//        fuSetDefaultOrientation(self.deviceOrientation);
        
        /* 设置嘴巴灵活度 默认= 0*/
        float flexible = 0.5;
        fuSetFaceTrackParam((char *)[@"mouth_expression_more_flexible" UTF8String], &flexible);

        /* 带屏幕方向的道具 */
        self.deviceOrientationItems = @[@"ctrl_rain",@"ctrl_snow",@"ctrl_flower",@"ssd_thread_six"];
        
        _mRotatedImage = [[FURotatedImage alloc] init];
        
        NSLog(@"faceunitySDK version:%@",[FURenderer getVersion]);
    }
    
    return self;
}


-(void)loadAIModle{
    NSData *ai_human_processor = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ai_human_processor.bundle" ofType:nil]];
    [FURenderer loadAIModelFromPackage:(void *)ai_human_processor.bytes size:(int)ai_human_processor.length aitype:FUAITYPE_HUMAN_PROCESSOR];
    NSData *ai_face_processor = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ai_face_processor.bundle" ofType:nil]];
    [FURenderer loadAIModelFromPackage:(void *)ai_face_processor.bytes size:(int)ai_face_processor.length aitype:FUAITYPE_FACEPROCESSOR];
    
    NSData *ai_gesture = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ai_gesture.bundle" ofType:nil]];
    [FURenderer loadAIModelFromPackage:(void *)ai_gesture.bytes size:(int)ai_gesture.length aitype:FUAITYPE_HANDGESTURE];
//
}

-(void)setupItmeHintData{
    self.hintDic = @{
                @"hez_ztt_fu_mp":@"张嘴试试",
                @"future_warrior":@"张嘴试试",
                @"jet_mask":@"鼓腮帮子",
                @"sdx2":@"皱眉触发",
                @"luhantongkuan_ztt_fu":@"眨一眨眼",
                @"qingqing_ztt_fu":@"嘟嘴试试",
                @"xiaobianzi_zh_fu":@"微笑触发",
                @"xiaoxueshen_ztt_fu":@"吹气触发",
                @"hez_ztt_fu":@"张嘴试试",
                @"ssd_thread_korheart":@"单手手指比心",
                @"fu_zh_baoquan":@"双手抱拳",
                @"fu_zh_hezxiong":@"双手合十",
                @"fu_ztt_live520":@"双手比心",
                @"ssd_thread_thumb":@"竖个拇指",
                @"ssd_thread_six":@"比个六",
                @"ssd_thread_cute":@"双拳靠近脸颊卖萌",
                @"ctrl_rain":@"推出手掌",
                @"ctrl_snow":@"推出手掌",
                @"ctrl_flower":@"推出手掌",
                @"big_head_facewarp3":@"微笑触发"
    };
}

-(void)setupFilterData{
    NSArray *beautyFiltersDataSource = @[@"origin",@"ziran1",@"ziran2",@"ziran3",@"ziran4",@"ziran5",@"ziran6",@"ziran7",@"ziran8",
    @"zhiganhui1",@"zhiganhui2",@"zhiganhui3",@"zhiganhui4",@"zhiganhui5",@"zhiganhui6",@"zhiganhui7",@"zhiganhui8",
                                          @"mitao1",@"mitao2",@"mitao3",@"mitao4",@"mitao5",@"mitao6",@"mitao7",@"mitao8",
                                         @"bailiang1",@"bailiang2",@"bailiang3",@"bailiang4",@"bailiang5",@"bailiang6",@"bailiang7"
                                         ,@"fennen1",@"fennen2",@"fennen3",@"fennen5",@"fennen6",@"fennen7",@"fennen8",
                                         @"lengsediao1",@"lengsediao2",@"lengsediao3",@"lengsediao4",@"lengsediao7",@"lengsediao8",@"lengsediao11",
                                         @"nuansediao1",@"nuansediao2",
                                         @"gexing1",@"gexing2",@"gexing3",@"gexing4",@"gexing5",@"gexing7",@"gexing10",@"gexing11",
                                         @"xiaoqingxin1",@"xiaoqingxin3",@"xiaoqingxin4",@"xiaoqingxin6",
                                         @"heibai1",@"heibai2",@"heibai3",@"heibai4"];
    
    NSDictionary *filtersCHName = @{@"origin":@"原图",@"bailiang1":@"白亮1",@"bailiang2":@"白亮2",@"bailiang3":@"白亮3",@"bailiang4":@"白亮4",@"bailiang5":@"白亮5",@"bailiang6":@"白亮6",@"bailiang7":@"白亮7"
                                    ,@"fennen1":@"粉嫩1",@"fennen2":@"粉嫩2",@"fennen3":@"粉嫩3",@"fennen4":@"粉嫩4",@"fennen5":@"粉嫩5",@"fennen6":@"粉嫩6",@"fennen7":@"粉嫩7",@"fennen8":@"粉嫩8",
                                    @"gexing1":@"个性1",@"gexing2":@"个性2",@"gexing3":@"个性3",@"gexing4":@"个性4",@"gexing5":@"个性5",@"gexing6":@"个性6",@"gexing7":@"个性7",@"gexing8":@"个性8",@"gexing9":@"个性9",@"gexing10":@"个性10",@"gexing11":@"个性11",
                                    @"heibai1":@"黑白1",@"heibai2":@"黑白2",@"heibai3":@"黑白3",@"heibai4":@"黑白4",@"heibai5":@"黑白5",
                                    @"lengsediao1":@"冷色调1",@"lengsediao2":@"冷色调2",@"lengsediao3":@"冷色调3",@"lengsediao4":@"冷色调4",@"lengsediao5":@"冷色调5",@"lengsediao6":@"冷色调6",@"lengsediao7":@"冷色调7",@"lengsediao8":@"冷色调8",@"lengsediao9":@"冷色调9",@"lengsediao10":@"冷色调10",@"lengsediao11":@"冷色调11",
                                    @"nuansediao1":@"暖色调1",@"nuansediao2":@"暖色调2",@"nuansediao3":@"暖色调3",@"xiaoqingxin1":@"小清新1",@"xiaoqingxin2":@"小清新2",@"xiaoqingxin3":@"小清新3",@"xiaoqingxin4":@"小清新4",@"xiaoqingxin5":@"小清新5",@"xiaoqingxin6":@"小清新6",
                                    @"ziran1":@"自然1",@"ziran2":@"自然2",@"ziran3":@"自然3",@"ziran4":@"自然4",@"ziran5":@"自然5",@"ziran6":@"自然6",@"ziran7":@"自然7",@"ziran8":@"自然8",
                                    @"mitao1":@"蜜桃1",@"mitao2":@"蜜桃2",@"mitao3":@"蜜桃3",@"mitao4":@"蜜桃4",@"mitao5":@"蜜桃5",@"mitao6":@"蜜桃6",@"mitao7":@"蜜桃7",@"mitao8":@"蜜桃8",
                                    @"zhiganhui1":@"质感灰1",@"zhiganhui2":@"质感灰2",@"zhiganhui3":@"质感灰3",@"zhiganhui4":@"质感灰4",@"zhiganhui5":@"质感灰5",@"zhiganhui6":@"质感灰6",@"zhiganhui7":@"质感灰7",@"zhiganhui8":@"质感灰8"
    };
    if (!_filters) {
        _filters = [[NSMutableArray alloc] init];
    }
    
    for (NSString *str in beautyFiltersDataSource) {
        FUBeautyParam *modle = [[FUBeautyParam alloc] init];
        modle.mParam = str;
        modle.mTitle = [filtersCHName valueForKey:str];
        modle.mValue = 0.4;

        [_filters addObject:modle];
    }
    
    self.seletedFliter = _filters[2];
}

-(void)setupSkinData{
    NSArray *prams = @[@"blur_level",@"color_level",@"red_level",@"sharpen",@"eye_bright",@"tooth_whiten",@"remove_pouch_strength",@"remove_nasolabial_folds_strength"];//
    NSDictionary *titelDic = @{@"blur_level":@"精细磨皮",@"color_level":@"美白",@"red_level":@"红润",@"sharpen":@"锐化",@"remove_pouch_strength":@"去黑眼圈",@"remove_nasolabial_folds_strength":@"去法令纹",@"eye_bright":@"亮眼",@"tooth_whiten":@"美牙"};
    NSDictionary *defaultValueDic = @{@"blur_level":@(0.7),@"color_level":@(0.3),@"red_level":@(0.3),@"sharpen":@(0.2),@"remove_pouch_strength":@(0),@"remove_nasolabial_folds_strength":@(0),@"eye_bright":@(0),@"tooth_whiten":@(0)};
    
    
    if (!_skinParams) {
        _skinParams = [[NSMutableArray alloc] init];
    }

    for (NSString *str in prams) {

        FUBeautyParam *modle = [[FUBeautyParam alloc] init];
        modle.mParam = str;
        modle.mTitle = [titelDic valueForKey:str];
        modle.mValue = [[defaultValueDic valueForKey:str] floatValue];
        modle.defaultValue = modle.mValue;
        [_skinParams addObject:modle];
    }
    
}

-(void)setupShapData{
   NSArray *prams = @[@"cheek_thinning",@"cheek_v",@"cheek_narrow",@"cheek_small",@"eye_enlarging",@"intensity_chin",@"intensity_forehead",@"intensity_nose",@"intensity_mouth",@"intensity_canthus",@"intensity_eye_space",@"intensity_eye_rotate",@"intensity_long_nose",@"intensity_philtrum",@"intensity_smile"];
    NSDictionary *titelDic = @{@"cheek_thinning":@"瘦脸",@"cheek_v":@"v脸",@"cheek_narrow":@"窄脸",@"cheek_small":@"小脸",@"eye_enlarging":@"大眼",@"intensity_chin":@"下巴",
                               @"intensity_forehead":@"额头",@"intensity_nose":@"瘦鼻",@"intensity_mouth":@"嘴型",@"intensity_canthus":@"开眼角",@"intensity_eye_space":@"眼距",@"intensity_eye_rotate":@"眼睛角度",@"intensity_long_nose":@"长鼻",@"intensity_philtrum":@"缩人中",@"intensity_smile":@"微笑嘴角"
    };
   NSDictionary *defaultValueDic = @{@"cheek_thinning":@(0),@"cheek_v":@(0.5),@"cheek_narrow":@(0),@"cheek_small":@(0),@"eye_enlarging":@(0.4),@"intensity_chin":@(0.3),
                              @"intensity_forehead":@(0.3),@"intensity_nose":@(0.5),@"intensity_mouth":@(0.4),@"intensity_canthus":@(0),@"intensity_eye_space":@(0.5),@"intensity_eye_rotate":@(0.5),@"intensity_long_nose":@(0.5),@"intensity_philtrum":@(0.5),@"intensity_smile":@(0)
   };
   
   if (!_shapeParams) {
       _shapeParams = [[NSMutableArray alloc] init];
   }
   
   for (NSString *str in prams) {
       BOOL isStyle101 = NO;
       if ([str isEqualToString:@"intensity_chin"] || [str isEqualToString:@"intensity_forehead"] || [str isEqualToString:@"intensity_mouth"] || [str isEqualToString:@"intensity_eye_space"] || [str isEqualToString:@"intensity_eye_rotate"] || [str isEqualToString:@"intensity_long_nose"] || [str isEqualToString:@"intensity_philtrum"]) {
           isStyle101 = YES;
       }
       
       FUBeautyParam *modle = [[FUBeautyParam alloc] init];
       modle.mParam = str;
       modle.mTitle = [titelDic valueForKey:str];
       modle.mValue = [[defaultValueDic valueForKey:str] floatValue];
       modle.defaultValue = modle.mValue;
       modle.iSStyle101 = isStyle101;
       [_shapeParams addObject:modle];
   }
}

- (void)loadItems
{
    /**加载普通道具*/
    [self loadItem:self.selectedItem completion:nil];
    
    /**加载美颜道具*/
    [self loadFilter];
}


/**销毁全部道具*/
- (void)destoryItems{
    dispatch_async(_asyncLoadQueue, ^{
         NSLog(@"strat Nama destroy all items ~");
        [FURenderer destroyAllItems];
        /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
        for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
            items[i] = 0;
            oldItems[i] = 0;
        }
        [FURenderer onCameraChange];
        /**销毁道具后，清除context缓存*/
        [FURenderer OnDeviceLost];
    });
}


- (void)destoryItemAboutType:(FUNamaHandleType)type;
{
    dispatch_async(_asyncLoadQueue, ^{
        /**后销毁老道具句柄*/
        if (items[type] != 0) {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[type]];
            items[type] = 0;
        }
    });
}

-(int)getHandleAboutType:(FUNamaHandleType)type{
    return items[type];
}


/**加载手势识别道具，默认未不加载*/
- (void)loadGesture
{
    dispatch_async(_asyncLoadQueue, ^{
        if (items[FUNamaHandleTypeGesture] != 0) {
            NSLog(@"faceunity: destroy gesture");
            [FURenderer destroyItem:items[FUNamaHandleTypeGesture]];
            items[FUNamaHandleTypeGesture] = 0;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:@"heart_v2.bundle" ofType:nil];
        items[FUNamaHandleTypeGesture] = [FURenderer itemWithContentsOfFile:path];
    });
}

/*
 is3DFlipH 翻转模型
 isFlipExpr 翻转表情
 isFlipTrack 翻转位置和旋转
 isFlipLight 翻转光照
 */
- (void)set3DFlipH
{
    [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"is3DFlipH" value:@(1)];
    [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"isFlipExpr" value:@(1)];
    [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"isFlipTrack" value:@(1)];
    [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"isFlipLight" value:@(1)];
}

- (void)setLoc_xy_flip
{
    [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"loc_x_flip" value:@(1)];
    [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"loc_y_flip" value:@(1)];
}

- (void)musicFilterSetMusicTime
{
    [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"music_time" value:@([FUMusicPlayer sharePlayer].currentTime * 1000 + 50)];//需要加50ms的延迟
}


-(void)setParamItemAboutType:(FUNamaHandleType)type name:(NSString *)paramName value:(float)value{
    dispatch_async(_asyncLoadQueue, ^{
       if(items[type]){
        [FURenderer itemSetParam:items[type] withName:paramName value:@(value)];
           NSLog(@"设置type(%lu)----参数（%@）-----值（%lf",(unsigned long)type,paramName,value);
       }
    });
}

/// 将道具句柄移除nama 渲染，注意：b该操作不会销毁道具
/// @param type 句柄索引
-(void)removeNamaRenderWithType:(FUNamaHandleType)type{
       if (items[type] == 0) {
           return;
       }
       oldItems[type] = items[type];
       items[type] = 0;
}

/// 将移除的道具句柄，重新加入，渲染出效果
/// @param type 句柄索引
-(void)rejoinNamaRenderWithType:(FUNamaHandleType)type{
    if (oldItems[type] == 0) {
        return;
    }
    items[type] = oldItems[type];
    oldItems[type] = 0;
}


#pragma mark -  加载bundle
/**加载美颜道具*/
- (void)loadFilter{
    dispatch_async(_asyncLoadQueue, ^{
        if (items[FUNamaHandleTypeBeauty] == 0) {

            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

            NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
            items[FUNamaHandleTypeBeauty] = [FURenderer itemWithContentsOfFile:path];

            /* 默认精细磨皮 */
            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"heavy_blur" value:@(0)];
            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"blur_type" value:@(2)];
            /* 默认自定义脸型 */
            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"face_shape" value:@(4)];
            [self setBeautyParameters];
            
            CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);

            NSLog(@"加载美颜道具耗时: %f ms", endTime * 1000.0);
     
        }
    });
}


- (void)setBeautyParameters{
    
    for (FUBeautyParam *modle in _skinParams){
        if ([modle.mParam isEqualToString:@"blur_level"]) {
            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue * 6)];
        }else{
            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue)];
        }
    }
    
    for (FUBeautyParam *modle in _shapeParams){
         [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue)];
     }
    
    
    /* 设置默认状态 */
    if (self.seletedFliter) {
        [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"filter_name" value:[self.seletedFliter.mParam lowercaseString]];
        [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"filter_level" value:@(self.seletedFliter.mValue)];
    }

}

/*设置默认参数*/
- (void)setBeautyDefaultParameters:(FUBeautyModuleType)type{
    if((type & FUBeautyModuleTypeSkin) == FUBeautyModuleTypeSkin){
        for (FUBeautyParam *modle in _skinParams){
            modle.mValue = modle.defaultValue;
            if ([modle.mParam isEqualToString:@"blur_level"]) {
                [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue * 6)];
            }else{
                [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue)];
            }
        }

    }
    
    if((type & FUBeautyModuleTypeShape) == FUBeautyModuleTypeShape){
        for (FUBeautyParam *modle in _shapeParams){
            modle.mValue = modle.defaultValue;
            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue)];
        }
        
    }
}

-(BOOL)isDefaultSkinValue{
    for (FUBeautyParam *modle in _skinParams){
        if (fabsf(modle.mValue - modle.defaultValue) > 0.01 ) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)isDefaultShapeValue{
    for (FUBeautyParam *modle in _shapeParams){
        if (fabsf(modle.mValue - modle.defaultValue) > 0.01 ) {
            return NO;
        }
    }
    return YES;
}

/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName completion:(void (^)(BOOL finished))completion{
    dispatch_async(_asyncLoadQueue, ^{
        self.selectedItem = itemName ;
        
        int destoryItem = items[FUNamaHandleTypeItem];
        
        if (itemName != nil && ![itemName isEqual: @"noitem"]) {
            /**先创建道具句柄*/
            NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
            
            int itemHandle = [FURenderer itemWithContentsOfFile:path];
            
            // 人像驱动 设置 3DFlipH
            BOOL isPortraitDrive = [itemName hasPrefix:@"picasso_e"];
            BOOL isAnimoji = [itemName hasSuffix:@"_Animoji"];
            
            if (isPortraitDrive || isAnimoji) {
                [FURenderer itemSetParam:itemHandle withName:@"{\"thing\":\"<global>\",\"param\":\"follow\"}" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"is3DFlipH" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"isFlipExpr" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"isFlipTrack" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"isFlipLight" value:@(1)];
            }
            
            if ([itemName isEqualToString:@"luhantongkuan_ztt_fu"]) {
                [FURenderer itemSetParam:itemHandle withName:@"flip_action" value:@(1)];
            }
            
            if ([self.deviceOrientationItems containsObject:itemName]) {//带重力感应道具
                [FURenderer itemSetParam:itemHandle withName:@"rotMode" value:@(self.deviceOrientation)];
                self.isMotionItem = YES;
            }else{
                self.isMotionItem = NO;
            }
            
            if ([itemName isEqualToString:@"fu_lm_koreaheart"]) {//比心道具手动调整下
                 [FURenderer itemSetParam:itemHandle withName:@"handOffY" value:@(-100)];
            }
            /**将刚刚创建的句柄存放在items[FUNamaHandleTypeItem]中*/
            items[FUNamaHandleTypeItem] = itemHandle;
            if(completion){
                completion(YES);
            }
            }else{
                if(completion){
                    completion(NO);
                }
            /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[FUNamaHandleTypeItem]设为0*/
            items[FUNamaHandleTypeItem] = 0;
        }
        NSLog(@"faceunity: load item");
        
        /**后销毁老道具句柄*/
        if (destoryItem != 0)
        {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:destoryItem];
        }
    });
 
}

- (void)loadBundleWithName:(NSString *)name aboutType:(FUNamaHandleType)type{
    dispatch_async(_asyncLoadQueue, ^{
        if (items[type] != 0) {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[type]];
            items[type] = 0;
        }
        if ([name isEqualToString:@""] || !name) {
            return ;
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"];
        items[type] = [FURenderer itemWithContentsOfFile:filePath];
        
        NSLog(@"load handle = %d,type = %lu;  美颜handle = %d,",items[type],(unsigned long)type,items[0]);
    });
}

#pragma mark -  美妆

- (void)loadMakeupBundleWithName:(NSString *)name{
    dispatch_async(_asyncLoadQueue, ^{
        if (items[FUNamaHandleTypeMakeup] != 0) {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[FUNamaHandleTypeMakeup]];
            items[FUNamaHandleTypeMakeup] = 0;
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"];
        items[FUNamaHandleTypeMakeup] = [FURenderer itemWithContentsOfFile:filePath];
        
        [FURenderer itemSetParam:items[FUNamaHandleTypeMakeup] withName:@"makeup_lip_mask" value:@(1.0)];
        [FURenderer itemSetParam:items[FUNamaHandleTypeMakeup] withName:@"makeup_intensity_lip" value:@(1.0)];
        
    });
}

/*
 tex_brow 眉毛
 tex_eye 眼影
 tex_pupil 美瞳
 tex_eyeLash 睫毛
 tex_lip 口红
 tex_highlight 口红高光
 //jiemao
 //meimao
 tex_eyeLiner 眼线
 tex_blusher腮红
 */
-(void)setMakeupItemParamImageName:(NSString *)image param:(NSString *)paramStr{
    dispatch_async(_asyncLoadQueue, ^{
        if (!image) {
            NSLog(@"美妆图片为空");
            return;
        }
        if (items[FUNamaHandleTypeMakeup]) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:image ofType:@"bundle"];
            if (filePath != nil) {
                int handle = [FURenderer itemWithContentsOfFile:filePath];
               int res = [FURenderer bindItems:items[FUNamaHandleTypeMakeup] items:&handle itemsCount:1];
                NSLog(@"----道具----bind Result(%d)---handel(%d)",res,handle);
            }
        }else{
            NSLog(@"美妆设置--bundle(nil)");
        }
    });
    
}

/*
 is_makeup_on: 1, //美妆开关
 makeup_intensity:1.0, //美妆程度 //下面是每个妆容单独的参数，intensity设置为0即为关闭这种妆效 makeup_intensity_lip:1.0, //kouhong makeup_intensity_pupil:1.0, //meitong
 makeup_intensity_eye:1.0,
 makeup_intensity_eyeLiner:1.0,
 makeup_intensity_eyelash:1.0,
 makeup_intensity_eyeBrow:1.0,
 makeup_intensity_blusher:1.0, //saihong
 makeup_lip_color:[0,0,0,0] //长度为4的数组，rgba颜色值
 makeup_lip_mask:0.0 //嘴唇优化效果开关，1.0为开 0为关
 */
-(void)setMakeupItemIntensity:(float )value param:(NSString *)paramStr{

    if (!paramStr || [paramStr isEqualToString:@""]) {
        NSLog(@"参数为nil");
        return;
    }
    dispatch_async(_asyncLoadQueue, ^{
        if (items[FUNamaHandleTypeMakeup]) {
            int res = [FURenderer itemSetParam:items[FUNamaHandleTypeMakeup] withName:paramStr value:@(value)];
            if (!res) NSLog(@"美妆设置失败---Parma（%@）---value(%lf)",paramStr,value);
            
        }else{
            NSLog(@"美妆设置--bundle(nil)");
        }
    });
}

-(void)setMakeupItemStr:(NSString *)sdkStr valueArr:(NSArray *)valueArr{
    dispatch_async(_asyncLoadQueue, ^{
        if (!sdkStr || !valueArr) {
            return;
        }
        
        int length = (int)valueArr.count;
        
        double *value = (double *)malloc(length * sizeof(double));
        for (int i =0; i < length; i ++) {
            value[i] = [valueArr[i] doubleValue];
        }
        [FURenderer itemSetParamdv:items[FUNamaHandleTypeMakeup] withName:sdkStr value:value length:length];
        free(value);
    });
}


#pragma mark -  render
/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
	// 在未识别到人脸时根据重力方向设置人脸检测方向
    if ([self isDeviceMotionChange]) {
        if (self.isMotionItem) {
            //针对带重力道具
            [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"rotMode" value:@(self.deviceOrientation)];
            /* 手势识别里 666 道具，带有全屏元素 */
            [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"rotationMode" value:@(self.deviceOrientation)];
        }
//        fuSetDefaultOrientation(self.deviceOrientation);
        
        /* 解决旋转屏幕效果异常 onCameraChange*/
        [FURenderer onCameraChange];
    }
//    double *aaa = [self get4ElementsFormDeviceMotion];
//    [FURenderer itemSetParamdv:items[FUNamaHandleTypeItem] withName:@"motion_rotation" value:aaa length:4];
    /**设置美颜参数*/

    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/

    CVPixelBufferRef buffer = [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    
    return buffer;
}

-(void)renderItemsWithPtaPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    int h = (int)CVPixelBufferGetHeight(pixelBuffer);
    int stride = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    int w = stride/4;
    void* pixelBuffer_pod  = (void *)CVPixelBufferGetBaseAddress(pixelBuffer);
    /* 核心控制器道具 */
    int controlHandle = items[FUNamaHandleTypeBodyAvtar];
    /* 抗锯齿道具 */
    int fxaahandle  = items[FUNamaHandleTypeFxaa];
    if (controlHandle == 0) {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        NSLog(@"error no load control");
        return;
    }
    if(fxaahandle == 0){
        NSLog(@"info no load fxaa,锯齿明显");
    }
    static int itemHandes[2] = {0};
    itemHandes[0] = controlHandle;
    itemHandes[1] = fxaahandle;
    
    [[FURenderer shareRenderer] renderBundles:pixelBuffer_pod inFormat:FU_FORMAT_BGRA_BUFFER outPtr:pixelBuffer_pod  outFormat:FU_FORMAT_BGRA_BUFFER width:w height:h frameId:frameID++ items:itemHandes itemCount:2];
    
    _mRotatedImage.mData = pixelBuffer_pod;
    _mRotatedImage.mWidth = w;
    _mRotatedImage.mHeight = h;
    [[FURenderer shareRenderer] rotateImage:_mRotatedImage inPtr:pixelBuffer_pod inFormat:FU_FORMAT_BGRA_BUFFER width:w height:h rotationMode:FURotationMode180 flipX:YES flipY:NO];
    memcpy(pixelBuffer_pod ,_mRotatedImage.mData, w*h*4);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}



/* 静态图片 */
- (UIImage *)renderItemsToImage:(UIImage *)image{
    int postersWidth = (int)CGImageGetWidth(image.CGImage);
    int postersHeight = (int)CGImageGetHeight(image.CGImage);
    CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    [[FURenderer shareRenderer] renderItems:imageData inFormat:FU_FORMAT_RGBA_BUFFER outPtr:imageData outFormat:FU_FORMAT_RGBA_BUFFER width:postersWidth height:postersHeight frameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];
    
    frameID++;
    /* 转回image */
    image = [FUImageHelper convertBitmapRGBA8ToUIImage:imageData withWidth:postersWidth withHeight:postersHeight];
    CFRelease(dataFromImageDataProvider);
    
    return image;
}


-(CVPixelBufferRef)renderAvatarPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    float expression[46] = {0};
    float translation[3] = {0,-40,250};
    float rotation[4] = {0,0,0,1};
    float rotation_mode[1] = {0};
    float pupil_pos[2] = {0};
    int is_valid = 0;
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *bytes = (void *)CVPixelBufferGetBaseAddress(pixelBuffer);
    int stride1 = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    int h1 = (int)CVPixelBufferGetHeight(pixelBuffer);
    int w1 = (int)CVPixelBufferGetWidth(pixelBuffer);
    /* 检测获取人脸信息 */
 //    [FURenderer trackFace:0 inputData:bytes width:stride1/4 height:h1];
 //   [FURenderer trackFaceWithTongue:0 inputData:bytes width:stride1/4 height:h1];
//    is_valid = [FURenderer isTracking];
    
//    if (is_valid) {//获取人脸信息
//        [FURenderer getFaceInfo:0 name:@"expression" pret:expression number:56];
//        //[FURenderer getFaceInfo:0 name:@"translation" pret:translation number:3];
////        [FURenderer getFaceInfo:0 name:@"rotation" pret:rotation number:4];
//        [FURenderer getFaceInfo:0 name:@"rotation_mode" pret:rotation_mode number:1];
//        [FURenderer getFaceInfo:0 name:@"pupil_pos" pret:pupil_pos number:2];
//    }
 
    /* 初始化人脸信息结构，传入nama驱动animoji */
    TAvatarInfo info;
    info.p_translation = translation;
    info.p_rotation = rotation;
    info.p_expression = expression;
    info.rotation_mode = rotation_mode;
    info.pupil_pos = pupil_pos;
    info.is_valid = 1;
    
    [[FURenderer shareRenderer] renderItems:&info inFormat:FU_FORMAT_AVATAR_INFO outPtr:bytes outFormat:FU_FORMAT_BGRA_BUFFER width:stride1/4 height:h1 frameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    frameID += 1;
    
    return pixelBuffer;
}


#pragma mark -  海报换脸

-(void)setPosterItemParamImage:(UIImage *)posterImage photo:(UIImage *)photoImage photoLandmarks:(float *)photoLandmarks warpValue:(id)warpValue{
    /* 海报图像转data */
    int postersWidth = (int)CGImageGetWidth(posterImage.CGImage);
    int postersHeight = (int)CGImageGetHeight(posterImage.CGImage);
    CFDataRef posterDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(posterImage.CGImage));
    GLubyte *posterData = (GLubyte *)CFDataGetBytePtr(posterDataFromImageDataProvider);

    /* 照片图像转data */
    int photoWidth = (int)CGImageGetWidth(photoImage.CGImage);
    int photoHeight = (int)CGImageGetHeight(photoImage.CGImage);
    CFDataRef photoDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(photoImage.CGImage));
    GLubyte *photoData = (GLubyte *)CFDataGetBytePtr(photoDataFromImageDataProvider);

    [FURenderer onCameraChange];
    /* 获取海报的人脸点位 */
    float posterLandmarks[239*2];
    int endI = 0;
    int is_tracking = 0;
    for (int i = 0; i< 50; i++) {//校验出人脸再trsckFace 5次
        [FURenderer trackFace:FU_FORMAT_RGBA_BUFFER inputData:posterData width:postersWidth height:postersHeight];
        if ([FURenderer isTracking] > 0) {
            is_tracking = 1;
            if (endI == 0) {
                endI = i;
            }
            if (i > endI + 5) {
                break;
            }
        }
    }
    
   int ret = [FURenderer getFaceInfo:0 name:@"landmarks" pret:posterLandmarks number:150];
    if (ret == 0) {
        memset(posterLandmarks, 0, sizeof(float)*150);
    }

    double poster[150];
    double photo[150];
    
    /* 将点位信息用double表示 */
    for (int i = 0; i < 150; i ++) {
        poster[i] = (double)posterLandmarks[i];
        photo[i]  = (double)photoLandmarks[i];
    }

    /* 参数设置，注意：当前上下文改变，需要设置setUpCurrentContext */
    [[FURenderer shareRenderer] setUpCurrentContext];
    /* 销毁old */
    fuDeleteTexForItem(items[FUNamaHandleTypeChangeface], "tex_input");
    fuDeleteTexForItem(items[FUNamaHandleTypeChangeface], "tex_template");
    /* 照片 */
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "input_width", photoWidth);
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "input_height", photoHeight);
    fuItemSetParamdv(items[FUNamaHandleTypeChangeface], "input_face_points", photo, 150);
    fuCreateTexForItem(items[FUNamaHandleTypeChangeface], "tex_input", photoData, photoWidth, photoHeight);
    /* 模板海报 */
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "template_width", postersWidth);
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "template_height", postersHeight);
    fuItemSetParamdv(items[FUNamaHandleTypeChangeface], "template_face_points", poster, 150);
    if (warpValue) {//特殊模板，设置弯曲度
        fuItemSetParamd(items[FUNamaHandleTypeChangeface], "warp_intensity", [warpValue doubleValue]);
    }
    fuCreateTexForItem(items[FUNamaHandleTypeChangeface], "tex_template", posterData, postersWidth, postersHeight);
    [[FURenderer shareRenderer] setBackCurrentContext];

    
    CFRelease(posterDataFromImageDataProvider);
    CFRelease(photoDataFromImageDataProvider);
}

#pragma mark -  动漫滤镜
/* 关闭开启动漫滤镜 */
- (void)loadFilterAnimoji:(NSString *)itemName style:(int)style{
    
    dispatch_async(_asyncLoadQueue, ^{
        
        if (itemName != nil && ![itemName isEqual: @"noitem"]) {
            if (items[FUNamaHandleTypeComic] == 0) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"fuzzytoonfilter.bundle" ofType:nil];
                int itemHandle = [FURenderer itemWithContentsOfFile:path];
                self.currentBoudleName = @"fuzzytoonfilter";
                items[FUNamaHandleTypeComic] = itemHandle;
            }
            [FURenderer itemSetParam:items[FUNamaHandleTypeComic] withName:@"style" value:@(style)];
        }else{
            if (items[FUNamaHandleTypeComic] != 0){
                [FURenderer destroyItem:items[FUNamaHandleTypeComic]];
            }
            items[FUNamaHandleTypeComic] = 0;
            self.currentBoudleName = @"";
        }
    });
}

#pragma mark -  nama查询&设置
- (void)setAsyncTrackFaceEnable:(BOOL)enable{
    [FURenderer setAsyncTrackFaceEnable:enable];
}

- (void)setEnableGesture:(BOOL)enableGesture
{
    _enableGesture = enableGesture;
    /**开启手势识别*/
    if (_enableGesture) {
        [self loadGesture];
    }else{
        if (items[FUNamaHandleTypeGesture] != 0) {
            
            NSLog(@"faceunity: destroy gesture");
            
            [FURenderer destroyItem:items[FUNamaHandleTypeGesture]];
            
            items[FUNamaHandleTypeGesture] = 0;
        }
    }
}

/**开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内*/
- (void)setEnableMaxFaces:(BOOL)enableMaxFaces
{
    if (_enableMaxFaces == enableMaxFaces) {
        return;
    }
    
    _enableMaxFaces = enableMaxFaces;
    
    if (_enableMaxFaces) {
        [FURenderer setMaxFaces:4];
    }else{
        [FURenderer setMaxFaces:1];
    }
    
}

/**获取图像中人脸中心点*/
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    
    static CGPoint preCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preCenter = CGPointMake(0.49, 0.5);
    });
    
    // 获取人脸矩形框，坐标系原点为图像右下角，float数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
    float faceRect[4];
    int ret = [FURenderer getFaceInfo:0 name:@"face_rect" pret:faceRect number:4];
    
    if (ret == 0) {
        return preCenter;
    }
    
    // 计算出中心点的坐标值
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    
    // 将坐标系转换成以左上角为原点的坐标系
    centerX = centerX / frameSize.width;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks index:(int)index;
{
    int ret = [FURenderer getFaceInfo:index name:@"landmarks" pret:landmarks number:150];
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
}

- (CGRect)getFaceRectWithIndex:(int)index size:(CGSize)renderImageSize{
    CGRect rect = CGRectZero ;
    float faceRect[4];
    
    [FURenderer getFaceInfo:index name:@"face_rect" pret:faceRect number:4];
    
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    CGFloat width = faceRect[2] - faceRect[0] ;
    CGFloat height = faceRect[3] - faceRect[1] ;
    
    centerX = renderImageSize.width - centerX;
    centerX = centerX / renderImageSize.width;
    
    centerY = renderImageSize.height - centerY;
    centerY = centerY / renderImageSize.height;
    
    width = width / renderImageSize.width ;
    
    height = height / renderImageSize.height ;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    CGSize size = CGSizeMake(width, height) ;
    
    rect.origin = CGPointMake(center.x - size.width / 2.0, center.y - size.height / 2.0) ;
    rect.size = size ;
    
    
    return rect ;
}


/**判断是否检测到人脸*/
- (BOOL)isTracking
{
    return [FURenderer isTracking] > 0;
}

/**切换摄像头要调用此函数*/
- (void)onCameraChange{
    [FURenderer onCameraChange];
}

/**获取错误信息*/
- (NSString *)getError
{
    // 获取错误码
    int errorCode = fuGetSystemError();
    
    if (errorCode != 0) {
        
        // 通过错误码获取错误描述
        NSString *errorStr = [NSString stringWithUTF8String:fuGetSystemErrorString(errorCode)];
        
        return errorStr;
    }
    
    return nil;
}


/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK {
    NSString *version = [FURenderer getVersion];
    return [version containsString:@"lite"];
}


//保证正脸
-(BOOL)isGoodFace:(int)index{
    // 保证正脸
    float rotation[4] ;
    float DetectionAngle = 15.0 ;
    [FURenderer getFaceInfo:index name:@"rotation" pret:rotation number:4];
    
    float q0 = rotation[0];
    float q1 = rotation[1];
    float q2 = rotation[2];
    float q3 = rotation[3];
    
    float z =  atan2(2*(q0*q1 + q2 * q3), 1 - 2*(q1 * q1 + q2 * q2)) * 180 / M_PI;
    float y =  asin(2 *(q0*q2 - q1*q3)) * 180 / M_PI;
    float x = atan(2*(q0*q3 + q1*q2)/(1 - 2*(q2*q2 + q3*q3))) * 180 / M_PI;
    NSLog(@"x=%lf  y=%lf z=%lf",x,y,z);
    if (x > DetectionAngle || x < - 5 || fabs(y) > DetectionAngle || fabs(z) > DetectionAngle) {//抬头低头角度限制：仰角不大于5°，俯角不大于15°
        return NO;
    }
    
    return YES;
}

/* 是否夸张 */
-(BOOL)isExaggeration:(int)index{
    float expression[46] ;
    [FURenderer getFaceInfo:index name:@"expression" pret:expression number:46];
    
    for (int i = 0 ; i < 46; i ++) {
        
        if (expression[i] > 0.60) {
            
            return YES;
        }
    }
    return NO;
}


#pragma mark -  其他

/** 根据证书判断权限
 *  有权限的排列在前，没有权限的在后
 */
- (void)setupItemDataSource
{
    
    NSMutableArray *totalArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dataSource.plist" ofType:nil]];
    
    NSInteger count = dataArray.count;
    for (int i = 0 ; i < count; i ++) {
        NSMutableArray *modesArray = [NSMutableArray array];
        NSArray *tempArray = (NSArray *)dataArray[i];
        for (int j = 0; j < tempArray.count; j ++) {
             NSDictionary *dict = tempArray[j] ;
             FULiveModel *model = [[FULiveModel alloc] init];
             NSString *itemName = dict[@"itemName"] ;
             model.title = itemName ;
            model.maxFace = [dict[@"maxFace"] integerValue] ;
             model.enble = NO;
            model.type = [dict[@"itemType"] intValue];
            model.modules = dict[@"modules"] ;
            model.items = dict[@"items"] ;
            model.conpareCode = [dict[@"conpareCode"] intValue];
            [modesArray addObject:model];
        }
        [totalArray addObject:modesArray];
        
    }
    
    int module = fuGetModuleCode(0);
    int module1 = fuGetModuleCode(1);
    
    
    _dataSource = [NSMutableArray arrayWithCapacity:1];
    for (NSMutableArray *array in totalArray) {
        NSMutableArray *mutArray = [NSMutableArray array];
        
        NSMutableArray *eablMutArray = [NSMutableArray array];
        
        NSMutableArray *unEablmutArray = [NSMutableArray array];
        for (FULiveModel *model in array) {
            
            model.enble = YES ;
            BOOL isEable = YES;
            for (NSNumber *num in model.modules) {
                
                /* 权限码：分前32位和后32位 不同功能需要区别判断下*/
                if (model.conpareCode == 0) {
                    isEable = (module & [num intValue]) > 0 ? YES:NO;
                }else{
                    isEable = (module1 & [num intValue]) > 0 ? YES:NO;
                }
                model.enble = model.enble && isEable;
            }
            
            if (model.enble) {
                [eablMutArray addObject:model];
            }else{
                [unEablmutArray addObject:model];
            }

        }
        
        [mutArray addObjectsFromArray:eablMutArray];
        [mutArray addObjectsFromArray:unEablmutArray];
        
        [_dataSource addObject:mutArray];
    }
    return ;
}


-(NSMutableArray<NSMutableArray<FULiveModel *>*> *)dataSource {
    
    return _dataSource ;
}


/**
 获取item的提示语
 
 @param item 道具名
 @return 提示语
 */
- (NSString *)hintForItem:(NSString *)item
{
    return self.hintDic[item];
}

#pragma mark -  重力感应
-(void)setupDeviceMotion{
    
    // 初始化陀螺仪
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;// 1s刷新一次
    
    if ([self.motionManager isDeviceMotionAvailable]) {
       [self.motionManager startAccelerometerUpdates];
         [self.motionManager startDeviceMotionUpdates];
    }
}

#pragma mark -  陀螺仪
-(BOOL)isDeviceMotionChange{
//    if (![FURenderer isTracking]) {
        CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration ;
        int orientation = 0;
        if (acceleration.x >= 0.75) {
            orientation = 3;
        } else if (acceleration.x <= -0.75) {
            orientation = 1;
        } else if (acceleration.y <= -0.75) {
            orientation = 0;
        } else if (acceleration.y >= 0.75) {
            orientation = 2;
        }
    
        if (self.deviceOrientation != orientation) {
            self.deviceOrientation = orientation ;
            

            return YES;
        }
//    }
    return NO;
}


@end
