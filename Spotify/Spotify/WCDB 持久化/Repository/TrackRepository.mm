//
//  TrackRepository.mm
//  Spotify
//

#import "TrackRepository.h"
#import "Track+WCTTableCoding.h"
#import <WCDBObjc/WCDBObjc.h>
#import "WCDBManager.h"
#import "Song.h"
#import "Singer.h"

@implementation TrackRepository

+ (WCTDatabase *)db {
    return [WCDBManager shared].database;
}

+ (void)insertOrUpdateTrack:(Track *)track {
    if (!track) return;
    [[self db] insertOrReplaceObject:track intoTable:@"Track"];
}

+ (void)insertOrUpdateTracks:(NSArray<Track *> *)tracks {
    if (tracks.count == 0) return;
    [[self db] insertOrReplaceObjects:tracks intoTable:@"Track"];
}

+ (nullable Track *)trackWithId:(NSString *)trackId {
    if (trackId.length == 0) return nil;
    NSArray<Track *> *arr = [[self db] getObjectsOfClass:Track.class
                                               fromTable:@"Track"
                                                   where:Track.trackId == trackId];
    return arr.firstObject;
}

+ (NSArray<Track *> *)allTracks {
    NSArray<Track *> *arr = [[self db] getObjectsOfClass:Track.class fromTable:@"Track"];
    return arr ?: @[];
}

+ (NSArray<Track *> *)likedTracks {
    NSArray<Track *> *arr = [[self db] getObjectsOfClass:Track.class
                                               fromTable:@"Track"
                                                   where:Track.isLiked == YES];
    return arr ?: @[];
}

+ (void)setLiked:(BOOL)liked forTrackId:(NSString *)trackId {
    Track *t = [self trackWithId:trackId];
    if (!t) {
        t = [[Track alloc] init];
        t.trackId = trackId;
    }
    t.isLiked = liked;
    t.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
    [[self db] insertOrReplaceObject:t intoTable:@"Track"];
}

+ (void)setLocalPath:(nullable NSString *)path forTrackId:(NSString *)trackId {
    Track *t = [self trackWithId:trackId];
    if (!t) return;
    t.localPath = path;
    t.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
    [[self db] insertOrReplaceObject:t intoTable:@"Track"];
}

+ (nullable NSString *)localPathForTrackId:(NSString *)trackId {
    return [self trackWithId:trackId].localPath;
}

+ (void)setAudioURL:(NSString *)url forTrackId:(NSString *)trackId {
    if (trackId.length == 0 || url.length == 0) return;
    Track *t = [self trackWithId:trackId];
    if (!t) return;
    t.audioURL = url;
    t.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
    [[self db] insertOrReplaceObject:t intoTable:@"Track"];
}

+ (void)insertTrackIfAbsent:(Track *)track {
    if (!track || track.trackId.length == 0) return;
    if ([self trackWithId:track.trackId]) return;   // 已存在（可能带喜欢状态）则不覆盖
    [[self db] insertOrReplaceObject:track intoTable:@"Track"];
}

/// Song → Track 的字段映射集中在这里，FavouriteManager / UserModel 都走它，避免两处各写一遍
+ (nullable Track *)syncTrackFromSong:(Song *)song liked:(BOOL)liked {
    if (!song || song.songId.length == 0) return nil;   // 本地占位歌（无 id）不持久化
    Track *track = [[Track alloc] init];
    track.trackId  = song.songId;
    track.title    = song.songName;
    track.artist   = song.singer.singerName;
    track.coverURL = [Song secureURL:song.coverURL] ?: song.coverURL;
    track.audioURL = [Song secureURL:song.audioURL] ?: song.audioURL;
    track.duration = (NSInteger)song.duration;
    track.isLiked  = liked;
    track.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
    [[self db] insertOrReplaceObject:track intoTable:@"Track"];
    return track;
}

/// 仅映射，不落库（isLiked 不设置），给 PlaylistRepository 装配用
+ (nullable Track *)trackFromSong:(Song *)song {
    if (!song || song.songId.length == 0) return nil;
    Track *track = [[Track alloc] init];
    track.trackId  = song.songId;
    track.title    = song.songName;
    track.artist   = song.singer.singerName;
    track.coverURL = [Song secureURL:song.coverURL] ?: song.coverURL;
    track.audioURL = [Song secureURL:song.audioURL] ?: song.audioURL;
    track.duration = (NSInteger)song.duration;
    return track;
}

/// Track → Song 字段映射（还原展示 / 播放信息）
+ (nullable Song *)songFromTrack:(Track *)track {
    if (!track) return nil;
    Song *song = [[Song alloc] init];
    song.songId    = track.trackId;
    song.songName  = track.title;
    song.coverURL  = track.coverURL;
    song.audioURL  = track.audioURL;
    song.duration  = track.duration;
    song.canPlay   = YES;   // 还原的歌默认可播（canPlay 等字段未持久化，Demo 里视为可播）
    Singer *singer = [[Singer alloc] init];
    singer.singerName = track.artist;
    song.singer = singer;
    return song;
}

@end
