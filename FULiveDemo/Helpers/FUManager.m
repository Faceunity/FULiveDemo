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
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSString *controllerPath = [[NSBundle mainBundle] pathForResource:@"controller_cpp" ofType:@"bundle"];
    NSString *controllerConfigPath = [[NSBundle mainBundle] pathForResource:@"controller_config" ofType:@"bundle"];
    FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
    setupConfig.authPack = FUAuthPackMake(g_auth_package, sizeof(g_auth_package));
    setupConfig.controllerPath = controllerPath;
    setupConfig.controllerConfigPath = controllerConfigPath;
    
    // 初始化 FURenderKit
    [FURenderKit setupWithSetupConfig:setupConfig];
    
    [FURenderKit setLogLevel:FU_LOG_LEVEL_INFO];
    // 算法耗时统计
//    [FURenderKit setupFrameTimeProfileEnable:YES];
//    // 算法耗时统计输出到控制台
//    [FURenderKit setupFrameTimeProfileAutoReportToConsole];
//    // 算法耗时统计输出到文件
//    [FURenderKit setupFrameTimeProfileAutoReportToFile:[FUDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"FUFrameTime %@.txt", FUCurrentDateString()]]];
        
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 加载人脸 AI 模型
        NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
        [FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];
        
        // 加载身体 AI 模型
        NSString *bodyAIPath = [[NSBundle mainBundle] pathForResource:@"ai_human_processor" ofType:@"bundle"];
        [FUAIKit loadAIModeWithAIType:FUAITYPE_HUMAN_PROCESSOR dataPath:bodyAIPath];
        
        NSString *handAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hand_processor" ofType:@"bundle"];
        [FUAIKit loadAIModeWithAIType:FUAITYPE_HANDGESTURE dataPath:handAIPath];
        
        NSString *hairAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hairseg" ofType:@"bundle"];
        [FUAIKit loadAIModeWithAIType:FUAITYPE_HANDGESTURE dataPath:hairAIPath];
        
        [FURenderKit shareRenderKit].internalCameraSetting.fps = 30;
        
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tongue" ofType:@"bundle"];
        [FUAIKit loadTongueMode:path];
        
        //TODO: todo 是否需要用？？？？？
        /* 设置嘴巴灵活度 默认= 0*/ //
        float flexible = 0.5;
        [FUAIKit setFaceTrackParam:@"mouth_expression_more_flexible" value:flexible];
        NSLog(@"---%lf",endTime);
        
        // 设置人脸算法质量
        [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
        
        // 设置小脸检测是否打开
        [FUAIKit shareKit].faceProcessorDetectSmallFace = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
    });
}

@end
