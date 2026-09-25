//
//  PlayerModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "PlayerModel.h"
#import "SPAudioPlayer.h"

NSString *const PlayerModelDidChangeNotification = @"PlayerModelDidChangeNotification";

@implementation PlayerModel

+ (instancetype)sharedInstance {
    static PlayerModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PlayerModel alloc] init];
        [instance setUpAudioPlayer];
        [instance setUpDefaultSong]; 
    });
    return instance;
}

// 设置默认播放音乐
- (void) setUpDefaultSong {
    Song *song = [[Song alloc] initWithCoverURL:@"53.jpg"
                                            name:@"春娇与志明"
                                          singer:[[Singer alloc] initWithSingerName:@"朱玉仙"]
                                        audioURL:[Song demoAudioURLAtIndex:0]];
    _song = song;
    _isPlay = NO;
    // 先把音频源准备好，等用户点播放再出声（App 启动就响会很打扰）
    [[SPAudioPlayer sharedPlayer] prepareSong:song];
}

#pragma mark - 音频引擎

- (void)setUpAudioPlayer {
    SPAudioPlayer *player = [SPAudioPlayer sharedPlayer];
    __weak typeof(self) weakSelf = self;

    // 锁屏 / 控制中心的上一首、下一首
    player.nextTrackHandler = ^{
        [weakSelf playNextSong];
    };
    player.previousTrackHandler = ^{
        [weakSelf playPreviousSong];
    };

    // 一首歌播完自动接下一首
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerDidPlayToEnd:)
                                                 name:SPAudioPlayerDidPlayToEndNotification
                                               object:nil];
    // 播放失败 / 被系统打断时把状态同步回来
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerStateDidChange:)
                                                 name:SPAudioPlayerPlaybackStateDidChangeNotification
                                               object:nil];
}

- (void)audioPlayerDidPlayToEnd:(NSNotification *)notification {
    [self playNextSong];
}

- (void)audioPlayerStateDidChange:(NSNotification *)notification {
    BOOL playing = [notification.userInfo[@"playing"] boolValue];
    if (_isPlay != playing) {
        _isPlay = playing;
        [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                            object:self
                                                          userInfo:@{@"changed": @"isPlay"}];
    }
}


// 换歌 = 立即加载并播放新的音频源
- (void)setSong:(Song *)song {
    _song = song;
    _isPlay = YES;
    [[SPAudioPlayer sharedPlayer] playSong:song];
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"changed": @"song"}];
}



- (void)setIsPlay:(BOOL)isPlay {
    if (_isPlay == isPlay) return;
    _isPlay = isPlay;
    if (isPlay) {
        [[SPAudioPlayer sharedPlayer] play];
    } else {
        [[SPAudioPlayer sharedPlayer] pause];
    }
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
