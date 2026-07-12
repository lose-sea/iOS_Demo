//
//  SongLIst.m
//  Music
//
//  Created by lose_sea on 2026/7/12.
//
#import "SongList.h"

@implementation SongList
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void) setUpData {
    self.coverImage = [[UIImage alloc] init];
    self.name = [[NSString alloc] init];
    self.message = [[NSString alloc] init];
}

- (instancetype) initWithCover: (UIImage*) cover Name: (NSString*) name message: (NSString*) message {
    self = [self init];
    if (self) {
        self.coverImage = cover;
        self.name = name;
        self.message = message;
    }
    return self;
}
@end
