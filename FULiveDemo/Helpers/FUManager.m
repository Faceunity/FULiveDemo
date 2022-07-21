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

+ (void)loadAIModelWithModuleType:(FULiveModelType)moduleType {
    [self loadFaceAIModel];
    switch (moduleType) {
        case FULiveModelTypeBody:
        case FULiveModelTypeWholeAvatar:
        case FULiveModelTypeBGSegmentation:{
            [self loadHumanAIModel];
        }
            break;
        case FULiveModelTypeGestureRecognition:
        case FULiveModelTypeQSTickers:{
            [self loadHandAIModel];
            [self loadHumanAIModel];
        }
            break;
        default:
            break;
    }
    
    // 设置人脸算法质量
    [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
    
    // 设置小脸检测是否打开
    [FUAIKit shareKit].faceProcessorDetectSmallFace = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
}

@end
