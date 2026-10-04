//
//  UserModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import "UserModel.h"
#import "NeteaseService.h"
#import "Track.h"
#import "TrackRepository.h"
#import "Playlist.h"
#import "PlaylistRepository.h"

/// 初始默认喜欢的首数
static const NSUInteger kDefaultFavouriteCount = 3;
/// 每个歌单最多装的歌曲数（横向列表不用塞满整张榜）
static const NSUInteger kPlaylistSongLimit = 20;

/// 网络曲库加载完成通知
NSString *const UserModelLibraryDidLoadNotification = @"UserModelLibraryDidLoadNotification";

/// 我创建的歌单：名字 → 用哪张官方榜单填充（顺序一一对应）
static NSString * const kCreatedPlaylistNames[] = {@"每日推荐", @"通勤必备", @"深夜安静"};
static NSString * const kCreatedPlaylistIds[]   = {@"3778678", @"3779629", @"2884035"};   // 热歌榜 / 新歌榜 / 原创榜
/// 我收藏的歌单：名字 → 用什么关键字搜（网易云没有现成的「华语/运动」歌单 id）
static NSString * const kCollectedPlaylistNames[]    = {@"热门华语", @"运动节拍"};
static NSString * const kCollectedPlaylistKeywords[] = {@"华语", @"运动"};

@implementation UserModel

+ (instancetype)sharedInstance {
    static UserModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];   // init 内部会填充默认数据
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void)setUpData {
    self.user_name = @"lose_sea";
    self.avatarURL = @"51.jpg";
    self.email = @"lose_sea@spotify.com";
    self.level = @"Lv.5";

    // 歌曲 / 歌单都等网络曲库回来再填
    self.recentlySongs = @[];
    self.favoriteSongs = @[];

    // 歌单先建好（名字在，歌曲 / 封面等网络回来再填），并给稳定 playlistId 用于持久化
    NSMutableArray<SongListModel *> *created = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        SongListModel *p = [self playlistNamed:kCreatedPlaylistNames[i]];
        p.playlistId = kCreatedPlaylistIds[i];   // 用对应官方榜单 id 当稳定主键
        [created addObject:p];
    }
    self.createSongLists = [created copy];

    NSMutableArray<SongListModel *> *collected = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i++) {
        SongListModel *p = [self playlistNamed:kCollectedPlaylistNames[i]];
        p.playlistId = [NSString stringWithFormat:@"collect_%@", kCollectedPlaylistKeywords[i]];
        [collected addObject:p];
    }
    self.favouriteSongLists = [collected copy];

    [self loadNetworkLibrary];
}

#pragma mark - 网络曲库

/// 启动时拉网络数据填充「最近播放 / 我的喜欢 / 我的歌单」；服务不可用时保持为空
- (void)loadNetworkLibrary {
    NeteaseService *service = [NeteaseService sharedInstance];
    __weak typeof(self) weakSelf = self;

    // 优先用 L3 里持久化的「我创建的 / 我收藏的」歌单恢复，保证跨启动一致、不丢用户改动
    if ([self restorePersistedPlaylists]) {
        [self postLibraryDidLoad];
        // 仍拉一次热歌榜只为了喂「播放器默认歌单」，不覆盖已恢复的歌单
        [service fetchPlaylistDetailWithId:kCreatedPlaylistIds[0]
                                completion:^(SongListModel *playlist, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (playlist.songs.count) {
                    weakSelf_recentlySongs(weakSelf, playlist.songs);
                }
                [weakSelf restoreFavouritesFromDatabase];
                [weakSelf postLibraryDidLoad];
            });
        }];
        return;
    }

    // ===== 首次启动：走原网络流程，拉完落盘 =====
    [service fetchPlaylistDetailWithId:kCreatedPlaylistIds[0]
                            completion:^(SongListModel *playlist, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray<Song *> *songs = playlist.songs;
            if (!songs.count) {
                NSLog(@"[User] 默认曲库拉取失败：%@", error.localizedDescription);
                // 网络挂了也尽量用本地持久化的喜欢恢复，别让「我的喜欢」空着
                [weakSelf restoreFavouritesFromDatabase];
                [weakSelf postLibraryDidLoad];
                return;
            }
            weakSelf.recentlySongs = [songs subarrayWithRange:NSMakeRange(0, MIN(12, songs.count))];

            // 前几首默认「已喜欢」，同时进「我的喜欢」歌单
            NSMutableArray<Song *> *liked = [NSMutableArray array];
            for (NSUInteger i = 0; i < MIN(kDefaultFavouriteCount, weakSelf.recentlySongs.count); i++) {
                Song *song = weakSelf.recentlySongs[i];
                song.isFavourite = YES;
                [liked addObject:song];
            }
            weakSelf.favoriteSongs = [liked copy];

            // 用本地持久化的喜欢状态覆盖/补充网络默认（保证跨启动一致）
            [weakSelf restoreFavouritesFromDatabase];
            [weakSelf postLibraryDidLoad];
        });
    }];

    // 我创建的歌单：各自对应一张官方榜单
    for (NSUInteger i = 0; i < weakSelf.createSongLists.count && i < 3; i++) {
        [weakSelf fillPlaylist:self.createSongLists[i] withPlaylistId:kCreatedPlaylistIds[i]];
    }
    // 我收藏的歌单：按关键字搜出来的歌
    for (NSUInteger i = 0; i < self.favouriteSongLists.count && i < 2; i++) {
        [self fillPlaylist:self.favouriteSongLists[i] withKeyword:kCollectedPlaylistKeywords[i]];
    }
}

