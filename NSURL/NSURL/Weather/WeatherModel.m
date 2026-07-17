//
//  WeatherModel.m
//  NSURL
//
//  Created by lose_sea on 2026/7/15.
//

#import "WeatherModel.h"

@implementation WeatherModel

#pragma mark - 初始化方法

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        // 从字典中解析数据（注意字段名与 API 返回的 key 对应）
        // 这里假设传入的是当前天气的 current 字典，同时也可以传入 city 信息
        
        // 当前温度
        id tempObj = dict[@"temperature_2m"];
        if ([tempObj isKindOfClass:[NSNumber class]]) {
            _temperature = [tempObj doubleValue];
        } else if ([tempObj isKindOfClass:[NSString class]]) {
            _temperature = [(NSString *)tempObj doubleValue];
        }
        
        // 天气代码
        id codeObj = dict[@"weather_code"];
        if ([codeObj isKindOfClass:[NSNumber class]]) {
            _weatherCode = [codeObj integerValue];
        } else if ([codeObj isKindOfClass:[NSString class]]) {
            _weatherCode = [(NSString *)codeObj integerValue];
        }
        
        // 当前时间
        id timeObj = dict[@"time"];
        if ([timeObj isKindOfClass:[NSString class]]) {
            _time = timeObj;
        }
        
        // 自动生成天气描述
        _weatherDescription = [WeatherModel descriptionForWeatherCode:_weatherCode];
        
        // 若字典中还包含每日最高/最低温，可额外解析（此处示例不包含，可在外部设置）
        // 通常 daily 数据需要单独处理，这里留空，由调用者赋值
    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

#pragma mark - 天气代码映射（基于 open-meteo 官方代码）
// 参考：https://open-meteo.com/en/docs
+ (NSString *)descriptionForWeatherCode:(NSInteger)code {
    // 0: 晴天
    if (code == 0) return @"晴天";
    // 1,2,3: 多云
    if (code >= 1 && code <= 3) return @"多云";
    // 45,48: 雾
    if (code == 45 || code == 48) return @"雾";
    // 51,53,55: 毛毛雨
    if (code >= 51 && code <= 55) return @"毛毛雨";
    // 56,57: 冻毛毛雨
    if (code == 56 || code == 57) return @"冻毛毛雨";
    // 61,63,65: 雨
    if (code >= 61 && code <= 65) return @"雨";
    // 66,67: 冻雨
    if (code == 66 || code == 67) return @"冻雨";
    // 71,73,75: 雪
    if (code >= 71 && code <= 75) return @"雪";
    // 77: 雪粒
    if (code == 77) return @"雪粒";
    // 80,81,82: 阵雨
    if (code >= 80 && code <= 82) return @"阵雨";
    // 85,86: 阵雪
    if (code == 85 || code == 86) return @"阵雪";
    // 95,96,99: 雷暴
    if (code >= 95 && code <= 99) return @"雷暴";
    return @"未知";
}

#pragma mark - 便于调试
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> 城市:%@ 温度:%.1f° 天气:%@ 最高:%.1f 最低:%.1f",
            NSStringFromClass([self class]), self,
            self.cityName ?: @"未知",
            self.temperature,
            self.weatherDescription ?: @"未知",
            self.maxTemp,
            self.minTemp];
}

@end
