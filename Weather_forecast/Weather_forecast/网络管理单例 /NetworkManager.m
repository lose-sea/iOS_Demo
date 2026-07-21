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

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    static NetworkManager* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self; 
}


@end
