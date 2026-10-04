//
//  Playlist.mm
//  Spotify
//

#import "Playlist+WCTTableCoding.h"
#import "Playlist.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation Playlist

WCDB_IMPLEMENTATION(Playlist)

WCDB_SYNTHESIZE(playlistId)
WCDB_SYNTHESIZE(name)
WCDB_SYNTHESIZE(coverURL)
WCDB_SYNTHESIZE(desc)
WCDB_SYNTHESIZE(sort)
WCDB_SYNTHESIZE(updatedAt)

WCDB_PRIMARY(playlistId)

@end
