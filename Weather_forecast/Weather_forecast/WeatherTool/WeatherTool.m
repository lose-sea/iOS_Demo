//
//  WeatherTool.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/20.
//

#import "WeatherTool.h"

@implementation WeatherTool

+ (NSString *)descriptionForWeatherCode:(NSInteger)code {
    // 0: 晴天
    if (code == 0) return @"晴";
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
    return @"未知天气";
}

+ (UIImage*) backImageForWeatherCode: (NSInteger) weather_code {
    switch (weather_code) {
        case 0:
            return [UIImage imageNamed: @"3.jpg"];
        case 1:
        case 2:
        case 3:
        case 45:
        case 48:
            return [UIImage imageNamed: @"1.jpg"];
        default:
            return [UIImage imageNamed: @"2.jpg"];
    }
}

+ (UIImage*) imageForWeatherCode: (NSInteger) weather_code {
    switch (weather_code) {
        case 0:
            return [UIImage systemImageNamed: @"sun.min.fill"];
        case 1:
        case 2:
        case 3:
            return [UIImage systemImageNamed: @"cloud.fill"];
        case 45:
        case 48:
            return [UIImage systemImageNamed: @"cloud.fog.fill"];
            
        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
            return [UIImage systemImageNamed: @"cloud.sun.rain.fill"];

        case 56:
        case 57:
            return [UIImage systemImageNamed: @"cloud.sleet.fill"];

        case 61:
        case 62:
        case 63:
        case 64:
        case 65:
            return [UIImage systemImageNamed: @"cloud.heavyrain.fill"];

        case 66:
        case 67:
            return [UIImage systemImageNamed: @"cloud.sleet.fill"];

        case 71:
        case 72:
        case 73:
        case 74:
        case 75:
            return [UIImage systemImageNamed: @"cloud.snow.fill"];

        case 77:
            return [UIImage systemImageNamed: @"cloud.snow.fill"];

        case 80:
        case 81:
        case 82:
            return [UIImage systemImageNamed: @"cloud.bolt.rain"];

        case 85:
        case 86:
            return [UIImage systemImageNamed: @"cloud.snow.fill"];

        case 95:
        case 96:
        case 97:
        case 98:
        case 99:
            return [UIImage systemImageNamed: @"cloud.bolt.fill"];

        default:
            return [UIImage systemImageNamed: @"cloud.fog.fill"];

    }
}

@end
