//
//  FollowerModel.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "FollowerModel.h"

@implementation FollowerModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.followers = [[NSMutableArray alloc] init];
    }
    return self; 
}
@end
