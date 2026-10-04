//
//  PlaybackRepository.mm
//  Spotify
//

#import "PlaybackRepository.h"
#import "PlaybackState+WCTTableCoding.h"
#import <WCDBObjc/WCDBObjc.h>
#import "WCDBManager.h"

@implementation PlaybackRepository

+ (WCTDatabase *)db {
    return [WCDBManager shared].database;
}

+ (void)savePlaybackState:(PlaybackState *)state {
    if (!state) return;
    state.key = 0; // 单行表，固定主键
    state.updatedAt = (NSInteger)[NSDate date].timeIntervalSince1970;
    [[self db] insertOrReplaceObject:state intoTable:@"PlaybackState"];
}

+ (nullable PlaybackState *)currentPlaybackState {
    NSArray<PlaybackState *> *arr = [[self db] getObjectsOfClass:PlaybackState.class
                                                         fromTable:@"PlaybackState"
                                                             where:PlaybackState.key == 0];
    return arr.firstObject;
}

@end
