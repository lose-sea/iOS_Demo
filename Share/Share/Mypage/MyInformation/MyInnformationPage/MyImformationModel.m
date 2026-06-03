//
//  MyImformationModel.m
//  Share
//
//  Created by lose_sea on 2026/6/1.
//

#import "MyImformationModel.h"

@implementation MyImformationModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void) setUpData {
    self.massages = [[NSMutableArray alloc] init];
}
@end
