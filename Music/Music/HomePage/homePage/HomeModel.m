//
//  HomeModel.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
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

- (void)setUpData {
    self.recommendImages = [[NSMutableArray alloc] init];
    self.songersImages = [[NSMutableArray alloc] init];
}
@end
