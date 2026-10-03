//
//  PlayerModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "PlayerModel.h"
#import "SPAudioPlayer.h"
#import "UserModel.h"
#import "NeteaseService.h"

NSString *const PlayerModelDidChangeNotification = @"PlayerModelDidChangeNotification";

/// 默认歌曲取自这张官方榜单（热歌榜）
static NSString * const kDefaultPlaylistId = @"3778678";

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

// 设置默认播放音乐 + 默认歌单
- (void) setUpDefaultSong {
    Song *song = [[Song alloc] initWithCoverURL:@"53.jpg"
                                            name:@"春娇与志明"
                                          singer:[[Singer alloc] initWithSingerName:@"朱玉仙"]
                                        audioURL:[Song demoAudioURLAtIndex:0]];

    // 默认歌单：把默认歌曲放在首位，再接上曲库，启动时就能上一首/下一首
    // 用 UserModel 里那批 Song 实例，收藏标记才和「我的喜欢」一致
    SongListModel *defaultList = [[SongListModel alloc] init];
    defaultList.playlistName = @"默认播放列表";
    defaultList.coverURL = song.coverURL;
    NSArray<Song *> *library = [UserModel sharedInstance].recentlySongs ?: @[];
    defaultList.songs = [@[song] arrayByAddingObjectsFromArray:library];
    _currentPlayList = defaultList;

    _currentSong = song;
    _isPlay = NO;
    // 先把音频源准备好，等用户点播放再出声（App 启动就响会很打扰）
    [[SPAudioPlayer sharedPlayer] prepareSong:song];

    // 上面的本地歌只是占位：本地 Node 服务可用时换成热歌榜第一首
    [self loadDefaultSongFromNetwork];
}

/// 默认歌曲换成热歌榜第一首（播放地址现取）；服务不可用 / 取不到地址时保留上面的占位歌
- (void)loadDefaultSongFromNetwork {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchPlaylistDetailWithId:kDefaultPlaylistId
                                                    completion:^(SongListModel *playlist, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Song *first = playlist.songs.firstObject;
            if (!first) {
                NSLog(@"[Player] 默认歌曲拉取失败：%@", error.localizedDescription);
                return;
            }
            [weakSelf prepareDefaultSong:first inPlaylist:playlist];
        });
    }];
}

/// 播放地址有时效，取到地址后再把这首设为默认（只预置不出声）
- (void)prepareDefaultSong:(Song *)song inPlaylist:(SongListModel *)playlist {
    [[NeteaseService sharedInstance] fetchSongURLWithId:song.songId
                                            completion:^(NSString *url, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (url.length == 0) {
                NSLog(@"[Player] 默认歌曲取播放地址失败：%@", error.localizedDescription);
                return;
            }
            song.audioURL = url;

            playlist.playlistName = @"热歌榜";
            playlist.coverURL = song.coverURL;
            _currentPlayList = playlist;
            // 直接改 ivar：走 setCurrentSong: 会立刻出声，启动时不该自动播
            _currentSong = song;
            _isPlay = NO;
            [[SPAudioPlayer sharedPlayer] prepareSong:song];

            [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                                object:self
                                                              userInfo:@{@"changed": @"song"}];
        });
    }];
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
- (void)setCurrentSong:(Song *)song {
    _currentSong = song;
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
        // 播放
        [[SPAudioPlayer sharedPlayer] play];
    } else {
        // 暂停
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
// 切换歌曲
- (void)switchToSongWithOffset:(NSInteger)offset {
    NSArray<Song *> *songs = self.currentPlayList.songs;
    if (songs.count == 0) {
        NSLog(@"当前没有播放列表，无法切歌");
        return;
    }

    NSUInteger index = [songs indexOfObject:self.currentSong];
    if (index == NSNotFound) {
        index = 0;
    }
    // 取余,最后一首歌的下一首是第一首歌
    index = (index + offset + songs.count) % songs.count;

    self.currentSong = songs[index];
    self.isPlay = YES;
}

@end
