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
    FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
    setupConfig.authPack = FUAuthPackMake(g_auth_package, sizeof(g_auth_package));
    NSString *controllerPath = [[NSBundle mainBundle] pathForResource:@"controller_cpp" ofType:@"bundle"];
    NSString *controllerConfigPath = [[NSBundle mainBundle] pathForResource:@"controller_config" ofType:@"bundle"];
    setupConfig.controllerPath = controllerPath;
    setupConfig.controllerConfigPath = controllerConfigPath;
    
    // 初始化 FURenderKit
    [FURenderKit setupWithSetupConfig:setupConfig];
    
    [FURenderKit setLogLevel:FU_LOG_LEVEL_ERROR];
    
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
}

- (void)destoryRenderKit {
    [FURenderKit destroy];
}

- (void)setDevicePerformanceDetails {
    // 设置人脸算法质量
    [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = self.devicePerformanceLevel == FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
    // 设置小脸检测是否打开
    [FUAIKit shareKit].faceProcessorDetectSmallFace = self.devicePerformanceLevel == FUDevicePerformanceLevelHigh;
}

+ (void)start {
    [FURenderKit shareRenderKit].pause = NO;
}

+ (void)pause {
    [FURenderKit shareRenderKit].pause = YES;
}

+ (void)loadFaceAIModel {
    NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];
}

+ (void)loadHumanAIModel {
    // 加载身体 AI 模型，注意：高性能机型加载ai_human_processor_gpu.bundle
    NSString *humanBundleName = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh ? @"ai_human_processor_gpu" : @"ai_human_processor";
    NSString *bodyAIPath = [[NSBundle mainBundle] pathForResource:humanBundleName ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_HUMAN_PROCESSOR dataPath:bodyAIPath];
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
    if ([FURenderKitManager sharedManager].devicePerformanceLevel == FUDevicePerformanceLevelHigh) {
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
