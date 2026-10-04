//
//  TrackRepository.mm
//  Spotify
//

#import "TrackRepository.h"
#import "Track+WCTTableCoding.h"
#import <WCDBObjc/WCDBObjc.h>
#import "WCDBManager.h"

@implementation TrackRepository

+ (WCTDatabase *)db {
    return [WCDBManager shared].database;
}

+ (void)insertOrUpdateTrack:(Track *)track {
    if (!track) return;
    [[self db] insertOrReplaceObject:track intoTable:@"Track"];
}

+ (void)insertOrUpdateTracks:(NSArray<Track *> *)tracks {
    if (tracks.count == 0) return;
    [[self db] insertOrReplaceObjects:tracks intoTable:@"Track"];
}

+ (nullable Track *)trackWithId:(NSString *)trackId {
    if (trackId.length == 0) return nil;
    NSArray<Track *> *arr = [[self db] getObjectsOfClass:Track.class
                                               fromTable:@"Track"
                                                   where:Track.trackId == trackId];
    return arr.firstObject;
}

+ (NSArray<Track *> *)allTracks {
    NSArray<Track *> *arr = [[self db] getObjectsOfClass:Track.class fromTable:@"Track"];
    return arr ?: @[];
}

+ (NSArray<Track *> *)likedTracks {
    NSArray<Track *> *arr = [[self db] getObjectsOfClass:Track.class
                                               fromTable:@"Track"
                                                   where:Track.isLiked == YES];
    return arr ?: @[];
}

+ (void)setLiked:(BOOL)liked forTrackId:(NSString *)trackId {
    Track *t = [self trackWithId:trackId];
    if (!t) return;
    t.isLiked = liked;
    t.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
    [[self db] insertOrReplaceObject:t intoTable:@"Track"];
}

+ (void)setLocalPath:(nullable NSString *)path forTrackId:(NSString *)trackId {
    Track *t = [self trackWithId:trackId];
    if (!t) return;
    t.localPath = path;
    t.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
    [[self db] insertOrReplaceObject:t intoTable:@"Track"];
}

+ (nullable NSString *)localPathForTrackId:(NSString *)trackId {
    return [self trackWithId:trackId].localPath;
}

@end
