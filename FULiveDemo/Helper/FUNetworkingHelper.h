//
//  FUNetworkingHelper.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/15.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUNetworkStatus) {
    FUNetworkStatusUnknown,         // 未知网络
    FUNetworkStatusUnreachable,     // 无网络
    FUNetworkStatusReachable        // 正常网络
};

/// 网络状态block
typedef void (^FUNetworkStatusHandler)(FUNetworkStatus status);

/// 请求成功block
typedef void (^FURequestSuccess)(id responseObject);

/// 请求失败block
typedef void (^FURequestFailure)(NSError *error);

/// 请求进度block
typedef void (^FURequestProgress)(NSProgress *progress);

@interface FUNetworkingHelper : NSObject

+ (instancetype)sharedInstance;

/// 获取实时网络状态
+ (FUNetworkStatus)currentNetworkStatus;

/// 网络状态变化
+ (void)networkStatusHandler:(FUNetworkStatusHandler)networkStatus;

/// GET请求
/// @param URLString 请求URL
/// @param parameters 请求参数
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionTask *)getWithURL:(NSString *)URLString
                      parameters:(nullable NSDictionary *)parameters
                         success:(FURequestSuccess)success
                         failure:(FURequestFailure)failure;

/// POST请求
/// @param URLString 请求URL
/// @param parameters 请求参数
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionTask *)postWithURL:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(FURequestSuccess)success
                          failure:(FURequestFailure)failure;

/// DOWNLOAD请求
/// @param URLString 请求URL
/// @param fileName 保存文件名
/// @param directoryPath 保存文件路径（默认为Documents路径）
/// @param progress 下载进度回调
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URLString
                                directoryPath:(nullable NSString *)directoryPath
                                     fileName:(nullable NSString *)fileName
                                     progress:(FURequestProgress)progress
                                      success:(FURequestSuccess)success
                                      failure:(FURequestFailure)failure;

/// 取消所有HTTP请求
- (void)cancelAllHttpRequests;

/// 取消指定URL的请求
- (void)cancelHttpRequestWithURL:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
