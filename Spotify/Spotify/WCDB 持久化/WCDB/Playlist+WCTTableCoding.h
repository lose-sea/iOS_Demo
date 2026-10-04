//
//  Playlist+WCTTableCoding.h
//  Spotify
//

#import "Playlist.h"
#import <WCDBObjc/WCDBObjc.h>

@interface Playlist (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(playlistId)
WCDB_PROPERTY(name)
WCDB_PROPERTY(coverURL)
WCDB_PROPERTY(desc)
WCDB_PROPERTY(sort)
WCDB_PROPERTY(updatedAt)

@end
