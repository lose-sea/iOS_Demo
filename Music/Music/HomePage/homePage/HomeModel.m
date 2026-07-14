//
//  HomeModel.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "HomeModel.h"

@implementation HomeModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void)setUpData {
    self.DailyRecommendImages = [[NSMutableArray alloc] init];
    self.RecommendSongListImages = [[NSMutableArray alloc] init];
    
    self.songLists = [[NSMutableArray alloc] init]; 
    self.songs = [[NSMutableArray alloc] init];
    self.user = [[UserModel alloc] init]; 
}
@end
