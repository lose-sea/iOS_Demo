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
        [self setUpData]; 
    }
    return self;
}

- (instancetype) initWithName:(NSString *)name Latitude:(NSNumber *)latitude Longitude:(NSNumber *)longitude {
    self = [self init];
    if (self) {
        self.cityName = name;
        self.latitude = [latitude doubleValue];
        self.longitude = [longitude doubleValue];
        [self setUpCityID];
    }
    return self;
}

- (void) setUpCityID {
    self.cityID = [NSString stringWithFormat: @"%.6f_%.6f", self.latitude, self.longitude];
}


- (void) setUpData {
    self.cityName = [NSString string];
}


- (BOOL) isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass: [CityModel class]]) {
        return NO;
    }
    CityModel* other = (CityModel*) object;
    return [self.cityName isEqualToString: other.cityName] && fabs(self.latitude - other.latitude) < 0.0001 && fabs(self.longitude - other.longitude) < 0.0001;
}
 

- (NSUInteger) hash {
    return self.cityName.hash ^ @(self.latitude).hash ^ @(self.longitude).hash;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject: self.cityName forKey: @"cityName"];
    [coder encodeObject: @(self.latitude) forKey: @"latitude"];
    [coder encodeObject: @(self.longitude) forKey: @"longitude"];
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.cityName = [coder decodeObjectForKey: @"cityName"];
        self.latitude = [[coder decodeObjectForKey: @"latitude"] doubleValue];
        self.longitude = [[coder decodeObjectForKey: @"longitude"] doubleValue];
        [self setUpCityID];
    }
    return self; 
}
@end
