//
//  WeatherController.m
//  NSURL
//
//  Created by lose_sea on 2026/7/15.
//

#import "WeatherController.h"
#import "WeatherView.h"
#import "WeatherModel.h"
#import <Masonry/Masonry.h>

@interface WeatherController ()

@property (nonatomic, strong) WeatherView *weatherView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation WeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBlueColor];
    self.title = self.cityName ?: @"天气";
    
    // 创建 WeatherView
    self.weatherView = [[WeatherView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.weatherView];
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 添加加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.color = [UIColor whiteColor];
    self.loadingIndicator.center = self.view.center;
    [self.view addSubview:self.loadingIndicator];
    [self.loadingIndicator startAnimating];
    
    // 如果有经纬度，开始请求
    if (self.latitude != 0 || self.longitude != 0) {
        [self requestWeather];
    } else {
        // 没有数据，显示提示
        [self.loadingIndicator stopAnimating];
        self.weatherView.weatherLabel.text = @"未提供位置信息";
    }
}

#pragma mark - 网络请求

- (void)requestWeather {
    // 构建 URL
    NSString *urlString = [NSString stringWithFormat:
                           @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto",
                           self.latitude, self.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 15;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingIndicator stopAnimating];
        });
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weatherView.weatherLabel.text = @"网络请求失败";
                NSLog(@"请求失败: %@", error);
            });
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weatherView.weatherLabel.text = @"数据解析错误";
            });
            return;
        }
        
        // 解析数据
        NSDictionary *current = dict[@"current"];
        NSDictionary *daily = dict[@"daily"];
        
        // 创建模型
        WeatherModel *model = [[WeatherModel alloc] init];
        model.cityName = self.cityName ?: @"未知城市";
        
        // 当前温度
        id tempObj = current[@"temperature_2m"];
        if ([tempObj isKindOfClass:[NSNumber class]]) {
            model.temperature = [tempObj doubleValue];
        } else if ([tempObj isKindOfClass:[NSString class]]) {
            model.temperature = [(NSString *)tempObj doubleValue];
        }
        
        // 天气代码
        id codeObj = current[@"weather_code"];
        if ([codeObj isKindOfClass:[NSNumber class]]) {
            model.weatherCode = [codeObj integerValue];
        } else if ([codeObj isKindOfClass:[NSString class]]) {
            model.weatherCode = [(NSString *)codeObj integerValue];
        }
        
        // 时间
        if ([current[@"time"] isKindOfClass:[NSString class]]) {
            model.time = current[@"time"];
        }
        
        // 最高/最低温 (daily 是数组，取第一项)
        if (daily) {
            NSArray *maxArr = daily[@"temperature_2m_max"];
            NSArray *minArr = daily[@"temperature_2m_min"];
            if ([maxArr isKindOfClass:[NSArray class]] && maxArr.count > 0) {
                model.maxTemp = [maxArr[0] doubleValue];
            }
            if ([minArr isKindOfClass:[NSArray class]] && minArr.count > 0) {
                model.minTemp = [minArr[0] doubleValue];
            }
        }
        
        // 更新 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weatherView updateWithModel:model];
        });
    }];
    
    [task resume];
}

@end
