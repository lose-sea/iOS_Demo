//
//  NetworkManager.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kDefaultBaseURL = @"https://openapi.music.163.com";   // 网易云开放平台
static NSString * const kNetworkErrorDomain = @"com.spotify.network.error";

@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, copy, readwrite) NSString *baseURL;
@property (nonatomic, assign, readwrite, getter=isReachable) BOOL reachable;

@end

@implementation NetworkManager

+ (instancetype)sharedInstance {
    static NetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseURL = kDefaultBaseURL;
        _reachable = YES;   // 监听就绪前先放行，避免首屏请求被误判为断网

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 15.0;
        configuration.timeoutIntervalForResource = 30.0;

        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:_baseURL]
                                                  sessionConfiguration:configuration];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];

        // 部分接口会返回 text/html / text/plain，这里一并接受
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                     @"application/json",
                                                     @"text/json",
                                                     @"text/javascript",
                                                     @"text/html",
                                                     @"text/plain", nil];
        _sessionManager.responseSerializer = responseSerializer;

        __weak typeof(self) weakSelf = self;
        [_sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachable = (status == AFNetworkReachabilityStatusReachableViaWWAN ||
                                  status == AFNetworkReachabilityStatusReachableViaWiFi);
        }];
        [_sessionManager.reachabilityManager startMonitoring];
    }
    return self;
}

#pragma mark - Public

- (NSURLSessionDataTask *)GET:(NSString *)path
                   parameters:(NSDictionary *)parameters
                      success:(NetworkSuccessBlock)success
                      failure:(NetworkFailureBlock)failure {
    if (!self.isReachable) {
        NSLog(@"[Network] 当前无网络：%@", path);
        if (failure) {
            failure([NSError errorWithDomain:kNetworkErrorDomain
                                        code:-1009
                                    userInfo:@{NSLocalizedDescriptionKey: @"当前无网络连接"}]);
        }
        return nil;
    }

    return [self.sessionManager GET:path
                         parameters:parameters
                            headers:nil
                           progress:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) success(responseObject);
    }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"[Network] 请求失败：%@ error=%@", path, error.localizedDescription);
        if (failure) failure(error);
    }];
}

// 绝对 URL 交给 AFN 时会忽略 baseURL，可以跨域名复用同一个 session
- (NSURLSessionDataTask *)GETWithURLString:(NSString *)urlString
                               parameters:(NSDictionary *)parameters
                                  success:(NetworkSuccessBlock)success
                                  failure:(NetworkFailureBlock)failure {
    return [self GET:urlString parameters:parameters success:success failure:failure];
}

- (void)cancelAllRequests {
    [self.sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

@end
