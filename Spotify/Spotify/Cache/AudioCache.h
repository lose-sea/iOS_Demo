//
//  AudioCache.h
//  Spotify
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface AudioCache : NSObject

+ (instancetype)shared;

/// 下载并缓存音频到本地（Library/Caches/audio/），成功后回写 Track.localPath
/// completion 在主线程回调，返回本地路径或 error
- (void)cacheTrack:(Track *)track
        completion:(void (^)(NSString * _Nullable localPath, NSError * _Nullable error))completion;

/// 是否已缓存
- (BOOL)isCached:(NSString *)trackId;
/// 本地文件 URL（未缓存返回 nil）
- (nullable NSURL *)localURLForTrackId:(NSString *)trackId;

@end
