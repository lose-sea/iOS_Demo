//
//  ViewController.m
//  网络请求
//
//  Created by lose_sea on 2026/8/3.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "Model.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor systemCyanColor]];
    // Do any additional setup after loading the view.
//    [self createURL];

    [self createAFNetworkingGET];
        
//    [self createAFNetworkingPOST];
}



// 使用AFNetworking创建网路请求
- (void) createAFNetworkingGET {
    // 创建管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    // 设置超时时间 对应原生的 request.timeoutInterval
    manager.requestSerializer.timeoutInterval = 15;
    
    // 设置响应格式 默认为JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    // 拆解 URL 参数
    NSDictionary* parameters = @{@"key": @"3557d02150d248e6b0735224252907", @"q": @"西安", @"days": @"1"};
    
    //发起GET请求
    [manager GET: @"https://api.weatherapi.com/v1/forecast.json"
      parameters: parameters
         headers: nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        Model* model = [Model yy_modelWithJSON: responseObject];
    
        NSLog(@"打印的数据");
        NSLog(@"%f", model.current.temp_c);
        NSLog(@"%@", model.location);
        NSLog(@"%@", model.location.name);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSLog(@"请求失败");
    }];
}






- (void) createAFNetworkingPOST {
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    
    NSDictionary* parameters = @{@"title": @"exersice",
                                 @"body": @"hello xinyan",
                                 @"userId": @"1"};
    
    [manager POST: @"https://jsonplaceholder.typicode.com/posts"
       parameters: parameters
          headers: nil
         progress: nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            NSLog(@"POST 请求成功, 返回数据: %@", responseObject);

            NSLog(@"任务是 %@", task);
        
            // 你可以在这里尝试取出服务器返回的 id
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSNumber *newId = responseObject[@"id"];
                NSLog(@"创建资源的 ID 是: %@", newId);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
}



















// 原生 NSURLSession
- (void) createURL {
    // 创建请求地址
    NSString* str = @"https://api.weatherapi.com/v1/forecast.json?key=3557d02150d248e6b0735224252907&q=西安&days=1";
    NSURL* url = [NSURL URLWithString: str];
    
    // 创建请求类
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    // HTTP 方法
    request.HTTPMethod = @"GET";
    // 时间阈值
    request.timeoutInterval = 15;
    
    // 配置会话
        // 使用默认配置
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 创建会话
    NSURLSession* session = [NSURLSession sessionWithConfiguration: config
                                                          delegate: nil
                                                     delegateQueue: [NSOperationQueue mainQueue]];

    // 创建任务
        // 通过URL 进行创建
//    NSURLSessionDataTask* task = [session dataTaskWithURL: url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//    }];
    
        // 通过 Request 创建
    NSURLSessionDataTask* task = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败: %@", error);
        } else {
            NSError* jsonError = nil;
            // 调用苹果原生 API 将服务器返回的二进制数据 (NSData) 转换为 Objective-C对象
            // 传入错误指针的地址, 如果二进制数据不是合法的 JSON 格式（比如缺了一个引号，或者是 HTML 报错页），jsonError 就会被赋值为一个包含具体错误原因的对象，而方法本身会返回 nil。
            id dict = [NSJSONSerialization JSONObjectWithData: data options:0 error: &jsonError];
            if (jsonError) {
                NSLog(@"JSON 解析失败");
            } else {
                NSLog(@"%@", dict);
            }
        }
    }];
    
    [task resume];
}

@end
