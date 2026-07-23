//
//  WeatherTool.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WeatherTool : NSObject
+ (NSString *)descriptionForWeatherCode:(NSInteger)code;
+ (UIImage*) backImageForWeatherCode: (NSInteger) weather_code;
+ (UIImage*) imageForWeatherCode: (NSInteger) weather_code;
+ (NSString*) windDirection: (NSNumber*) windDirection; 
@end

NS_ASSUME_NONNULL_END
