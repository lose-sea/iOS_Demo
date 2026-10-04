//
//  Track.mm
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import "Track+WCTTableCoding.h"
#import "Track.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation Track

WCDB_IMPLEMENTATION(Track)

WCDB_SYNTHESIZE(trackId)
WCDB_SYNTHESIZE(title)
WCDB_SYNTHESIZE(artist)
WCDB_SYNTHESIZE(album)
WCDB_SYNTHESIZE(duration)
WCDB_SYNTHESIZE(coverURL)
WCDB_SYNTHESIZE(audioURL)
WCDB_SYNTHESIZE(localPath)
WCDB_SYNTHESIZE(isLiked)
WCDB_SYNTHESIZE(updatedAt)

WCDB_PRIMARY(trackId)
WCDB_INDEX("_idx_track_liked", isLiked)

@end
