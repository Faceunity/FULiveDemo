//
//  FUNetworkingHelper.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/15.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUNetworkingHelper.h"

#import <AFNetworking.h>

//#ifdef DEBUG
//
//static NSString * const FUBaseURLString = @"http://192.168.0.122:8089/api/";
//
//#else
//
//static NSString * const FUBaseURLString = @"https://items.faceunity.com:4006/api/";
//
//#endif

//static NSString * const FUBaseURLString = @"http://192.168.0.122:8089/api/";
static NSString * const FUBaseURLString = @"https://items.faceunity.com:4006/api/";

@interface FUNetworkingHelper ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray<NSURLSessionTask *> *tasksArray;

@end

@implementation FUNetworkingHelper

+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (instancetype)sharedInstance {
    static FUNetworkingHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FUNetworkingHelper alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;

        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:FUBaseURLString] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.securityPolicy = policy;
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 60.0;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 默认acceptableContentTypes
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/zip", nil];
    }
    return self;
}

+ (FUNetworkStatus)currentNetworkStatus {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
        return FUNetworkStatusReachable;
    } else if (status == AFNetworkReachabilityStatusUnknown) {
        return FUNetworkStatusUnknown;
    } else {
        return FUNetworkStatusUnreachable;
    }
}

+ (void)networkStatusHandler:(FUNetworkStatusHandler)networkStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                !networkStatus ?: networkStatus(FUNetworkStatusUnknown);
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                !networkStatus ?: networkStatus(FUNetworkStatusUnreachable);
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                !networkStatus ?: networkStatus(FUNetworkStatusReachable);
            }
            default:
                break;
        }
    }];
}

- (NSURLSessionTask *)getWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters success:(FURequestSuccess)success failure:(FURequestFailure)failure {
    NSLog(@"\nURL:%@\nparams:%@", URLString, parameters);
    NSURLSessionTask *task = [self.manager GET:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"responseObject = %@", result);
        if ([result[@"code"] integerValue] == 2) {
            !success ?: success(result);
        } else {
            !failure ?: failure([NSError errorWithDomain:NSCocoaErrorDomain code:[result[@"code"] integerValue] userInfo:@{NSUnderlyingErrorKey : result[@"message"]}]);
        }
        [self.tasksArray removeObject:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        [self.tasksArray removeObject:task];
        !failure ?: failure(error);
    }];
    // 保存task
    !task ?: [self.tasksArray addObject:task];
    return task;
}

- (NSURLSessionTask *)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters success:(FURequestSuccess)success failure:(FURequestFailure)failure {
    NSLog(@"\nURL:%@\nparams:%@", URLString, parameters);
    NSURLSessionTask *task = [self.manager POST:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"responseObject = %@", result);
        if ([result[@"code"] integerValue] == 2) {
            !success ?: success(result);
        } else {
            !failure ?: failure([NSError errorWithDomain:NSCocoaErrorDomain code:[result[@"code"] integerValue] userInfo:@{NSUnderlyingErrorKey : result[@"message"]}]);
        }
        [self.tasksArray removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        [self.tasksArray removeObject:task];
        !failure ?: failure(error);
    }];
    // 保存task
    !task ?: [self.tasksArray addObject:task];
    return task;
}

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URLString directoryPath:(NSString *)directoryPath fileName:(NSString *)fileName progress:(FURequestProgress)progress success:(FURequestSuccess)success failure:(FURequestFailure)failure {
    NSLog(@"\nURL:%@", URLString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    __block NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"progress:%@", downloadProgress);
        dispatch_sync(dispatch_get_main_queue(), ^{
            !progress ?: progress(downloadProgress);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *directoryPathString = directoryPath ?: NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [directoryPathString stringByAppendingPathComponent:fileName ?: response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self.tasksArray removeObject:task];
        if (error) {
            NSLog(@"error = %@", error);
            !failure ?: failure(error);
            return;
        }
        NSLog(@"response = %@", response);
        !success ?: success(filePath);
    }];
    [task resume];
    
    // 保存task
    !task ?: [self.tasksArray addObject:task];
    return task;
}

- (void)cancelHttpRequestWithURL:(NSString *)URLString {
    if (!URLString) {
        return;
    }
    @synchronized (self) {
        [self.tasksArray enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.currentRequest.URL.absoluteString hasSuffix:URLString]) {
                [obj cancel];
                [self.tasksArray removeObject:obj];
                *stop = YES;
            }
        }];
    }
}

- (void)cancelAllHttpRequests {
    @synchronized (self) {
        [self.tasksArray enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj cancel];
        }];
        [self.tasksArray removeAllObjects];
    }
}

- (NSMutableArray<NSURLSessionTask *> *)tasksArray {
    if (!_tasksArray) {
        _tasksArray = [[NSMutableArray alloc] init];
    }
    return _tasksArray;
}

@end
