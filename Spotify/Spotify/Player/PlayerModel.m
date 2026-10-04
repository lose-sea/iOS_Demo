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
#import "PlaybackRepository.h"
#import "PlaybackState.h"
#import "TrackRepository.h"
#import "PlaylistRepository.h"
#import "Playlist.h"
#import "Track.h"

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
    // 优先恢复上次的播放进度（跨启动续播）；没有记录再走默认占位 + 网络
    if ([self restorePlaybackState]) {
        return;
    }

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

    // App 退到后台 / 即将挂起时落盘当前进度，保证「跨启动续播」
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(savePlaybackState)
                                                 name:UIApplicationWillResignActiveNotification
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


#pragma mark - 播放状态持久化（跨启动续播）

/// 把当前曲目 / 进度 / 歌单落盘（L3）。shuffle / repeatMode 当前播放器未实现，先存 0/NO 占位
- (void)savePlaybackState {
    if (!self.currentSong) return;
    PlaybackState *state = [[PlaybackState alloc] init];
    state.currentTrackId = self.currentSong.songId;
    state.position = (NSInteger)[SPAudioPlayer sharedPlayer].currentTime;
    state.playlistId = self.currentPlayList.playlistId;
    state.shuffle = NO;
    state.repeatMode = 0;
    [PlaybackRepository savePlaybackState:state];
}

/// 启动时用 L3 里上次的进度恢复播放器；恢复成功返回 YES（此时不再用网络默认歌覆盖）
- (BOOL)restorePlaybackState {
    PlaybackState *state = [PlaybackRepository currentPlaybackState];
    if (!state || state.currentTrackId.length == 0) return NO;

    Track *t = [TrackRepository trackWithId:state.currentTrackId];
    if (!t) return NO;
    Song *song = [TrackRepository songFromTrack:t];
    if (!song) return NO;

    // 尽量还原所在的歌单：优先用缓存里同 id 的歌单，否则退化成单曲列表
    SongListModel *playlist = nil;
    if (state.playlistId.length) {
        Playlist *p = [[PlaylistRepository allPlaylists] filteredArrayUsingPredicate:
                       [NSPredicate predicateWithFormat:@"playlistId == %@", state.playlistId]].firstObject;
        if (p) {
            playlist = [[SongListModel alloc] init];
            playlist.playlistId = p.playlistId;
            playlist.playlistName = p.name;
            playlist.coverURL = p.coverURL;
            NSMutableArray<Song *> *songs = [NSMutableArray array];
            for (Track *tt in [PlaylistRepository tracksInPlaylist:p.playlistId]) {
                Song *s = [TrackRepository songFromTrack:tt];
                if (s) [songs addObject:s];
            }
            playlist.songs = songs;
        }
    }
    if (!playlist) {
        playlist = [[SongListModel alloc] init];
        playlist.playlistName = song.songName ?: @"恢复播放";
        playlist.coverURL = song.coverURL;
        playlist.songs = @[song];
    }

    _currentPlayList = playlist;
    _currentSong = song;
    _isPlay = NO;   // 启动不自动出声，用户点播放时从续播位置接着放
    [self prepareSongEnsuringURL:song atPosition:state.position];

    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"changed": @"song"}];
    return YES;
}


// 换歌 = 立即加载并播放新的音频源（调用方需保证 song.audioURL 已就绪）
- (void)setCurrentSong:(Song *)song {
    _currentSong = song;
    _isPlay = YES;
    [[SPAudioPlayer sharedPlayer] playSong:song];
    [self savePlaybackState];
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"changed": @"song"}];
}

#pragma mark - 播放（缺失播放地址时现取）

/// 切歌入口：song 没有直链但有 songId 时，先向网络现取播放地址，取到再放（和首页点歌一致）
- (void)playSongEnsuringURL:(Song *)song {
    if (!song) return;
    if (song.audioURL.length > 0) {
        self.currentSong = song;   // setter内部会播放
        return;
    }
    if (song.songId.length == 0) {
        NSLog(@"[Player] 「%@」既无 audioURL 也无 songId，无法播放", song.songName);
        return;
    }
    [[NeteaseService sharedInstance] fetchSongURLWithId:song.songId
                                            completion:^(NSString *url, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (url.length > 0) {
                song.audioURL = url;
                [TrackRepository setAudioURL:url forTrackId:song.songId];  // 回写 L3，离线也能续播
                self.currentSong = song;
            } else {
                NSLog(@"[Player] 取「%@」播放地址失败：%@", song.songName, error.localizedDescription);
            }
        });
    }];
}

/// 预置入口：同 playSongEnsuringURL，但是只加载不播放，并跳到指定进度（续播恢复用）
- (void)prepareSongEnsuringURL:(Song *)song atPosition:(NSTimeInterval)position {
    if (song.audioURL.length > 0) {
        [[SPAudioPlayer sharedPlayer] prepareSong:song initialPosition:position];
        return;
    }
    if (song.songId.length == 0) return;
    [[NeteaseService sharedInstance] fetchSongURLWithId:song.songId
                                            completion:^(NSString *url, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (url.length > 0) {
                song.audioURL = url;
                [TrackRepository setAudioURL:url forTrackId:song.songId];
                [[SPAudioPlayer sharedPlayer] prepareSong:song initialPosition:position];
            }
        });
    }];
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
    [self savePlaybackState];
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

    [self playSongEnsuringURL:songs[index]];
}

@end
