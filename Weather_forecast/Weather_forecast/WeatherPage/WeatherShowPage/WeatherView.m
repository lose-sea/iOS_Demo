//
//  WeatherView.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "WeatherView.h"

@implementation WeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init{
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.right.bottom.mas_equalTo(self);
    }];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"2.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.tableView registerClass: [TemperatureCell class] forCellReuseIdentifier: @"TemperatureCellID"];
    [self.tableView registerClass: [ScrollHourCell class] forCellReuseIdentifier: @"ScrollHourCellID"]; 
    [self.tableView registerClass: [DailyCell class] forCellReuseIdentifier: @"DailyCellID"];
    
    
}

- (void) configWithCurrentWeather:(NSDictionary *)currentWeather {
    NSInteger weather_code = [currentWeather[@"weather_code"] intValue];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage: [WeatherTool backImageForWeatherCode: weather_code]]; 
}

@end
