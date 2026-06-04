//
//  MyRecommendModel.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "MyRecommendModel.h"

@implementation MyRecommendModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void) setUpData {
    self.articles = [[NSMutableArray alloc] init];
}
@end
