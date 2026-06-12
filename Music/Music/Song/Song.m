//
//  Song.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "Song.h"

@implementation Song
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void) setUpData {
    self.avatar = [UIImage imageNamed: @"47.jpg"];
    self.name = @"好不好";
    self.songer = @"颜人中";
}
@end
