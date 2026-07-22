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
//    self.saveCities = [[NSMutableArray alloc] init];
    self.dicts = [[NSMutableArray alloc] init];
    self.homeCities = [[NSMutableArray alloc] init]; 
}
@end
