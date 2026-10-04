//
//  PlaybackState.mm
//  Spotify
//

#import "PlaybackState+WCTTableCoding.h"
#import "PlaybackState.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation PlaybackState

WCDB_IMPLEMENTATION(PlaybackState)

WCDB_SYNTHESIZE(key)
WCDB_SYNTHESIZE(currentTrackId)
WCDB_SYNTHESIZE(position)
WCDB_SYNTHESIZE(playlistId)
WCDB_SYNTHESIZE(shuffle)
WCDB_SYNTHESIZE(repeatMode)
WCDB_SYNTHESIZE(updatedAt)

WCDB_PRIMARY(key)

@end
