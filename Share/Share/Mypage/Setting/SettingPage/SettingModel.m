//
//  SettingModel.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "SettingModel.h"

@implementation SettingModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void) setUpData {
    self.settings = [[NSMutableArray alloc] init];
}
@end
