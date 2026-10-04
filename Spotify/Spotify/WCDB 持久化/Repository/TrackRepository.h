//
//  TrackRepository.h
//  Spotify
//

#import <Foundation/Foundation.h>
#import "Track.h"

@class Song;

@interface TrackRepository : NSObject

/// 新增或更新单曲（按 trackId 主键 upsert）
+ (void)insertOrUpdateTrack:(Track *)track;
+ (void)insertOrUpdateTracks:(NSArray<Track *> *)tracks;

/// 按 id 取单曲
+ (nullable Track *)trackWithId:(NSString *)trackId;
/// 所有单曲
+ (NSArray<Track *> *)allTracks;
/// 喜欢列表（isLiked == YES）
+ (NSArray<Track *> *)likedTracks;

/// 切换喜欢状态
+ (void)setLiked:(BOOL)liked forTrackId:(NSString *)trackId;

/// 用 Song 的元数据 upsert 一条 Track 并写喜欢状态，返回组装好的 Track（供 FavouriteManager / UserModel 共用，避免字段映射重复）
/// songId 为空（本地占位歌）时返回 nil 且不落库
+ (nullable Track *)syncTrackFromSong:(Song *)song liked:(BOOL)liked;

/// 仅做 Song → Track 字段映射（不落库、不写 isLiked），给 PlaylistRepository 写关联前装配用
+ (nullable Track *)trackFromSong:(Song *)song;
/// Track → Song 字段映射（还原 Song 的展示 / 播放信息，canPlay 默认 YES），供各层从 L3 还原内存对象
+ (nullable Song *)songFromTrack:(Track *)track;
/// 音频下载完成后回写本地路径
+ (void)setLocalPath:(nullable NSString *)path forTrackId:(NSString *)trackId;
/// 读取本地音频路径（用于离线播放）
+ (nullable NSString *)localPathForTrackId:(NSString *)trackId;
/// 回写音频直链：L3 里缓存的曲目在播放地址现取后补上，方便离线续播
+ (void)setAudioURL:(NSString *)url forTrackId:(NSString *)trackId;
/// 仅当该 trackId 不存在时才插入（保留已有的 isLiked 等字段，供最近播放等场景用）
+ (void)insertTrackIfAbsent:(Track *)track;

@end
