//
//  PlaylistRepository.mm
//  Spotify
//

#import "PlaylistRepository.h"
#import "Playlist+WCTTableCoding.h"
#import "PlaylistTrack+WCTTableCoding.h"
#import "Track+WCTTableCoding.h"
#import <WCDBObjc/WCDBObjc.h>
#import "WCDBManager.h"
#import "TrackRepository.h"

@implementation PlaylistRepository

+ (WCTDatabase *)db {
    return [WCDBManager shared].database;
}

+ (void)insertOrUpdatePlaylist:(Playlist *)playlist {
    if (!playlist) return;
    [[self db] insertOrReplaceObject:playlist intoTable:@"Playlist"];
}

+ (void)insertOrUpdatePlaylists:(NSArray<Playlist *> *)playlists {
    if (playlists.count == 0) return;
    [[self db] insertOrReplaceObjects:playlists intoTable:@"Playlist"];
}

+ (NSArray<Playlist *> *)allPlaylists {
    NSArray<Playlist *> *arr = [[self db] getObjectsOfClass:Playlist.class fromTable:@"Playlist"];
    if (!arr) return @[];
    return [arr sortedArrayUsingComparator:^NSComparisonResult(Playlist *a, Playlist *b) {
        if (a.sort > b.sort) return NSOrderedDescending;
        if (a.sort < b.sort) return NSOrderedAscending;
        return NSOrderedSame;
    }];
}

+ (void)saveTracks:(NSArray<Track *> *)tracks forPlaylistId:(NSString *)playlistId {
    if (tracks.count == 0 || playlistId.length == 0) return;
    // 只补全曲目行：已存在的（可能带着「喜欢」等状态）不整体覆盖，避免首页缓存把喜欢冲掉
    for (Track *t in tracks) {
        if (t.trackId.length == 0) continue;
        NSArray<Track *> *exist = [[self db] getObjectsOfClass:Track.class
                                                    fromTable:@"Track"
                                                        where:Track.trackId == t.trackId];
        if (exist.count == 0) {
            [[self db] insertOrReplaceObject:t intoTable:@"Track"];
        }
    }

    NSMutableArray<PlaylistTrack *> *relations = [NSMutableArray array];
    NSInteger idx = 0;
    for (Track *t in tracks) {
        PlaylistTrack *rel = [[PlaylistTrack alloc] init];
        rel.playlistId = playlistId;
        rel.trackId = t.trackId;
        rel.sort = idx++;
        [relations addObject:rel];
    }
    [[self db] insertOrReplaceObjects:relations intoTable:@"PlaylistTrack"];
}

+ (NSArray<Track *> *)tracksInPlaylist:(NSString *)playlistId {
    if (playlistId.length == 0) return @[];
    NSArray<PlaylistTrack *> *relations = [[self db] getObjectsOfClass:PlaylistTrack.class
                                                              fromTable:@"PlaylistTrack"
                                                                  where:PlaylistTrack.playlistId == playlistId];
    if (relations.count == 0) return @[];
    NSArray<PlaylistTrack *> *sorted = [relations sortedArrayUsingComparator:^NSComparisonResult(PlaylistTrack *a, PlaylistTrack *b) {
        if (a.sort > b.sort) return NSOrderedDescending;
        if (a.sort < b.sort) return NSOrderedAscending;
        return NSOrderedSame;
    }];
    NSMutableArray<Track *> *tracks = [NSMutableArray array];
    for (PlaylistTrack *rel in sorted) {
        Track *t = [[self db] getObjectsOfClass:Track.class
                                      fromTable:@"Track"
                                          where:Track.trackId == rel.trackId].firstObject;
        if (t) [tracks addObject:t];
    }
    return tracks;
}

+ (void)removeTrackId:(NSString *)trackId fromPlaylist:(NSString *)playlistId {
    if (trackId.length == 0 || playlistId.length == 0) return;
    [[self db] deleteFromTable:@"PlaylistTrack"
                         where:(PlaylistTrack.playlistId == playlistId) && (PlaylistTrack.trackId == trackId)];
}

