//
//  ViewController.m
//  网络请求
//
//  Created by lose_sea on 2026/8/3.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void) createURL {
    
    // 创建请求地址
    NSString* str = @"https://your-api.com/login?username=testuser&password=123456";
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
        
    }];
    
}
@end
