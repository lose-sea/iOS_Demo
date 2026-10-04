//
//  TrackRepository.h
//  Spotify
//

#import <Foundation/Foundation.h>
#import "Track.h"

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
/// 音频下载完成后回写本地路径
+ (void)setLocalPath:(nullable NSString *)path forTrackId:(NSString *)trackId;
/// 读取本地音频路径（用于离线播放）
+ (nullable NSString *)localPathForTrackId:(NSString *)trackId;

@end
