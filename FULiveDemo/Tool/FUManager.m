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
#import "FUMusicPlayer.h"

@interface FUManager ()
{
    //MARK: Faceunity
    int items[4];
    int frameID;
    
    NSDictionary *hintDic;
    
    NSDictionary *alertDic ;
}
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
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"v3.bundle" ofType:nil];
        
        /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
         还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
        [[FURenderer shareRenderer] setupWithDataPath:path authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
        // 开启表情跟踪优化功能
        NSData *animModelData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"anim_model.bundle" ofType:nil]];
        int res0 = fuLoadAnimModel((void *)animModelData.bytes, (int)animModelData.length);
        NSLog(@"fuLoadAnimModel %@",res0 == 0 ? @"failure":@"success" );

        NSData *arModelData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ardata_ex.bundle" ofType:nil]];
        
        
        int res1 = fuLoadExtendedARData((void *)arModelData.bytes, (int)arModelData.length);
        
        NSLog(@"fuLoadAnimModel %@",res1 == 0 ? @"failure":@"success" );
        
       [self setDefaultParameters];
        
        NSLog(@"faceunitySDK version:%@",[FURenderer getVersion]);
        
        hintDic = @{
                    @"future_warrior":@"张嘴试试",
                    @"jet_mask":@"鼓腮帮子",
                    @"sdx2":@"皱眉触发",
                    @"luhantongkuan_ztt_fu":@"眨一眨眼",
                    @"qingqing_ztt_fu":@"嘟嘴试试",
                    @"xiaobianzi_zh_fu":@"微笑触发",
                    @"xiaoxueshen_ztt_fu":@"吹气触发",
                    @"hez_ztt_fu":@"转头触发",
                    @"fu_lm_koreaheart":@"单手手指比心",
                    @"fu_zh_baoquan":@"双手抱拳",
                    @"fu_zh_hezxiong":@"双手合十",
                    @"fu_ztt_live520":@"双手比心",
                    @"ssd_thread_thumb":@"竖个拇指",
                    @"ssd_thread_six":@"比个六",
                    @"ssd_thread_cute":@"双拳靠近脸颊卖萌",
                    };
        
        alertDic = @{
                     @"armesh_ex":@"AR面具高精度版",
                     };
        
        [self loadItemDataSource];
        
    }
    
    return self;
}

/** 根据证书判断权限
 *  有权限的排列在前，没有权限的在后
 */
- (void)loadItemDataSource {
    
    NSMutableArray *modesArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dataSource.plist" ofType:nil]];
    
    for (NSDictionary *dict in dataArray) {
        
        FULiveModel *model = [[FULiveModel alloc] init];
        
        NSString *itemName = dict[@"itemName"] ;
        model.title = itemName ;
        model.maxFace = [dict[@"maxFace"] integerValue] ;
        model.enble = NO;
        model.imageName = itemName ;
        model.type = [dict[@"itemType"] integerValue];
        model.modules = dict[@"modules"] ;
        model.items = dict[@"items"] ;
        [modesArray addObject:model];
    }
    
    int module = fuGetModuleCode(0) ;
    
    if (!module) {
        
        _dataSource = [NSMutableArray arrayWithCapacity:1];
    
        for (FULiveModel *model in modesArray) {
    
            model.enble = YES ;
            model.imageName = [model.title stringByAppendingString:@"_selected"];
            [_dataSource addObject:model] ;
        }
        return ;
    }
    
    int insertIndex = 0;
    _dataSource = [modesArray mutableCopy];

    for (FULiveModel *model in modesArray) {
        
        if ([model.title isEqualToString:@"背景分割"] || [model.title isEqualToString:@"手势识别"]) {
            if ([self isLiteSDK]) {
                continue ;
            }
        }
        
        for (NSNumber *num in model.modules) {
            
            BOOL isEable = module & [num intValue] ;
            
            if (isEable) {

                [_dataSource removeObject:model];

                model.enble = YES ;
                model.imageName = [model.title stringByAppendingString:@"_selected"];

                [_dataSource insertObject:model atIndex:insertIndex] ;
                insertIndex ++ ;

                break ;
            }
        }

    }
}

