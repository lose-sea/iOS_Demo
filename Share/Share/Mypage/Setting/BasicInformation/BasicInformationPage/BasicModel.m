//
//  BasicModel.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "BasicModel.h"

@implementation BasicModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.tags = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
