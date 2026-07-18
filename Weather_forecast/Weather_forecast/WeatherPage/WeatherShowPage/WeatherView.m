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
    
    self.backButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: self.backButton];
    
    [self.backButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];

    self.backButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.left.mas_equalTo(self).offset(20);
        make.width.height.mas_equalTo(40);
    }];
    self.backButton.layer.cornerRadius = 20;
    self.backButton.clipsToBounds = YES;
    
    
    self.addButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: self.addButton];
    
    [self.addButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];

    self.addButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
        make.width.height.mas_equalTo(40);
    }];
    self.addButton.layer.cornerRadius = 20;
    self.addButton.clipsToBounds = YES;
}

- (void) configWithCurrentWeather:(NSDictionary *)currentWeather {
    NSInteger weather_code = [currentWeather[@"weather_code"] intValue];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage: [self imageForWeatherCode: weather_code]];
}

- (UIImage*) imageForWeatherCode: (NSInteger) weather_code {
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
@end
