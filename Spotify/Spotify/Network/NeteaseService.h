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

/// 网易云音乐开放平台服务（AppID/AppSecret/PrivateKey 方式接入）
///
/// ⚠️ 待补齐：签名与 access_token 流程需要按开放平台文档实现，
/// 目前除批量获取歌曲信息外，其余方法返回“未接入”错误。
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

@end

NS_ASSUME_NONNULL_END
