//
//  SeachModel.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "SearchModel.h"

@implementation SearchModel

- (instancetype) init {
    self = [super init];
    if (self) {
        self.cityArray = [[NSMutableArray alloc] init];
    }
    return self; 
}
@end
