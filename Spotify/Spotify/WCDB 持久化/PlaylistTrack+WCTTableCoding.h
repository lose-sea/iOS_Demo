//
//  PlaylistTrack+WCTTableCoding.h
//  Spotify
//

#import "PlaylistTrack.h"
#import <WCDBObjc/WCDBObjc.h>

@interface PlaylistTrack (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(playlistId)
WCDB_PROPERTY(trackId)
WCDB_PROPERTY(sort)

@end
