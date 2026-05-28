//
//  ActivityModel.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ActivityModel.h"

@implementation ActivityModel

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setData];
    }
    return self;
}

- (void) setData {
    self.images = [[NSMutableArray alloc] init];
    self.massages = [[NSMutableArray alloc] init];
}


@end
