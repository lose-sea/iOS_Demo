//
//  WeatherModel.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/15.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void) setUpData {
    self.CurrentWeatherModel = [[NSDictionary alloc] init];
    self.DailyWeatherModel = [[NSDictionary alloc] init];
    self.HourlyWeatherModel = [[NSDictionary alloc] init];
}

@end
