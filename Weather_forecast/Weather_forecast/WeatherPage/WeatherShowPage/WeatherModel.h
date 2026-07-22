//
//  WeatherModel.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/15.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic, strong) NSDictionary* CurrentWeatherModel;
@property (nonatomic, strong) NSDictionary* DailyWeatherModel;
@property (nonatomic, strong) NSDictionary* HourlyWeatherModel;

@end


