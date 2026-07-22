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

- (void) configWithHourlyWeather:(NSDictionary *)hourlyWeather startIndex:(NSInteger) startIndex withIndex:(NSInteger)item {

    NSString* timeStr = hourlyWeather[@"time"][item + startIndex];
    timeStr = [timeStr substringFromIndex: 11];
    if ([timeStr characterAtIndex: 0] == '0') {
        timeStr = [timeStr substringFromIndex: 1];
    }
    self.timeLabel.text = timeStr;
    
    NSInteger weather_code = [hourlyWeather[@"weather_code"][item + startIndex] intValue];
    self.weatherView.image = [WeatherTool imageForWeatherCode: weather_code];
    self.weatherView.tintColor = [UIColor labelColor];
    
    self.weatherLabel.text = [WeatherTool descriptionForWeatherCode: weather_code]; 
    if (hourlyWeather[@"temperature_2m"][item + startIndex]) {
        self.hourTemperatureLabel.text = [NSString stringWithFormat: @"%@°", hourlyWeather[@"temperature_2m"][item]];
    } else {
        self.hourTemperatureLabel.text = @"-- --";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