/*设置默认参数*/
- (void)setDefaultParameters {
    
    self.filtersDataSource = @[@"origin", @"delta", @"electric", @"slowlived", @"tokyo", @"warm"];
    
    self.beautyFiltersDataSource = @[@"ziran", @"danya", @"fennen", @"qingxin", @"hongrun"];
    self.filtersCHName = @{@"ziran":@"自然", @"danya":@"淡雅", @"fennen":@"粉嫩", @"qingxin":@"清新", @"hongrun":@"红润"};
    
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//
//    self.selectedFilter         = [user objectForKey:@"selectedFilter"] ? [user objectForKey:@"selectedFilter"] : self.filtersDataSource[0] ;
//    self.selectedFilterLevel    = [user objectForKey:@"selectedFilterLevel"] ? [[user objectForKey:@"selectedFilterLevel"] doubleValue] : 0.5 ;
//    self.skinDetectEnable       = [user boolForKey:@"skinDetectEnable"] ? [user boolForKey:@"skinDetectEnable"] : NO ;
//    self.blurShape              = [user objectForKey:@"blurShape"] ? [[user objectForKey:@"blurShape"] integerValue] : 0 ;
//    self.blurLevel              = [user objectForKey:@"blurLevel"] ? [[user objectForKey:@"blurLevel"] doubleValue] : 0.3 ;
//    self.whiteLevel             = [user objectForKey:@"whiteLevel"] ? [[user objectForKey:@"whiteLevel"] doubleValue] : 0.3 ;
//    self.redLevel               = [user objectForKey:@"redLevel"] ? [[user objectForKey:@"redLevel"] doubleValue] : 0.3 ;
//    self.eyelightingLevel       = [user objectForKey:@"eyelightingLevel"] ? [[user objectForKey:@"eyelightingLevel"] doubleValue] : 0.0 ;
//    self.beautyToothLevel       = [user objectForKey:@"beautyToothLevel"] ? [[user objectForKey:@"beautyToothLevel"] doubleValue] : 0.0 ;
//
//    self.faceShape              = [user objectForKey:@"faceShape"] ? [[user objectForKey:@"faceShape"] integerValue] : 3 ;
//    self.enlargingLevel         = [user objectForKey:@"enlargingLevel"] ? [[user objectForKey:@"enlargingLevel"] doubleValue] : 0.3 ;
//    self.thinningLevel          = [user objectForKey:@"thinningLevel"] ? [[user objectForKey:@"thinningLevel"] doubleValue] : 0.3 ;
//
//    self.enlargingLevel_new     = [user objectForKey:@"enlargingLevel_new"] ? [[user objectForKey:@"enlargingLevel_new"] doubleValue] : 0.5 ;
//    self.thinningLevel_new      = [user objectForKey:@"thinningLevel_new"] ? [[user objectForKey:@"thinningLevel_new"] doubleValue] : 0.5 ;
//    self.jewLevel               = [user objectForKey:@"jewLevel"] ? [[user objectForKey:@"jewLevel"] doubleValue] : 0.4 ;
//    self.foreheadLevel          = [user objectForKey:@"foreheadLevel"] ? [[user objectForKey:@"foreheadLevel"] doubleValue] : 0.4 ;
//    self.noseLevel              = [user objectForKey:@"noseLevel"] ? [[user objectForKey:@"noseLevel"] doubleValue] : 0.3 ;
//    self.mouthLevel             = [user objectForKey:@"mouthLevel"] ? [[user objectForKey:@"mouthLevel"] doubleValue] : 0.4 ;
//
    self.selectedFilter         = self.filtersDataSource[0] ;
    self.selectedFilterLevel    = 0.5 ;
    
    self.skinDetectEnable       = YES ;
    self.blurShape              = 0 ;
    self.blurLevel              = 0.7 ;
    self.whiteLevel             = 0.5 ;
    self.redLevel               = 0.5 ;
    
    self.eyelightingLevel       = 0.7 ;
    self.beautyToothLevel       = 0.7 ;
    
    self.faceShape              = 4 ;
    self.enlargingLevel         = 0.4 ;
    self.thinningLevel          = 0.4 ;
    
    self.enlargingLevel_new     = 0.4 ;
    self.thinningLevel_new      = 0.4 ;
    self.jewLevel               = 0.3 ;
    self.foreheadLevel          = 0.3 ;
    self.noseLevel              = 0.5 ;
    self.mouthLevel             = 0.4 ;
    
    self.enableGesture = NO;
    self.enableMaxFaces = NO;
}

