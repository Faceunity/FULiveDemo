//
//  FURenderKitManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/22.
//

#import "FURenderKitManager.h"
#import "authpack.h"

@interface FURenderKitManager ()

@property (nonatomic, assign) FUDevicePerformanceLevel devicePerformanceLevel;

@property (nonatomic, copy) NSDictionary *configurations;

@end

@implementation FURenderKitManager

+ (instancetype)sharedManager {
    static FURenderKitManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FURenderKitManager alloc] init];
    });
    return instance;
}

- (void)setupRenderKit {
    [FURenderKit setLogLevel:FU_LOG_LEVEL_ERROR];
    
    FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
    setupConfig.authPack = FUAuthPackMake(g_auth_package, sizeof(g_auth_package));
    NSString *controllerPath = [[NSBundle mainBundle] pathForResource:@"controller_cpp" ofType:@"bundle"];
    if (controllerPath) {
        setupConfig.controllerPath = controllerPath;
    }
    // 初始化 FURenderKit
    [FURenderKit setupWithSetupConfig:setupConfig];
    
    // 设置缓存目录
    [FURenderKit setCacheDirectory:FUDocumentPath];
    // 算法耗时统计
//    [FURenderKit setFrameTimeProfileEnable:YES];
//    [FURenderKit setFrameTimeProfileReportDetailsEnable:YES];
//    // 算法耗时统计输出到控制台
//    [FURenderKit setFrameTimeProfileAutoReportToConsole];
//    // 算法耗时统计输出到文件
//    [FURenderKit setFrameTimeProfileAutoReportToFile:[FUDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"FUFrameTime %@.txt", FUCurrentDateString()]]];
    
    // 舌头
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tongue" ofType:@"bundle"];
    [FUAIKit loadTongueMode:path];
    
    self.devicePerformanceLevel = [FURenderKit devicePerformanceLevel];
    if (self.devicePerformanceLevel <= FUDevicePerformanceLevelLow) {
        // 打开动态质量
        [FURenderKit setDynamicQualityControlEnabled:YES];
    }
}

- (void)destoryRenderKit {
    [FURenderKit destroy];
}

- (void)setDevicePerformanceDetails {
    // 设置人脸算法质量
    [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = self.devicePerformanceLevel >= FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
    // 设置是遮挡是否使用高精度模型（人脸算法质量为High时才生效）
    [FUAIKit shareKit].faceProcessorSetFaceLandmarkHpOccu = NO ;
    
    // 设置小脸检测是否打开
    [FUAIKit shareKit].faceProcessorDetectSmallFace = self.devicePerformanceLevel >= FUDevicePerformanceLevelHigh;
}

+ (void)loadFaceAIModel {
    FUDevicePerformanceLevel level = [FURenderKitManager sharedManager].devicePerformanceLevel;
    FUFaceAlgorithmConfig config = FUFaceAlgorithmConfigEnableAll;
    if (level < FUDevicePerformanceLevelHigh) {
        // 关闭所有效果
        config = FUFaceAlgorithmConfigDisableAll;
    } else if (level < FUDevicePerformanceLevelVeryHigh) {
        // 关闭皮肤分割、祛斑痘和 ARMeshV2 人种分类
        config = FUFaceAlgorithmConfigDisableSkinSegAndDelSpot | FUFaceAlgorithmConfigDisableARMeshV2 | FUFaceAlgorithmConfigDisableRACE;
    } else if (level < FUDevicePerformanceLevelExcellent) {
        config = FUFaceAlgorithmConfigDisableSkinSeg;
    }
    [FUAIKit setFaceAlgorithmConfig:config];
    NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];
}

+ (void)loadHumanAIModel:(FUHumanSegmentationMode)mode {
    NSString *bodyAIPath = [[NSBundle mainBundle] pathForResource:@"ai_human_processor" ofType:@"bundle"];
    [FUAIKit loadAIHumanModelWithDataPath:bodyAIPath segmentationMode:mode];
}

+ (void)loadHandAIModel {
    NSString *handAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hand_processor" ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_HANDGESTURE dataPath:handAIPath];
}

+ (BOOL)faceTracked {
    return [FUAIKit aiFaceProcessorNums] > 0;
}

+ (BOOL)humanTracked {
    return [FUAIKit aiHumanProcessorNums] > 0;
}

+ (BOOL)handTracked {
    return [FUAIKit aiHandDistinguishNums] > 0;
}

+ (void)setMaxFaceNumber:(NSInteger)number {
    [FUAIKit shareKit].maxTrackFaces = (int)number;
}

+ (void)setMaxHumanNumber:(NSInteger)number {
    [FUAIKit shareKit].maxTrackBodies = (int)number;
}

+ (void)updateBeautyBlurEffect {
    if (![FURenderKit shareRenderKit].beauty || ![FURenderKit shareRenderKit].beauty.enable) {
        return;
    }
    if ([FURenderKitManager sharedManager].devicePerformanceLevel >= FUDevicePerformanceLevelHigh) {
        // 根据人脸置信度设置不同磨皮效果
        CGFloat score = [FUAIKit fuFaceProcessorGetConfidenceScore:0];
        if (score > 0.95) {
            [FURenderKit shareRenderKit].beauty.blurType = 3;
            [FURenderKit shareRenderKit].beauty.blurUseMask = YES;
        } else {
            [FURenderKit shareRenderKit].beauty.blurType = 2;
            [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
        }
    } else {
        // 设置精细磨皮效果
        [FURenderKit shareRenderKit].beauty.blurType = 2;
        [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
    }
}

+ (void)resetTrackedResult {
    [FUAIKit resetTrackedResult];
}

+ (void)setFaceProcessorDetectMode:(FUFaceProcessorDetectMode)mode {
    [FUAIKit shareKit].faceProcessorDetectMode = mode;
}

+ (void)setHumanProcessorDetectMode:(FUHumanProcessorDetectMode)mode {
    [FUAIKit shareKit].humanProcessorDetectMode = mode;
}

+ (void)clearItems {
    [FUAIKit unloadAllAIMode];
    [FURenderKit clear];
}

- (NSDictionary *)configurations {
    if (!_configurations) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test_configurations" ofType:@"plist"];
        _configurations = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _configurations;
}

- (BOOL)showsLandmarks {
    return [self.configurations[@"点位开关"] boolValue];
}

@end
