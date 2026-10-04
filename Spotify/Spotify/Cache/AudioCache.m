//
//  AudioCache.m
//  Spotify
//

#import "AudioCache.h"
#import "TrackRepository.h"

@interface AudioCache ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSCache<NSString *, NSNumber *> *downloading; // trackId -> @(YES) 防重复下载
@end

@implementation AudioCache

+ (instancetype)shared {
    static AudioCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AudioCache alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _session = [NSURLSession sharedSession];
        _downloading = [[NSCache alloc] init];
    }
    return self;
}

- (NSString *)cacheDir {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES).firstObject
                    stringByAppendingPathComponent:@"audio"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return dir;
}

- (NSString *)localPathForTrackId:(NSString *)trackId extension:(NSString *)ext {
    NSString *name = [NSString stringWithFormat:@"%@.%@", trackId, ext.length ? ext : @"mp3"];
    return [[self cacheDir] stringByAppendingPathComponent:name];
}

- (BOOL)isCached:(NSString *)trackId {
    return trackId.length > 0 &&
           [[NSFileManager defaultManager] fileExistsAtPath:[self localPathForTrackId:trackId extension:@"mp3"]];
}

- (NSURL *)localURLForTrackId:(NSString *)trackId {
    if (![self isCached:trackId]) return nil;
    return [NSURL fileURLWithPath:[self localPathForTrackId:trackId extension:@"mp3"]];
}

- (void)cacheTrack:(Track *)track
        completion:(void (^)(NSString * _Nullable, NSError * _Nullable))completion {
    if (!track || track.audioURL.length == 0) {
        if (completion) completion(nil, [NSError errorWithDomain:@"AudioCache" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"track 或 audioURL 为空"}]);
        return;
    }
    NSString *trackId = track.trackId;
    if ([self.downloading objectForKey:trackId]) {
        return; // 正在下载，忽略重复请求
    }
    [self.downloading setObject:@(YES) forKey:trackId];

    NSURL *remote = [NSURL URLWithString:track.audioURL];
    [[self.session downloadTaskWithURL:remote completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        [self.downloading removeObjectForKey:trackId];
        if (error || !location) {
            if (completion) completion(nil, error);
            return;
        }
        NSString *ext = response.URL.pathExtension.length ? response.URL.pathExtension : track.audioURL.pathExtension;
        NSString *dest = [self localPathForTrackId:trackId extension:ext];
        [[NSFileManager defaultManager] removeItemAtPath:dest error:nil];
        BOOL ok = [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:dest error:nil];
        if (ok) {
            // 回写本地路径到数据库
            [TrackRepository setLocalPath:dest forTrackId:trackId];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(ok ? dest : nil, ok ? nil : [NSError errorWithDomain:@"AudioCache" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"保存失败"}]);
        });
    }] resume];
}

@end
