//
//  NetworkManager.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NetworkSuccessBlock)(id responseObject);
typedef void (^NetworkFailureBlock)(NSError *error);

/// 网络请求单例：统一封装 AFHTTPSessionManager
/// 换后端时只需要改 baseURL / 在 Service 层换接口路径，业务代码不用动
@interface NetworkManager : NSObject

/// 全局唯一实例
+ (instancetype)sharedInstance;

/// 接口根地址（接网易云后改成网易云 API 地址）
@property (nonatomic, copy, readonly) NSString *baseURL;

/// 当前网络是否可用（启动时会先按不可用处理，监听就绪后更新）
@property (nonatomic, assign, readonly, getter=isReachable) BOOL reachable;

/// GET 请求
/// @param path 相对路径，如 @"search/track"
/// @param parameters 查询参数，可为 nil
- (nullable NSURLSessionDataTask *)GET:(NSString *)path
                            parameters:(nullable NSDictionary *)parameters
                               success:(nullable NetworkSuccessBlock)success
                               failure:(nullable NetworkFailureBlock)failure;

/// 用完整 URL 请求（跨域名时用）
- (nullable NSURLSessionDataTask *)GETWithURLString:(NSString *)urlString
                                         parameters:(nullable NSDictionary *)parameters
                                            success:(nullable NetworkSuccessBlock)success
                                            failure:(nullable NetworkFailureBlock)failure;

/// 取消所有在途请求（如页面消失时）
- (void)cancelAllRequests;

@end

NS_ASSUME_NONNULL_END
