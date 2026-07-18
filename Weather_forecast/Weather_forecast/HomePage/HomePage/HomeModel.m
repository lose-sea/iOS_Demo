//
//  HomeModel.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/15.
//

#import "HomeModel.h"

@implementation HomeModel

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void) setUpData {
    self.saveCities = [[NSMutableArray alloc] init];
}
@end
