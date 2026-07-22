//
//  CityModel.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/22.
//

#import "CityModel.h"

@implementation CityModel
- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithName:(NSString *)name Latitude:(NSNumber *)latitude Longitude:(NSNumber *)longitude {
    self = [self init];
    if (self) {
        self.cityName = name;
        self.latitude = [latitude doubleValue];
        self.longitude = [longitude doubleValue];
    }
    return self;
}


- (void) setUpData {
    self.cityName = [NSString string];
}


@end
