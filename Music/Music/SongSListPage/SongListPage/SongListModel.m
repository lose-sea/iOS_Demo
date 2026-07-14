//
//  SongListModel.m
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import "SongListModel.h"

@implementation SongListModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpdata]; 
    }
    return self;
}

- (void) setUpdata {
    self.songList = [[SongList alloc] init];
    self.songs = [[NSMutableArray alloc] init];
}
@end
