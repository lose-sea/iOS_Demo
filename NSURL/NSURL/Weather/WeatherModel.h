//
//  WeatherModel.h
//  NSURL
//
//  Created by lose_sea on 2026/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherModel : NSObject

// 城市信息
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *country;          // 国家/地区

// 当前天气
@property (nonatomic, copy) NSString *time;            // 当前时间（字符串）
@property (nonatomic, assign) CGFloat temperature;     // 当前温度（℃）
@property (nonatomic, assign) NSInteger weatherCode;   // 天气代码（open-meteo 标准）
@property (nonatomic, copy, nullable) NSString *weatherDescription; // 天气状况描述（晴、多云等）

// 每日温度范围
@property (nonatomic, assign) CGFloat maxTemp;
@property (nonatomic, assign) CGFloat minTemp;

// 便利构造方法
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

// 根据天气代码获取文字描述（类方法，也可用于外部）
+ (NSString *)descriptionForWeatherCode:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
