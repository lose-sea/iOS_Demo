//
//  FavouriteManager.m
//  Spotify
//
//  Created by lose_sea on 2026/10/1.
//

#import "FavouriteManager.h"
#import "UserModel.h"
#import "Track.h"
#import "TrackRepository.h"
#import "AudioCache.h"

NSString *const FavouriteDidChangeNotification = @"FavouriteDidChangeNotification";

@implementation FavouriteManager

+ (instancetype)sharedInstance {
    static FavouriteManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 收藏歌曲

/// 同一首歌在不同页面可能是不同实例（每个接口各解析一次，比如默认曲库和「每日推荐」都取自热歌榜），
/// 所以优先按 songId 匹配，没有 id 的本地占位歌才退回指针比较
- (Song *)favouriteSongMatching:(Song *)song {
    if (!song) return nil;
    for (Song *item in [UserModel sharedInstance].favoriteSongs) {
        if (song.songId.length > 0 && item.songId.length > 0) {
            if ([item.songId isEqualToString:song.songId]) return item;
        } else if (item == song) {
            return item;
        }
    }
    return nil;
}

- (void)setSong:(Song *)song favourite:(BOOL)favourite {
    if (!song) return;

    UserModel *user = [UserModel sharedInstance];

    song.isFavourite = favourite;

    NSMutableArray<Song *> *songs = [user.favoriteSongs mutableCopy] ?: [NSMutableArray array];
    Song *existing = [self favouriteSongMatching:song];
    if (favourite) {
        if (!existing) [songs addObject:song];     // 新喜欢的歌排到最后
    } else if (existing) {
        [songs removeObject:existing];             // 取消喜欢就从「我的喜欢」里移除
        existing.isFavourite = NO;                 // 同 id 的另一个实例也要把标记清掉
    }
    user.favoriteSongs = [songs copy];

    // 跨启动持久化：把喜欢状态落到 WCDB（L3），喜欢的歌顺手缓存到本地，离线也能播
    [self persistLikeState:song liked:favourite];

    [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"song": song,
                                                                 @"isFavourite": @(favourite)}];
}

/// 写入 WCDB 并（仅喜欢时）触发本地音频缓存
- (void)persistLikeState:(Song *)song liked:(BOOL)liked {
    if (song.songId.length == 0) return;   // 本地占位歌不持久化
    Track *track = [TrackRepository syncTrackFromSong:song liked:liked];
    if (liked && track) {
        [[AudioCache shared] cacheTrack:track completion:nil];
    }
}

- (void)toggleFavouriteForSong:(Song *)song {
    // 用 isFavouriteSong: 而不是 song.isFavourite：同一首歌的别的实例可能已经收藏过，
    // 只看自己这个实例会「取消」不成、反而重复收藏
    [self setSong:song favourite:![self isFavouriteSong:song]];
}

- (BOOL)isFavouriteSong:(Song *)song {
    return [self favouriteSongMatching:song] != nil;
}

#pragma mark - 收藏歌单

/// 优先按 playlistId 匹配；首页卡片是每次新建的临时歌单、没有 id，退回按歌单名匹配
- (SongListModel *)favouritePlaylistMatching:(SongListModel *)playlist {
    if (!playlist) return nil;
    for (SongListModel *item in [UserModel sharedInstance].favouriteSongLists) {
        if (playlist.playlistId.length > 0 && item.playlistId.length > 0) {
            if ([item.playlistId isEqualToString:playlist.playlistId]) {
                return item;
            }
        } else if ([item.playlistName isEqualToString:playlist.playlistName]) {
            return item;
        }
    }
    return nil;
}

- (void)setPlaylist:(SongListModel *)playlist favourite:(BOOL)favourite {
    if (!playlist) return;

    UserModel *user = [UserModel sharedInstance];
    NSMutableArray<SongListModel *> *lists = [user.favouriteSongLists mutableCopy] ?: [NSMutableArray array];
    SongListModel *existing = [self favouritePlaylistMatching:playlist];

    if (favourite) {
        if (!existing) [lists addObject:playlist];   // 已收藏过就不重复加
    } else if (existing) {
        [lists removeObject:existing];                // 取消收藏：移除之前存的那一个
    }
    user.favouriteSongLists = [lists copy];

    [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"playlist": playlist,
                                                                 @"isFavourite": @(favourite)}];
}

- (BOOL)isFavouritePlaylist:(SongListModel *)playlist {
    return [self favouritePlaylistMatching:playlist] != nil;
}

@end
