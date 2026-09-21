//
//  Singer.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "Singer.h"

@implementation Singer
- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithSingerName: (NSString*) name {
    self = [self init];
    if (self) {
        self.singerName = name;
    }
    return self; 
}
@end
