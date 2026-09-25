//
//  UserModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import "UserModel.h"
#import "HomeModel.h"

NSString *const UserModelFavouriteDidChangeNotification = @"UserModelFavouriteDidChangeNotification";

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
    NSMutableArray<Song *> *favourites = [NSMutableArray array];
    for (NSUInteger index = 0; index < songs.count; index++) {
        BOOL liked = (index < kDefaultFavouriteCount);
        songs[index].isFavourite = liked;
        if (liked) [favourites addObject:songs[index]];
    }
    self.favoriteSongs = [favourites copy];

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

#pragma mark - 喜欢 / 取消喜欢

- (void)setSong:(Song *)song favourite:(BOOL)favourite {
    if (!song) return;

    song.isFavourite = favourite;

    NSMutableArray<Song *> *songs = [self.favoriteSongs mutableCopy] ?: [NSMutableArray array];
    if (favourite) {
        if (![songs containsObject:song]) {
            [songs addObject:song];     // 新喜欢的歌排到最后
        }
    } else {
        [songs removeObject:song];      // 取消喜欢就从「我的喜欢」里移除
    }
    self.favoriteSongs = [songs copy];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserModelFavouriteDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"song": song,
                                                                 @"isFavourite": @(favourite)}];
}

- (void)toggleFavouriteForSong:(Song *)song {
    [self setSong:song favourite:!song.isFavourite];
}

- (BOOL)isFavouriteSong:(Song *)song {
    return song ? [self.favoriteSongs containsObject:song] : NO;
}

#pragma mark - Private

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