-(NSArray<FULiveModel *> *)dataSource {
    
    return _dataSource ;
}


- (void)loadItems
{
    /**加载普通道具*/
    [self loadItem:self.selectedItem];
    
    /**加载美颜道具*/
    [self loadFilter];
}

- (void)setEnableGesture:(BOOL)enableGesture
{
    _enableGesture = enableGesture;
    /**开启手势识别*/
    if (_enableGesture) {
        [self loadGesture];
    }else{
        if (items[2] != 0) {
            
            NSLog(@"faceunity: destroy gesture");
            
            [FURenderer destroyItem:items[2]];
            
            items[2] = 0;
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

/**销毁全部道具*/
- (void)destoryItems
{
    [FURenderer destroyAllItems];
    
    /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
    for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
        items[i] = 0;
    }
    
    /**销毁道具后，清除context缓存*/
    [FURenderer OnDeviceLost];
    
    /**销毁道具后，重置人脸检测*/
    [FURenderer onCameraChange];
    
//    /**销毁道具后，重置默认参数*/
//    [self setDefaultParameters];
    
}

/**
 获取item的提示语

 @param item 道具名
 @return 提示语
 */
- (NSString *)hintForItem:(NSString *)item
{
    return hintDic[item];
}

- (NSString *)alertForItem:(NSString *)item {
    return alertDic[item] ;
}


- (void)setCalibrating {
    
    fuSetExpressionCalibration(1) ;
}

- (void)removeCalibrating {
    
    fuSetExpressionCalibration(0) ;
}



- (BOOL)isCalibrating{
    float is_calibrating[1] = {0.0};
    
    fuGetFaceInfo(0, "is_calibrating", is_calibrating, 1);
    return is_calibrating[0] == 1.0;
}


- (void)loadAnimojiFaxxBundle {
    /**先创建道具句柄*/
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa.bundle" ofType:nil];
    int itemHandle = [FURenderer itemWithContentsOfFile:path];
    
    /**销毁老的道具句柄*/
    if (items[3] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[3]];
    }
    
    /**将刚刚创建的句柄存放在items[1]中*/
    items[3] = itemHandle;
}

- (void)destoryAnimojiFaxxBundle {
    
    /**销毁老的道具句柄*/
    if (items[3] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[3]];
        items[3] = 0 ;
    }
    
}
#pragma -Faceunity Load Data
/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName
{
    /**如果取消了道具的选择，直接销毁道具*/
    if ([itemName isEqual: @"noitem"] || itemName == nil)
    {
        if (items[1] != 0) {
            
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[1]];
            
            /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[1]设为0*/
            items[1] = 0;
        }
        
        return;
    }
    
    /**先创建道具句柄*/
    NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
    int itemHandle = [FURenderer itemWithContentsOfFile:path];

    [FURenderer itemSetParam:itemHandle withName:@"is3DFlipH" value:@(1)];
    [FURenderer itemSetParam:itemHandle withName:@"isFlipExpr" value:@(1)];
    
    /**销毁老的道具句柄*/
    if (items[1] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[1]];
    }
    
    /**将刚刚创建的句柄存放在items[1]中*/
    items[1] = itemHandle;
    
    NSLog(@"faceunity: load item");
}

/**加载美颜道具*/
- (void)loadFilter
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];

    items[0] = [FURenderer itemWithContentsOfFile:path];
}

/**加载手势识别道具，默认未不加载*/
- (void)loadGesture
{
    if (items[2] != 0) {
        
        NSLog(@"faceunity: destroy gesture");
        
        [FURenderer destroyItem:items[2]];
        
        items[2] = 0;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"heart_v2.bundle" ofType:nil];
    
    items[2] = [FURenderer itemWithContentsOfFile:path];
}

