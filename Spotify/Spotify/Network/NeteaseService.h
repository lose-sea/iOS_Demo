//
//  NeteaseService.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Song;
@class SongListModel;
@class Singer;

/// 网易云音乐服务：本地 Node 接口（NeteaseCloudMusicApi，默认 http://localhost:3000）
///
/// 接学长博客那套本地服务即可，无需 AppID / 签名。
/// 模拟器 localhost 直连；真机需换 Mac 局域网 IP 并放行 ATS。
@interface NeteaseService : NSObject

+ (instancetype)sharedInstance;

/// 批量获取歌曲信息（ID 列表 → 歌曲详情）
/// 注意：这个接口**拿不到播放地址**，播放地址要单独调歌曲 URL 接口
- (void)fetchSongsWithIds:(NSArray<NSString *> *)songIds
              qualityFlag:(BOOL)qualityFlag
               completion:(void (^)(NSArray<Song *> *songs, NSError * _Nullable error))completion;

/// 搜索歌曲（等文档）
- (void)searchSongsWithKeyword:(NSString *)keyword
                         limit:(NSInteger)limit
                    completion:(void (^)(NSArray<Song *> *songs, NSError * _Nullable error))completion;

/// 获取歌曲播放地址（网易云的播放地址有时效，建议每次播放前现取）
- (void)fetchSongURLWithId:(NSString *)songId
                completion:(void (^)(NSString * _Nullable audioURL, NSError * _Nullable error))completion;

/// 歌单详情（含歌曲列表）
- (void)fetchPlaylistDetailWithId:(NSString *)playlistId
                       completion:(void (^)(SongListModel * _Nullable playlist, NSError * _Nullable error))completion;

/// 歌词（做歌词滚动时用）
- (void)fetchLyricWithId:(NSString *)songId
              completion:(void (^)(NSString * _Nullable lyric, NSError * _Nullable error))completion;

#pragma mark - 首页分区

/// 官方榜单列表（飙升榜 / 新歌榜 / 原创榜 …），首页快捷入口
- (void)fetchToplistWithLimit:(NSInteger)limit
                   completion:(void (^)(NSArray<SongListModel *> *playlists, NSError * _Nullable error))completion;

/// 热门歌手，首页「你喜欢的艺人」
- (void)fetchTopArtistsWithLimit:(NSInteger)limit
                      completion:(void (^)(NSArray<Singer *> *singers, NSError * _Nullable error))completion;

/// 热门电台，首页「推荐电台」（电台没有歌曲列表，点进去按电台名搜歌曲）
- (void)fetchHotRadiosWithLimit:(NSInteger)limit
                     completion:(void (^)(NSArray<SongListModel *> *radios, NSError * _Nullable error))completion;

/// 最新专辑，首页「收录你喜爱歌曲的专辑」
- (void)fetchNewAlbumsWithLimit:(NSInteger)limit
                     completion:(void (^)(NSArray<SongListModel *> *albums, NSError * _Nullable error))completion;

/// 艺人热门歌曲（点艺人卡时用）
- (void)fetchArtistSongsWithId:(NSString *)artistId
                    completion:(void (^)(NSArray<Song *> *songs, NSError * _Nullable error))completion;

/// 专辑歌曲（点专辑卡时用）
- (void)fetchAlbumSongsWithId:(NSString *)albumId
                   completion:(void (^)(NSArray<Song *> *songs, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
