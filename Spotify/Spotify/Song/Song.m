//
//  Song.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "Song.h"

@implementation Song

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithCoverURL:(NSString *)coverURL name:(NSString *)songName singer:(Singer *)singer {
    self = [super init];
    if (self) {
        self.coverURL = coverURL;
        self.songName = songName;
        self.singer = singer;
    }
    return self;
}

@end
