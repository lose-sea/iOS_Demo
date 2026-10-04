//
//  WCDBManager.h
//  Spotify
//

#import <Foundation/Foundation.h>
#import "Track.h"
#import "Playlist.h"
#import "PlaylistTrack.h"
#import "PlaybackState.h"

// 前向声明：避免 .h 引入 WCDB 的 C++ 头，否则引用此 .h 的纯 .m 文件（如 AppDelegate）会编译报错
@class WCTDatabase;

@interface WCDBManager : NSObject

@property (nonatomic, strong, readonly) WCTDatabase *database;

+ (instancetype)shared;
- (void)setup;

@end
