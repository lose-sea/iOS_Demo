//
//  PlaylistRepository.h
//  Spotify
//

#import <Foundation/Foundation.h>
#import "Playlist.h"
#import "Track.h"

@interface PlaylistRepository : NSObject

/// 新增或更新歌单
+ (void)insertOrUpdatePlaylist:(Playlist *)playlist;
+ (void)insertOrUpdatePlaylists:(NSArray<Playlist *> *)playlists;
/// 首页所有歌单（按 sort 升序）
+ (NSArray<Playlist *> *)allPlaylists;

/// 保存一个歌单里的曲目：先 upsert 曲目，再写入歌单-曲目关联（按数组顺序）
+ (void)saveTracks:(NSArray<Track *> *)tracks forPlaylistId:(NSString *)playlistId;
/// 某个歌单内的曲目（按排序返回）
+ (NSArray<Track *> *)tracksInPlaylist:(NSString *)playlistId;
/// 从歌单移除某首歌
+ (void)removeTrackId:(NSString *)trackId fromPlaylist:(NSString *)playlistId;
/// 删除歌单（同时清理关联）
+ (void)deletePlaylist:(NSString *)playlistId;

@end