/**设置美颜参数*/
- (void)setBeautyParams {
    
    if (self.faceShape == 4) {
        [FURenderer itemSetParam:items[0] withName:@"facewarp_version" value:@(1)]; //新版美颜
        
        [FURenderer itemSetParam:items[0] withName:@"face_shape" value:@(3)]; //美型类型 (0、1、2、3) 默认：3，女神：0，网红：1，自然：2
        [FURenderer itemSetParam:items[0] withName:@"eye_enlarging" value:@(self.enlargingLevel_new)]; //大眼 (0~1)
        [FURenderer itemSetParam:items[0] withName:@"cheek_thinning" value:@(self.thinningLevel_new)]; //瘦脸 (0~1)
        
        [FURenderer itemSetParam:items[0] withName:@"intensity_chin" value:@(self.jewLevel)]; /**下巴 (0~1)*/
        [FURenderer itemSetParam:items[0] withName:@"intensity_nose" value:@(self.noseLevel)];/**鼻子 (0~1)*/
        [FURenderer itemSetParam:items[0] withName:@"intensity_forehead" value:@(self.foreheadLevel)];/**额头 (0~1)*/
        [FURenderer itemSetParam:items[0] withName:@"intensity_mouth" value:@(self.mouthLevel)];/**嘴型 (0~1)*/
    }else {
        
        [FURenderer itemSetParam:items[0] withName:@"facewarp_version" value:@(0)]; //老版美颜
        
        [FURenderer itemSetParam:items[0] withName:@"face_shape" value:@(self.faceShape)]; //美型类型 (0、1、2、3) 默认：3，女神：0，网红：1，自然：2
        [FURenderer itemSetParam:items[0] withName:@"eye_enlarging" value:@(self.enlargingLevel)]; //大眼 (0~1)
        [FURenderer itemSetParam:items[0] withName:@"cheek_thinning" value:@(self.thinningLevel)]; //瘦脸 (0~1)
        
        [FURenderer itemSetParam:items[0] withName:@"intensity_chin" value:@(0)]; /**下巴 (0~1)*/
        [FURenderer itemSetParam:items[0] withName:@"intensity_nose" value:@(0)];/**鼻子 (0~1)*/
        [FURenderer itemSetParam:items[0] withName:@"intensity_forehead" value:@(0)];/**额头 (0~1)*/
        [FURenderer itemSetParam:items[0] withName:@"intensity_mouth" value:@(0)];/**嘴型 (0~1)*/
    }
    
    [FURenderer itemSetParam:items[0] withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:items[0] withName:@"heavy_blur" value:@(self.blurShape)]; // 美肤类型 (0、1、) 清晰：0，朦胧：1
    [FURenderer itemSetParam:items[0] withName:@"blur_level" value:@(self.blurLevel * 6.0 )]; //磨皮 (0.0 - 6.0)
    [FURenderer itemSetParam:items[0] withName:@"color_level" value:@(self.whiteLevel)]; //美白 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"red_level" value:@(self.redLevel)]; //红润 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"eye_bright" value:@(self.eyelightingLevel)]; // 亮眼
    [FURenderer itemSetParam:items[0] withName:@"tooth_whiten" value:@(self.beautyToothLevel)];// 美牙
    
    [FURenderer itemSetParam:items[0] withName:@"filter_name" value:self.selectedFilter]; //滤镜名称
    [FURenderer itemSetParam:items[0] withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
}

/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    /**设置美颜参数*/
    [self setBeautyParams];
    
    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/
    CVPixelBufferRef buffer = [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    
    return buffer;
}

- (void)set3DFlipH {
    
    [FURenderer itemSetParam:items[1] withName:@"is3DFlipH" value:@(1)];
    [FURenderer itemSetParam:items[1] withName:@"isFlipExpr" value:@(1)];
}

- (void)setLoc_xy_flip {
    
    [FURenderer itemSetParam:items[1] withName:@"loc_x_flip" value:@(1)];
    [FURenderer itemSetParam:items[1] withName:@"loc_y_flip" value:@(1)];
}

- (void)musicFilterSetMusicTime {
    
    [FURenderer itemSetParam:items[1] withName:@"music_time" value:@([FUMusicPlayer sharePlayer].currentTime * 1000 + 50)];//需要加50ms的延迟
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
    centerX = frameSize.width - centerX;
    centerX = centerX / frameSize.width;
    
    centerY = frameSize.height - centerY;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks
{
    int ret = [FURenderer getFaceInfo:0 name:@"landmarks" pret:landmarks number:150];
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
}

/**判断是否检测到人脸*/
- (BOOL)isTracking
{
    return [FURenderer isTracking] > 0;
}

/**切换摄像头要调用此函数*/
- (void)onCameraChange
{
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


- (NSString *)getPlatformtype {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
