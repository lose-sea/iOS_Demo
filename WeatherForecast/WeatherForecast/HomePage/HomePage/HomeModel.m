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
        
        [instance loadFormUserDefaults];
    });
    return instance;
}
 
+ (instancetype) allocWithZone: (struct _NSZone*) zone {
    return [self shareInstance];
}

- (instancetype) init {
    self.homeCities = [[NSMutableArray alloc] init];
    self.dicts = [[NSMutableArray alloc] init];
    return self;
}


- (instancetype) copyWithZone: (NSZone*) zone {
    return self;
}

- (instancetype) mutableCopyWithZone: (NSZone*) zone {
    return self;
}





- (void) setUpDefaultCites {
    self.dicts = [[NSMutableArray alloc] init];
    self.homeCities = [[NSMutableArray alloc] init];
    
    CityModel* a1 = [[CityModel alloc] initWithName: @"西安 -- 陕西" Latitude: @34.258330 Longitude: @108.928610];
    CityModel* a2 = [[CityModel alloc] initWithName: @"北京 -- 北京市" Latitude: @39.907500 Longitude: @116.397230];
    CityModel* a3 = [[CityModel alloc] initWithName: @"兰州 -- 甘肃" Latitude: @36.057010 Longitude: @103.839870];
    
    self.homeCities = [NSMutableArray arrayWithArray: @[a1, a2, a3]];
    [self createDicts];
}

- (void) createDicts {
    [self.dicts removeAllObjects];
    for (NSInteger i = 0; i < self.homeCities.count; i++) {
        [self.dicts addObject: @{}];
    }
    NSLog(@"homecities.count: %ld", self.homeCities.count);
    NSLog(@"dicts.count: %ld", self.dicts.count);
}

- (void) saveToUserDefaults {
    NSError* error = nil;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject: self.homeCities requiringSecureCoding: NO error: &error];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject: data forKey: @"SavedCities"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"保存成功"); 
    } else {
        NSLog(@"保存城市数据失败: %@", error);
    }
}

- (void) loadFormUserDefaults {
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey: @"SavedCities"];
    if (data) {
        NSError* error = nil;
        NSSet* classes = [NSSet setWithObjects: [NSArray class], [CityModel class], nil];
        NSArray* cities = [NSKeyedUnarchiver unarchivedObjectOfClasses: classes fromData: data error: &error];
        if (cities && [cities isKindOfClass: [NSArray class]]) {
            self.homeCities = [cities mutableCopy];
            
            [self createDicts];
            
            NSLog(@"加载到数据");
            return;
        } else {
            NSLog(@"数据加载失败: %@", error);
        }
    }
    NSLog(@"未加载到数据");
    [self setUpDefaultCites];
}


- (void) addCityToSave: (CityModel*) city {
    [self.homeCities addObject: city];
    [self.dicts addObject: @{}];
    [self saveToUserDefaults];

}


- (void) removeCityFormSave: (CityModel*) city {
    [self.homeCities removeObject: city];
    [self saveToUserDefaults];
}

@end
