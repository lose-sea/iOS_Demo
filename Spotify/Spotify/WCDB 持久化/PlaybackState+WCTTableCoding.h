//
//  PlaybackState+WCTTableCoding.h
//  Spotify
//

#import "PlaybackState.h"
#import <WCDBObjc/WCDBObjc.h>

@interface PlaybackState (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(key)
WCDB_PROPERTY(currentTrackId)
WCDB_PROPERTY(position)
WCDB_PROPERTY(playlistId)
WCDB_PROPERTY(shuffle)
WCDB_PROPERTY(repeatMode)
WCDB_PROPERTY(updatedAt)

@end
