//
//  HomeModel.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/15.
//

#import "HomeModel.h"

@implementation HomeModel
static HomeModel* instance = nil;
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];
        [instance setUpData];
    });
    return instance;
}
 
+ (instancetype) allocWithZone: (struct _NSZone*) zone {
    return [self shareInstance];
}

- (instancetype) init {
    return self;
}


- (instancetype) copyWithZone: (NSZone*) zone {
    return self;
}

- (instancetype) mutableCopyWithZone: (NSZone*) zone {
    return self;
}


- (void) setUpData {
    [self setUpDefaultCites];
    if (self) {
        
    }
}

- (void) setUpDefaultCites {
    
    self.dicts = [[NSMutableArray alloc] init];
    self.homeCities = [[NSMutableArray alloc] init];
    
    CityModel* a1 = [[CityModel alloc] initWithName: @"西安 -- 陕西" Latitude: @34.258330 Longitude: @108.928610];
    CityModel* a2 = [[CityModel alloc] initWithName: @"北京 -- 北京市" Latitude: @39.907500 Longitude: @116.397230];
    CityModel* a3 = [[CityModel alloc] initWithName: @"兰州 -- 甘肃" Latitude: @36.057010 Longitude: @103.839870];
    
    self.homeCities = [NSMutableArray arrayWithArray: @[a1, a2, a3]];

    
    for (NSInteger i = 0; i < self.homeCities.count; i++) {
        [self.dicts addObject: @{}];
    }
}
@end
