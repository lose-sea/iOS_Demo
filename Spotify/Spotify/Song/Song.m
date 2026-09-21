//
//  Song.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "Song.h"

@implementation Song
- (instancetype) initWithSognCover:(UIImage *) songCover name:(NSString *)songName singer:(Singer *)singer {
    self = [self init];
    if (self) {
        self.songCover = songCover;
        self.songName = songName;
        self.singer = singer;
        
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
