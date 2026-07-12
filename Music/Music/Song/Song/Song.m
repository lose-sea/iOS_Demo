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

- (instancetype)initWithCover:(UIImage *)coverImage Name:(NSString *)name Artist:(NSString *)artist {
    self = [self init];
    if (self) {
        self.coverImage = coverImage;
        self.name = name;
        self.artist = artist;
    }
    return self; 
}

- (void) setUpData {
    self.coverImage = [UIImage imageNamed: @"47.jpg"];
    self.name = @"好不好";
    self.artist = @"颜人中";
    self.isLike = NO;
    self.isPlay = NO;
}
@end
