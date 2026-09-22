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

// 设置默认播放音乐
- (void) setUpDefaultSong {
    Song *song = [[Song alloc] initWithCoverURL:@"53.jpg"
                                            name:@"春娇与志明"
                                          singer:[[Singer alloc] initWithSingerName:@"朱玉仙"]];
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

#pragma mark - 切歌

- (void)playNextSong {
    [self switchToSongWithOffset:1];
}

- (void)playPreviousSong {
    [self switchToSongWithOffset:-1];
}

// 在当前歌单里循环切换；setSong / setIsPlay 内部会发通知刷新 UI
- (void)switchToSongWithOffset:(NSInteger)offset {
    NSArray<Song *> *songs = self.currentPlayList.songs;
    if (songs.count == 0) {
        NSLog(@"当前没有播放列表，无法切歌");
        return;
    }

    NSUInteger index = [songs indexOfObject:self.song];
    if (index == NSNotFound) index = 0;
    index = (index + offset + songs.count) % songs.count;

    self.song = songs[index];
    self.isPlay = YES;
}

@end
