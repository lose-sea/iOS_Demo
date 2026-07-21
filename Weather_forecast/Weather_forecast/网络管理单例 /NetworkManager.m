//
//  NetworkManager.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/21.
//

#import "NetworkManager.h"

@interface NetworkManager ()

/// 全局复用的 URLSession（配置了统一超时时间）
@property (nonatomic, strong) NSURLSession *session;

/// 存储所有正在运行的数据任务，Key 为完整 URL 字符串，Value 为 NSURLSessionDataTask
/// 该字典可能被多线程同时访问，必须通过串行队列保护。
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionDataTask *> *runningTasks;

/// 保护 runningTasks 的串行队列（保证字典读写线程安全）
@property (nonatomic, strong) dispatch_queue_t syncQueue;

@end



@implementation NetworkManager
 

#pragma mark - 单例创建
+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static NetworkManager* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];
    });
    return instance;
}

+ (instancetype) allocWithZone: (struct _NSZone*) zone {
    return [self sharedManager];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 15.0;
        self.session = [NSURLSession sessionWithConfiguration:config];

        self.runningTasks = [NSMutableDictionary dictionary];

        // 创建串行任务队列
        // 参数1: 队列的名字
        // 参数2: 串行属性
        self.syncQueue =dispatch_queue_create("com.weather.sync",DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (id) copyWithZone: (NSZone*) zone {
    return self;
}

- (id) mutableCopyWithZone: (NSZone*) zone {
    return self;
}
 


- (void) GET:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completion {
    
    NSMutableString* fullUrl = [NSMutableString stringWithString: urlString];
    
    if (parameters && parameters.count > 0) {
        [fullUrl appendString: @"?"];
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in parameters.allKeys) {
            id value = parameters[key];
            NSString* valueStr = [NSString stringWithFormat: @"%@", value];
            // URL编码
            NSString* encodeValue = [valueStr stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [pairs addObject: [NSString stringWithFormat: @"%@=%@", key, encodeValue]];
        }
        // 把所有的元素用指定分隔符粘成一个完整的字符串
        [fullUrl appendString: [pairs componentsJoinedByString: @"&"]];
    }
    
    // 取消相同的 URL 的旧请求
    [self cancelRequestForURL: fullUrl];
    
//    NSLog(@"开始请求：%@", fullUrl);

    
    // 创建URLRequest
    NSURL* url = [NSURL URLWithString: fullUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
        // HTTP方法
    request.HTTPMethod = @"GET";
        // 时间阈值
    request.timeoutInterval = 15;
    
    
    // 创建DataTask
    // __weak 弱引用
    // typeof(self) 在编译时自动推导self的具体类名
    // 将self的弱引用赋值给变量 weakSelf
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"收到服务器响应");
        // 无论成功, 任务结束后都从 runningTasks 中删除
        dispatch_sync(weakSelf.syncQueue, ^{
            [weakSelf.runningTasks removeObjectForKey: fullUrl];
        });
        
        
//        NSLog(@"网络错误：%@", error);
        
        if (error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, error); 
                }
            });
            return;
        }
        
        // 检查 HTTP 状态码
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            // 极少发生，兜底处理：当做成功但无数据返回
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(nil, nil);
            });
            return;
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                            // NSError 的错误域
            NSError* statusError = [NSError errorWithDomain: @"com.netword.status"
                                                       code: httpResponse.statusCode
                                                   userInfo: @{NSLocalizedDescriptionKey: [NSString stringWithFormat: @"HTTP Error %ld", (long)httpResponse.statusCode]}];
            // 网络请求默认在后台的子线程中进行
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, statusError);
                }
            });
            return;
        }
        
        // jSON 解析
        NSError* jsonError = nil;
        
        // 将服务器返回的原始二进制数据转换为可操作的字典对象
        // data: 服务器通过网路传回来的原始字节
        // options:
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: &jsonError];
        
        // 回到主线程执行业务回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(json, jsonError);
            }
        });
    }];
    
    dispatch_sync(self.syncQueue, ^{
        weakSelf.runningTasks[fullUrl] = task;
    });
    
    // 启动请求
    [task resume];
}


// 取消正在进行的请求

- (void)cancelRequestForURL:(nonnull NSString *)urlString {
    // dispatch_sync: GCD 同步派发函数
    // 将后面的任务(Block) 提交到指定的对列, 并阻塞当前的线程, 直到 Block 执行完毕才继续往下走
    
    //参数1: 指定任务要在哪一个队列上进行
    // 所有对可变字典 self.runningTasks 的访问（增、删、改、查）都必须排着队在这个队列上执行，从而避免多线程同时操作 NSMutableDictionary 导致的崩溃或数据错乱
    dispatch_sync(self.syncQueue, ^{
        // 取出对应的任务对象
        NSURLSessionDataTask* task = self.runningTasks[urlString];
        // 判断任务是否正在传输
        if (task && task.state == NSURLSessionTaskStateRunning) {
            // 修改对象的内部状态, 标记为取消状态
            [task cancel];
        }
        // 无论任务是否存在,都从字典移除 (不会取消底层的网络任务)
        [self.runningTasks removeObjectForKey: urlString];
    });
}


- (void) cancelAllRequests {
    dispatch_sync(self.syncQueue, ^{
        for (NSURLSessionDataTask* task in self.runningTasks.allValues) {
            if (task.state == NSURLSessionTaskStateRunning) {
                [task cancel];
            }
        }
        [self.runningTasks removeAllObjects];
    });
}




@end
