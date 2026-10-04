//
//  UserModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import "UserModel.h"
#import "NeteaseService.h"

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

    // 歌单先建好（名字在，歌曲 / 封面等网络回来再填）
    NSMutableArray<SongListModel *> *created = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        [created addObject:[self playlistNamed:kCreatedPlaylistNames[i]]];
    }
    self.createSongLists = [created copy];

    NSMutableArray<SongListModel *> *collected = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i++) {
        [collected addObject:[self playlistNamed:kCollectedPlaylistNames[i]]];
    }
    self.favouriteSongLists = [collected copy];

    [self loadNetworkLibrary];
}

#pragma mark - 网络曲库

/// 启动时拉网络数据填充「最近播放 / 我的喜欢 / 我的歌单」；服务不可用时保持为空
- (void)loadNetworkLibrary {
    NeteaseService *service = [NeteaseService sharedInstance];

    // 最近播放 + 默认喜欢：都用热歌榜
    __weak typeof(self) weakSelf = self;
    [service fetchPlaylistDetailWithId:kCreatedPlaylistIds[0]
                            completion:^(SongListModel *playlist, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray<Song *> *songs = playlist.songs;
            if (!songs.count) {
                NSLog(@"[User] 默认曲库拉取失败：%@", error.localizedDescription);
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

#pragma mark - 歌单增删（收藏 / 取消收藏歌单走 FavouriteManager）

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
}

// 删除创建歌单
- (void)removeCreatedPlaylist:(SongListModel *)playlist {
    if (!playlist) {
        return;
    }
    NSMutableArray<SongListModel *> *created = [self.createSongLists mutableCopy] ?: [NSMutableArray array];
    [created removeObject:playlist];
    self.createSongLists = [created copy];
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


