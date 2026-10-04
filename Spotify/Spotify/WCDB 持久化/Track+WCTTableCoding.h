//
//  Track+WCTTableCoding.h
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import "Track.h"
#import <WCDBObjc/WCDBObjc.h>

@interface Track (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(trackId)
WCDB_PROPERTY(title)
WCDB_PROPERTY(artist)
WCDB_PROPERTY(album)
WCDB_PROPERTY(duration)
WCDB_PROPERTY(coverURL)
WCDB_PROPERTY(audioURL)
WCDB_PROPERTY(localPath)
WCDB_PROPERTY(isLiked)
WCDB_PROPERTY(updatedAt)

@end
