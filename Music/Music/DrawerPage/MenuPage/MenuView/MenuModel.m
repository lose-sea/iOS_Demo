//
//  MenuModel.m
//  Music
//
//  Created by lose_sea on 2026/6/16.
//

#import "MenuModel.h"

@implementation MenuModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void)setUpData {
    self.tagImages = [[NSArray alloc] init];
    self.tagTitles = [[NSArray alloc] init];
    self.user = [[UserModel alloc] init];
}

@end
