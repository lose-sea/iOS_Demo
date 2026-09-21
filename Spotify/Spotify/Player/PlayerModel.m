//
//  PlayerModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "PlayerModel.h"

NSString *const PlayerModelDidChangeNotification = @"PlayerModelDidChangeNotification";

@implementation PlayerModel

+ (instancetype)sharedInstance {
    static PlayerModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PlayerModel alloc] init];
        [instance setUpDefaultSong]; 
    });
    return instance;
}


- (void) setUpDefaultSong {    
    Song* song = [[Song alloc] initWithCover: [UIImage imageNamed: @"53.jpg"] name: @"春娇与志明" singer: [[Singer alloc] init]];
    self.song = song;
}

- (void)setSong:(Song *)song {
    _song = song;
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"changed": @"song"}];
}



- (void)setIsPlay:(BOOL)isPlay {
    _isPlay = isPlay;
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"changed": @"isPlay"}];
}




@end