/// 把热歌榜前几首写入 recentlySongs（小工具，避免循环引用写法冗余）
static void weakSelf_recentlySongs(UserModel *self, NSArray<Song *> *songs) {
    self.recentlySongs = [songs subarrayWithRange:NSMakeRange(0, MIN(12, songs.count))];
}

/// 用官方榜单填歌单的歌曲和封面
- (void)fillPlaylist:(SongListModel *)playlist withPlaylistId:(NSString *)playlistId {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchPlaylistDetailWithId:playlistId
                                                    completion:^(SongListModel *detail, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!detail.songs.count) {
                NSLog(@"[User] 歌单「%@」拉取失败：%@", playlist.playlistName, error.localizedDescription);
                return;
            }
            NSUInteger count = MIN(kPlaylistSongLimit, detail.songs.count);
            playlist.songs = [detail.songs subarrayWithRange:NSMakeRange(0, count)];
            // 榜单自己的封面是 http 且尺寸小，直接用第一首歌的封面
            playlist.coverURL = playlist.songs.firstObject.coverURL;
            [weakSelf persistCreatedPlaylists];   // 拉到就落盘，下次启动不用再等网络
            [weakSelf postLibraryDidLoad];
        });
    }];
}

/// 用搜索结果填歌单的歌曲和封面
- (void)fillPlaylist:(SongListModel *)playlist withKeyword:(NSString *)keyword {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] searchSongsWithKeyword:keyword
                                                     limit:kPlaylistSongLimit
                                                completion:^(NSArray<Song *> *songs, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!songs.count) {
                NSLog(@"[User] 歌单「%@」搜索「%@」失败：%@", playlist.playlistName, keyword, error.localizedDescription);
                return;
            }
            playlist.songs = songs;
            playlist.coverURL = songs.firstObject.coverURL;
            [weakSelf persistCollectedPlaylists];   // 拉到就落盘
            [weakSelf postLibraryDidLoad];
        });
    }];
}

- (void)postLibraryDidLoad {
    [[NSNotificationCenter defaultCenter] postNotificationName:UserModelLibraryDidLoadNotification
                                                        object:self];
}

#pragma mark - “我的喜欢”

/// 每次由 favoriteSongs 生成，保证和喜欢的歌曲永远一致
- (SongListModel *)favouritePlaylist {
    SongListModel *playlist = [[SongListModel alloc] init];
    playlist.playlistName = @"我的喜欢";
    playlist.coverURL = self.favoriteSongs.firstObject.coverURL ?: @"6.jpg";
    playlist.songs = self.favoriteSongs;
    playlist.isSystemPlaylist = YES;   // 默认歌单，删除操作必须检查这个标记
    return playlist;
}

#pragma mark - 喜欢持久化（与 FavouriteManager 共用 WCDB）

/// 启动时把内存里的「我的喜欢」对齐到 WCDB：
///  - 数据库尚未初始化（allTracks 为空，真正的首次启动）→ 把当前网络默认的喜欢写进 DB 做种子
///  - 数据库已初始化 → 以 DB 的喜欢状态为准（likedTracks 可能为空，即用户全取消了）
- (void)restoreFavouritesFromDatabase {
    if ([TrackRepository allTracks].count == 0) {
        for (Song *s in self.favoriteSongs) {
            [TrackRepository syncTrackFromSong:s liked:YES];
        }
        return;
    }
    NSMutableArray<Song *> *restored = [NSMutableArray array];
    for (Track *t in [TrackRepository likedTracks]) {
        if (t.trackId.length == 0) continue;
        [restored addObject:[TrackRepository songFromTrack:t]];
    }
    self.favoriteSongs = [restored copy];
}

