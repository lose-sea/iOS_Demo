//
//  HourlyCell.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import "HourlyCell.h"

@implementation HourlyCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
//    self.backgroundColor = [UIColor systemRedColor];
//    self.contentView.backgroundColor = [UIColor systemCyanColor];
    self.timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
//    self.timeLabel.backgroundColor = [UIColor systemRedColor];
    
    self.weatherView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.weatherView];
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
//    self.weatherView.backgroundColor = [UIColor systemRedColor];
    
    self.weatherLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.weatherLabel];
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weatherView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
//    self.weatherLabel.backgroundColor = [UIColor systemCyanColor];
    
    self.hourTemperatureLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.hourTemperatureLabel];
    [self.hourTemperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weatherLabel.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    self.hourTemperatureLabel.textAlignment = NSTextAlignmentCenter;
//    self.hourTemperatureLabel.backgroundColor = [UIColor systemRedColor];
    
}

- (void) configWithHourlyWeather:(NSDictionary *)hourlyWeather withIndex:(NSInteger)item {
    NSString* timeStr = hourlyWeather[@"time"][item];
    timeStr = [timeStr substringFromIndex: 11];
    if ([timeStr characterAtIndex: 0] == '0') {
        timeStr = [timeStr substringFromIndex: 1];
    }
    self.timeLabel.text = timeStr;
    
    NSInteger weather_code = [hourlyWeather[@"weather_code"][item] intValue];
    self.weatherView.image = [self imageWithWeatherCode: weather_code];
    self.weatherView.tintColor = [UIColor labelColor];
    
    self.weatherLabel.text = [self descriptionForWeatherCode: weather_code];
    if (hourlyWeather[@"temperature_2m"][item]) {
        self.hourTemperatureLabel.text = [NSString stringWithFormat: @"%@°", hourlyWeather[@"temperature_2m"][item]];
    } else {
        self.hourTemperatureLabel.text = @"-- --";
    }
}

- (UIImage*) imageWithWeatherCode: (NSInteger) weather_code {
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

- (NSString *)descriptionForWeatherCode:(NSInteger)code {
    switch (code) {
        case 0:
            return @"晴";
            
        case 1:
        case 2:
        case 3:
            return @"多云";
            
        case 45:
        case 48:
            return @"雾";
            
        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
            return @"毛毛雨";
            
        case 56:
        case 57:
            return @"冻毛毛雨";
            
        case 61:
        case 62:
        case 63:
        case 64:
        case 65:
            return @"雨";
            
        case 66:
        case 67:
            return @"冻雨";
            
        case 71:
        case 72:
        case 73:
        case 74:
        case 75:
            return @"雪";
            
        case 77:
            return @"雪粒";
            
        case 80:
        case 81:
        case 82:
            return @"阵雨";
            
        case 85:
        case 86:
            return @"阵雪";
            
        case 95:
        case 96:
        case 97:
        case 98:
        case 99:
            return @"雷暴";
            
        default:
            return @"未知天气";
    }
}
 




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