+ (void)deletePlaylist:(NSString *)playlistId {
    if (playlistId.length == 0) return;
    [[self db] deleteFromTable:@"Playlist" where:Playlist.playlistId == playlistId];
    [[self db] deleteFromTable:@"PlaylistTrack" where:PlaylistTrack.playlistId == playlistId];
}

#pragma mark - 最近播放（LRU）

static NSString * const kRecentPlaylistId = @"__recent__";
static const NSInteger kRecentMaxCount = 100;

+ (void)recordRecentTrack:(Track *)track {
    if (!track || track.trackId.length == 0) return;
    [TrackRepository insertTrackIfAbsent:track];   // 仅补全曲目行，不覆盖喜欢状态

    WCTDatabase *db = [self db];
    NSArray<PlaylistTrack *> *rels = [db getObjectsOfClass:PlaylistTrack.class
                                                fromTable:@"PlaylistTrack"
                                                    where:PlaylistTrack.playlistId == kRecentPlaylistId];

    // 先移除同一首已有的记录（保证唯一，稍后插到最前）
    for (PlaylistTrack *r in rels) {
        if ([r.trackId isEqualToString:track.trackId]) {
            [db deleteFromTable:@"PlaylistTrack"
                         where:(PlaylistTrack.playlistId == kRecentPlaylistId) && (PlaylistTrack.trackId == track.trackId)];
        }
    }

    // 排序值用自增计数：越大越新。取当前最大值 +1
    NSInteger nextSort = 0;
    for (PlaylistTrack *r in rels) {
        if (r.sort >= nextSort) nextSort = r.sort + 1;
    }
    PlaylistTrack *rel = [[PlaylistTrack alloc] init];
    rel.playlistId = kRecentPlaylistId;
    rel.trackId = track.trackId;
    rel.sort = nextSort;
    [db insertOrReplaceObject:rel intoTable:@"PlaylistTrack"];

    // 超过上限：淘汰最旧的（sort 最小的若干首）
    NSArray<PlaylistTrack *> *all = [db getObjectsOfClass:PlaylistTrack.class
                                                fromTable:@"PlaylistTrack"
                                                    where:PlaylistTrack.playlistId == kRecentPlaylistId];
    if (all.count > kRecentMaxCount) {
        NSArray<PlaylistTrack *> *sorted = [all sortedArrayUsingComparator:^NSComparisonResult(PlaylistTrack *a, PlaylistTrack *b) {
            return a.sort < b.sort ? NSOrderedAscending : (a.sort > b.sort ? NSOrderedDescending : NSOrderedSame);
        }];
        for (NSUInteger i = 0; i < all.count - kRecentMaxCount; i++) {
            PlaylistTrack *old = sorted[i];
            [db deleteFromTable:@"PlaylistTrack"
                         where:(PlaylistTrack.playlistId == kRecentPlaylistId) && (PlaylistTrack.trackId == old.trackId)];
        }
    }
}

+ (NSArray<Track *> *)recentTracks {
    NSArray<PlaylistTrack *> *rels = [[self db] getObjectsOfClass:PlaylistTrack.class
                                                        fromTable:@"PlaylistTrack"
                                                            where:PlaylistTrack.playlistId == kRecentPlaylistId];
    // 新 → 旧
    NSArray<PlaylistTrack *> *sorted = [rels sortedArrayUsingComparator:^NSComparisonResult(PlaylistTrack *a, PlaylistTrack *b) {
        return b.sort < a.sort ? NSOrderedAscending : (b.sort > a.sort ? NSOrderedDescending : NSOrderedSame);
    }];
    NSMutableArray<Track *> *tracks = [NSMutableArray array];
    for (PlaylistTrack *rel in sorted) {
        Track *t = [TrackRepository trackWithId:rel.trackId];
        if (t) [tracks addObject:t];
        if (tracks.count >= kRecentMaxCount) break;
    }
    return tracks;
}

+ (NSInteger)recentCount {
    NSArray<PlaylistTrack *> *rels = [[self db] getObjectsOfClass:PlaylistTrack.class
                                                        fromTable:@"PlaylistTrack"
                                                            where:PlaylistTrack.playlistId == kRecentPlaylistId];
    return rels.count;
}

@end
