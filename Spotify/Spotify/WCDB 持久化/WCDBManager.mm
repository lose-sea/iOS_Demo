//
//  WCDBManager.mm
//  Spotify
//

#import "WCDBManager.h"
#import <WCDBObjc/WCDBObjc.h>

@implementation WCDBManager

+ (instancetype)shared {
    static WCDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WCDBManager alloc] init];
    });
    return manager;
}

- (void)setup {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                         NSUserDomainMask, YES);
    NSString *dir = [paths.firstObject stringByAppendingPathComponent:@"WCDB"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    NSString *path = [dir stringByAppendingPathComponent:@"spotify.db"];
    _database = [[WCTDatabase alloc] initWithPath:path];

    BOOL ok = YES;
    ok &= [_database createTable:@"Track" withClass:Track.class];
    ok &= [_database createTable:@"Playlist" withClass:Playlist.class];
    ok &= [_database createTable:@"PlaylistTrack" withClass:PlaylistTrack.class];
    ok &= [_database createTable:@"PlaybackState" withClass:PlaybackState.class];
    if (!ok) {
        NSLog(@"[WCDBManager] 建表失败，请检查 WCDB 配置");
    }
}

@end
