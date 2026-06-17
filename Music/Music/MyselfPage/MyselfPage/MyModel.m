//
//  MyModel.m
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import "MyModel.h"

@implementation MyModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void)setUpData {
    self.user = [[UserModel alloc] init];
    self.songs = [[NSMutableArray alloc] init];
}
@end
