//
//  CityModel.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityModel : NSObject <NSCoding, NSSecureCoding>
@property (nonatomic, strong) NSString* cityName;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

// 城市唯一标识
// 在添加城市时进行比较
@property (nonatomic, strong) NSString* cityID;

- (instancetype) initWithName:(NSString*) name Latitude:(NSNumber*) latitude Longitude:(NSNumber*) longitude;
@end

NS_ASSUME_NONNULL_END
