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

@end
