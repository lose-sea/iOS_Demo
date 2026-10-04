//
//  PlaylistTrack.mm
//  Spotify
//

#import "PlaylistTrack+WCTTableCoding.h"
#import "PlaylistTrack.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation PlaylistTrack

WCDB_IMPLEMENTATION(PlaylistTrack)

WCDB_SYNTHESIZE(playlistId)
WCDB_SYNTHESIZE(trackId)
WCDB_SYNTHESIZE(sort)

// 复合主键：(playlistId, trackId) —— 同一首歌在一个歌单里只出现一次
WCDB_MULTI_PRIMARY("_pk", playlistId)
WCDB_MULTI_PRIMARY("_pk", trackId)
WCDB_INDEX("_idx_pt_playlist", playlistId)

@end
