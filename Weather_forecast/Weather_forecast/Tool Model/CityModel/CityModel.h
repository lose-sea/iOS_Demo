//
//  CityModel.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityModel : NSObject
@property (nonatomic, strong) NSString* cityName;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

- (instancetype) initWithName:(NSString*) name Latitude:(NSNumber*) latitude Longitude:(NSNumber*) longitude;

@end

NS_ASSUME_NONNULL_END
