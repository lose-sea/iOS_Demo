//
//  SongPlayModel.m
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import "SongPlayModel.h"

@implementation SongPlayModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void)setUpData {
    self.song = [[Song alloc] init];
    self.songs = [[NSArray alloc] init];
}
@end
