//
//  UserModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import "UserModel.h"
#import "HomeModel.h"

/// 初始默认喜欢的首数（占位数据）
static const NSUInteger kDefaultFavouriteCount = 3;

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

    // 占位数据：接 WCDB / 接口后从持久层加载
    NSArray<Song *> *songs = [HomeModel sampleSongs];
    self.recentlySongs = songs;

    // 初始只有前几首是「已喜欢」，它们同时进「我的喜欢」歌单
    NSMutableArray<Song *> *favouriteSongs = [NSMutableArray array];
    for (NSUInteger index = 0; index < songs.count; index++) {
        BOOL liked = (index < kDefaultFavouriteCount);
        songs[index].isFavourite = liked;
        if (liked) {
            [favouriteSongs addObject:songs[index]];
        }
    }
    self.favoriteSongs = [favouriteSongs copy];

    // 创建默认歌单
    self.createSongLists = [self samplePlaylistsWithNames:@[@"每日推荐", @"通勤必备", @"深夜安静"]
                                                  covers:@[@"2.jpg", @"3.jpg", @"4.jpg"]];
    self.favouriteSongLists = [self samplePlaylistsWithNames:@[@"热门华语", @"运动节拍"]
                                                     covers:@[@"5.jpg", @"7.jpg"]];
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

- (void)removeCreatedPlaylist:(SongListModel *)playlist {
    if (!playlist) {
        return;
    }
    NSMutableArray<SongListModel *> *created = [self.createSongLists mutableCopy] ?: [NSMutableArray array];
    [created removeObject:playlist];
    self.createSongLists = [created copy];
}

#pragma mark - Private
// 创建默认歌单
- (NSArray<SongListModel *> *)samplePlaylistsWithNames:(NSArray<NSString *> *)names
                                                covers:(NSArray<NSString *> *)covers {
    NSMutableArray<SongListModel *> *playlists = [NSMutableArray array];
    for (NSUInteger i = 0; i < names.count; i++) {
        SongListModel *playlist = [[SongListModel alloc] init];
        playlist.playlistName = names[i];
        playlist.coverURL = covers[i];
        playlist.songs = [HomeModel sampleSongs];
        [playlists addObject:playlist];
    }
    return [playlists copy];
}

@end
