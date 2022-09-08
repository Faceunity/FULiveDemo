//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import "authpack.h"

static FUManager *shareManager = NULL;

@interface FUManager ()

@property (nonatomic, assign) FUDevicePerformanceLevel devicePerformanceLevel;

@end

@implementation FUManager

+ (FUManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    
    return shareManager;
}

- (void)setupRenderKit {

    NSString *controllerPath = [[NSBundle mainBundle] pathForResource:@"controller_cpp" ofType:@"bundle"];
    NSString *controllerConfigPath = [[NSBundle mainBundle] pathForResource:@"controller_config" ofType:@"bundle"];
    FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
    setupConfig.authPack = FUAuthPackMake(g_auth_package, sizeof(g_auth_package));
    setupConfig.controllerPath = controllerPath;
    setupConfig.controllerConfigPath = controllerConfigPath;
    
    // 初始化 FURenderKit
    [FURenderKit setupWithSetupConfig:setupConfig];
    // [FURenderKit setupInternalCheckPackageBindWithSetupConfig:setupConfig];
    
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

- (void)setDevicePerformanceDetails {
    // 设置人脸算法质量
    [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = self.devicePerformanceLevel == FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
    // 设置小脸检测是否打开
    [FUAIKit shareKit].faceProcessorDetectSmallFace = self.devicePerformanceLevel == FUDevicePerformanceLevelHigh;
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

+ (void)updateBeautyBlurEffect {
    if (![FURenderKit shareRenderKit].beauty || ![FURenderKit shareRenderKit].beauty.enable) {
        return;
    }
    if ([FUManager shareManager].devicePerformanceLevel == FUDevicePerformanceLevelHigh) {
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

+ (void)clearItems {
    [FUAIKit unloadAllAIMode];
    [FURenderKit clear];
}

@end