#pragma mark - 歌单增删（收藏 / 取消收藏歌单走 FavouriteManager）

#pragma mark 持久化（L3）

/// 把当前「我创建的 / 我收藏的」歌单整组落盘（含曲目与关联）
- (void)persistCreatedPlaylists {
    [self persistPlaylists:self.createSongLists category:@"created"];
}

- (void)persistCollectedPlaylists {
    [self persistPlaylists:self.favouriteSongLists category:@"collected"];
}

- (void)persistPlaylists:(NSArray<SongListModel *> *)playlists category:(NSString *)category {
    NSInteger idx = 0;
    for (SongListModel *m in playlists) {
        if (!m) continue;
        // 保证有稳定主键：创建的用现有 id，收藏的没 id 就按名字生成
        if (m.playlistId.length == 0) {
            m.playlistId = [NSString stringWithFormat:@"%@_%@", category,
                            (m.playlistName.length ? m.playlistName : @(idx))];
        }
        Playlist *p = [[Playlist alloc] init];
        p.playlistId = m.playlistId;
        p.name = m.playlistName;
        p.coverURL = m.coverURL;
        p.desc = category;          // 标记分类，还原时据此区分
        p.sort = idx++;
        p.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
        [PlaylistRepository insertOrUpdatePlaylist:p];

        NSMutableArray<Track *> *tracks = [NSMutableArray array];
        for (Song *s in m.songs) {
            Track *t = [TrackRepository trackFromSong:s];
            if (t) [tracks addObject:t];
        }
        [PlaylistRepository saveTracks:tracks forPlaylistId:m.playlistId];
    }
}

/// 启动从 L3 还原「我创建的 / 我收藏的」歌单；有数据返回 YES（此时不再走网络覆盖）
- (BOOL)restorePersistedPlaylists {
    NSArray<Playlist *> *all = [PlaylistRepository allPlaylists];
    if (all.count == 0) return NO;

    NSMutableArray<SongListModel *> *created = [NSMutableArray array];
    NSMutableArray<SongListModel *> *collected = [NSMutableArray array];
    for (Playlist *p in all) {
        SongListModel *m = [[SongListModel alloc] init];
        m.playlistId = p.playlistId;
        m.playlistName = p.name;
        m.coverURL = p.coverURL;
        NSMutableArray<Song *> *songs = [NSMutableArray array];
        for (Track *t in [PlaylistRepository tracksInPlaylist:p.playlistId]) {
            Song *s = [TrackRepository songFromTrack:t];
            if (s) [songs addObject:s];
        }
        m.songs = songs;
        if ([p.desc isEqualToString:@"created"]) [created addObject:m];
        else if ([p.desc isEqualToString:@"collected"]) [collected addObject:m];
    }
    if (created.count) self.createSongLists = [created copy];
    if (collected.count) self.favouriteSongLists = [collected copy];
    return (created.count > 0 || collected.count > 0);
}

// 添加歌曲到指定歌单
- (void)addSong:(Song *)song toPlaylist:(SongListModel *)playlist {
    // 判空处理
    if (!song || !playlist) {
        return;
    }
    // 同一首不重复加
    if ([playlist.songs containsObject:song]) {
        return;
    }
    playlist.songs = [(playlist.songs ?: @[]) arrayByAddingObject:song];
    [self persistCreatedPlaylists];      // 改动即落盘
    [self persistCollectedPlaylists];
}

// 删除创建歌单
- (void)removeCreatedPlaylist:(SongListModel *)playlist {
    if (!playlist) {
        return;
    }
    NSMutableArray<SongListModel *> *created = [self.createSongLists mutableCopy] ?: [NSMutableArray array];
    [created removeObject:playlist];
    self.createSongLists = [created copy];
    if (playlist.playlistId.length) {
        [PlaylistRepository deletePlaylist:playlist.playlistId];   // 连曲目关联一起清
    }
    [self persistCreatedPlaylists];
}




#pragma mark - Private
/// 建一个只有名字的歌单，歌曲和封面等网络回来再填
- (SongListModel *)playlistNamed:(NSString *)name {
    SongListModel *playlist = [[SongListModel alloc] init];
    playlist.playlistName = name;
    playlist.songs = @[];
    return playlist;
}

@end


