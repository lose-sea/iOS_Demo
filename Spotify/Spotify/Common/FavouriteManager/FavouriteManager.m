//
//  FavouriteManager.m
//  Spotify
//
//  Created by lose_sea on 2026/10/1.
//

#import "FavouriteManager.h"
#import "UserModel.h"

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

- (void)setSong:(Song *)song favourite:(BOOL)favourite {
    if (!song) return;

    UserModel *user = [UserModel sharedInstance];

    song.isFavourite = favourite;

    NSMutableArray<Song *> *songs = [user.favoriteSongs mutableCopy] ?: [NSMutableArray array];
    if (favourite) {
        if (![songs containsObject:song]) {
            [songs addObject:song];     // 新喜欢的歌排到最后
        }
    } else {
        [songs removeObject:song];      // 取消喜欢就从「我的喜欢」里移除
    }
    user.favoriteSongs = [songs copy];

    [[NSNotificationCenter defaultCenter] postNotificationName:FavouriteDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"song": song,
                                                                 @"isFavourite": @(favourite)}];
}

- (void)toggleFavouriteForSong:(Song *)song {
    [self setSong:song favourite:!song.isFavourite];
}

- (BOOL)isFavouriteSong:(Song *)song {
    return song ? [[UserModel sharedInstance].favoriteSongs containsObject:song] : NO;
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
