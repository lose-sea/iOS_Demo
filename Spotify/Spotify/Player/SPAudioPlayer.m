//
//  SPAudioPlayer.m
//  Spotify
//

#import "SPAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <SDWebImage/SDWebImage.h>
#import "UIImageView+Spotify.h"
#import "Singer.h"

NSString *const SPAudioPlayerDidChangeSongNotification        = @"SPAudioPlayerDidChangeSongNotification";
NSString *const SPAudioPlayerPlaybackStateDidChangeNotification = @"SPAudioPlayerPlaybackStateDidChangeNotification";
NSString *const SPAudioPlayerProgressNotification             = @"SPAudioPlayerProgressNotification";
NSString *const SPAudioPlayerDidPlayToEndNotification         = @"SPAudioPlayerDidPlayToEndNotification";

static void *SPPlayerItemStatusContext = &SPPlayerItemStatusContext;

@interface SPAudioPlayer ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong, readwrite, nullable) AVPlayerItem *currentItem;
@property (nonatomic, strong, nullable) id timeObserver;
/// 加载失败时的重试次数（每首歌最多重试一次）
@property (nonatomic, assign) NSInteger retryCount;

@property (nonatomic, strong, readwrite, nullable) Song *currentSong;
@property (nonatomic, assign, readwrite) NSTimeInterval duration;
@property (nonatomic, assign, readwrite, getter=isPlaying) BOOL playing;

/// 锁屏封面（异步下载后缓存）
@property (nonatomic, strong, nullable) UIImage *coverImage;
/// 加载中的封面地址，避免旧图覆盖新图
@property (nonatomic, copy, nullable) NSString *loadingCoverSource;

@end

@implementation SPAudioPlayer

+ (instancetype)sharedPlayer {
    static SPAudioPlayer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SPAudioPlayer alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpAudioSession];
        [self setUpPlayer];
        [self setUpRemoteCommands];
    }
    return self;
}

#pragma mark - 初始化

- (void)setUpAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    // 后台 + 静音开关下也能出声
    [session setCategory:AVAudioSessionCategoryPlayback
                    mode:AVAudioSessionModeDefault
                 options:0
                   error:&error];
    if (error) {
        NSLog(@"[SPAudioPlayer] AudioSession 配置失败：%@", error);
    }
}

- (void)setUpPlayer {
    self.player = [[AVPlayer alloc] init];
    // iOS 10+ 默认就会在缓冲结束后继续播，这里显式打开更稳
    self.player.automaticallyWaitsToMinimizeStalling = YES;

    __weak typeof(self) weakSelf = self;
    CMTime interval = CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:^(CMTime time) {
        [weakSelf postProgress];
    }];
}

- (void)setUpRemoteCommands {
    MPRemoteCommandCenter *center = [MPRemoteCommandCenter sharedCommandCenter];
    __weak typeof(self) weakSelf = self;

    center.playCommand.enabled = YES;
    center.pauseCommand.enabled = YES;
    center.togglePlayPauseCommand.enabled = YES;
    center.nextTrackCommand.enabled = YES;
    center.previousTrackCommand.enabled = YES;
    center.changePlaybackPositionCommand.enabled = YES;

    [center.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [weakSelf play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [weakSelf pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        weakSelf.isPlaying ? [weakSelf pause] : [weakSelf play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        if (weakSelf.nextTrackHandler) weakSelf.nextTrackHandler();
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        if (weakSelf.previousTrackHandler) weakSelf.previousTrackHandler();
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        MPChangePlaybackPositionCommandEvent *positionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [weakSelf seekToTime:positionEvent.positionTime];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)dealloc {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeItemObservers];
}

#pragma mark - Public

/// 只加载不播放：用于「进入 App 时预置一首歌，等用户点播放再出声」
- (void)prepareSong:(Song *)song {
    [self loadSong:song];
    [self updateNowPlayingInfo];
}

- (void)playSong:(Song *)song {
    if (![self loadSong:song]) return;
    [self play];
}

/// 换上新的音频源，成功返回 YES
- (BOOL)loadSong:(Song *)song {
    NSURL *url = [self audioURLForSource:song.audioURL];
    if (!url) {
        NSLog(@"[SPAudioPlayer] 这首歌没有可用的音频源：%@（audioURL=%@）", song.songName, song.audioURL);
        [self stop];
        return NO;
    }

    NSLog(@"[SPAudioPlayer] 加载音频源：%@ → %@", song.songName, url.absoluteString);
    self.currentSong = song;
    self.duration = 0;
    self.retryCount = 0;    // 换歌时重置重试次数
    self.coverImage = nil;
    [self loadCoverForSong:song];

    [self removeItemObservers];

    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.currentItem = item;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidPlayToEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    [item addObserver:self
           forKeyPath:@"status"
              options:NSKeyValueObservingOptionNew
              context:SPPlayerItemStatusContext];

    [self.player replaceCurrentItemWithPlayerItem:item];

    [[NSNotificationCenter defaultCenter] postNotificationName:SPAudioPlayerDidChangeSongNotification
                                                        object:self
                                                      userInfo:@{@"song": song}];
    return YES;
}

- (void)play {
    if (!self.currentItem) {
        if (self.currentSong) [self playSong:self.currentSong];
        return;
    }

    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error) NSLog(@"[SPAudioPlayer] AudioSession 激活失败：%@", error);

    [self.player play];
    self.playing = YES;
    [self postStateChange];
    [self updateNowPlayingInfo];
}

- (void)pause {
    [self.player pause];
    self.playing = NO;
    [self postStateChange];
    [self updateNowPlayingInfo];
}

- (void)stop {
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self removeItemObservers];
    self.currentItem = nil;
    self.currentSong = nil;
    self.duration = 0;
    self.playing = NO;
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
    [self postStateChange];
}

- (NSTimeInterval)currentTime {
    if (!self.currentItem) return 0;
    CMTime time = self.player.currentTime;
    if (!CMTIME_IS_VALID(time)) return 0;
    NSTimeInterval seconds = CMTimeGetSeconds(time);
    return isnan(seconds) ? 0 : seconds;
}

- (void)seekToTime:(NSTimeInterval)time {
    if (!self.currentItem) return;
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)
            toleranceBefore:kCMTimeZero
             toleranceAfter:kCMTimeZero
          completionHandler:^(BOOL finished) {
        if (finished) {
            [self postProgress];
            [self updateNowPlayingInfo];
        }
    }];
}

- (void)seekToProgress:(float)progress {
    if (self.duration <= 0) return;
    progress = MIN(MAX(progress, 0.0f), 1.0f);
    [self seekToTime:self.duration * progress];
}

+ (NSString *)timeStringFromSeconds:(NSTimeInterval)seconds {
    if (!isnan(seconds) && seconds >= 0) {
        NSInteger total = (NSInteger)seconds;
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)(total / 60), (long)(total % 60)];
    }
    return @"00:00";
}

#pragma mark - 播放源解析

/// http(s) 走网络；否则依次在 mainBundle、沙盒 Documents 里找同名文件
- (nullable NSURL *)audioURLForSource:(nullable NSString *)source {
    if (source.length == 0) return nil;

    if ([source hasPrefix:@"http://"] || [source hasPrefix:@"https://"]) {
        // http 一律升到 https：ATS 会拦 http，各家 CDN 基本都支持 https
        NSString *httpsSource = source;
        if ([source hasPrefix:@"http://"]) {
            httpsSource = [@"https://" stringByAppendingString:[source substringFromIndex:7]];
        }

        NSURL *url = [NSURL URLWithString:httpsSource];
        if (url) return url;

        // 地址里有中文 / 空格等字符时兜底编码一次
        NSString *encoded = [httpsSource stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return [NSURL URLWithString:encoded];
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:source.stringByDeletingPathExtension
                                                    ofType:source.pathExtension];
    if (!path) path = [[NSBundle mainBundle] pathForResource:source ofType:nil];
    if (!path && [source hasPrefix:@"/"]) path = source;
    if (!path) {
        NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *candidate = [docs stringByAppendingPathComponent:source];
        if ([[NSFileManager defaultManager] fileExistsAtPath:candidate]) path = candidate;
    }

    return path ? [NSURL fileURLWithPath:path] : nil;
}

#pragma mark - 通知

- (void)postProgress {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"currentTime"] = @(self.currentTime);
    userInfo[@"duration"] = @(self.duration);
    [[NSNotificationCenter defaultCenter] postNotificationName:SPAudioPlayerProgressNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)postStateChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:SPAudioPlayerPlaybackStateDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"playing": @(self.playing)}];
}

- (void)itemDidPlayToEnd:(NSNotification *)notification {
    self.playing = NO;
    [self postStateChange];
    [[NSNotificationCenter defaultCenter] postNotificationName:SPAudioPlayerDidPlayToEndNotification
                                                        object:self
                                                      userInfo:self.currentSong ? @{@"song": self.currentSong} : nil];
}

#pragma mark - KVO

- (void)removeItemObservers {
    if (self.currentItem) {
        [self.currentItem removeObserver:self forKeyPath:@"status" context:SPPlayerItemStatusContext];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.currentItem];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if (context != SPPlayerItemStatusContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlayerItemStatus status = (AVPlayerItemStatus)[change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            CMTime duration = self.currentItem.duration;
            if (CMTIME_IS_VALID(duration)) {
                self.duration = CMTimeGetSeconds(duration);
            }
            [self updateNowPlayingInfo];
            [self postProgress];
        } else if (status == AVPlayerItemStatusFailed) {
            NSError *error = self.currentItem.error;
            NSLog(@"[SPAudioPlayer] 加载失败：%@", error);
            NSLog(@"[SPAudioPlayer] 失败详情：%@", error.userInfo);
            NSLog(@"[SPAudioPlayer] 常见原因：音频地址 403/404（接口配额超限或地址过期）、"
                  @"地址不是真正的音频文件、或网络不可达。把日志里的 URL 粘到浏览器里试一下就知道。");

            // 网络抖动导致的失败重试一次
            if (self.retryCount == 0 && self.currentSong) {
                self.retryCount = 1;
                NSLog(@"[SPAudioPlayer] 0.5s 后重试一次：%@", self.currentSong.songName);
                __weak typeof(self) weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                    if (weakSelf.currentSong) [weakSelf loadSong:weakSelf.currentSong];
                });
                return;
            }

            self.playing = NO;
            [self postStateChange];
        }
    });
}

#pragma mark - 锁屏 / 控制中心信息

- (void)loadCoverForSong:(Song *)song {
    NSString *source = song.coverURL;
    self.loadingCoverSource = source;
    if (source.length == 0) return;

    if ([source hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:source];
        __weak typeof(self) weakSelf = self;
        [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                    options:SDWebImageRetryFailed
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image && [weakSelf.loadingCoverSource isEqualToString:source]) {
                weakSelf.coverImage = image;
                [weakSelf updateNowPlayingInfo];
            }
        }];
    } else {
        self.coverImage = [UIImage imageNamed:source];
    }
}

- (void)updateNowPlayingInfo {
    Song *song = self.currentSong;
    if (!song) {
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        return;
    }

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MPMediaItemPropertyTitle] = song.songName ?: @"";
    info[MPMediaItemPropertyArtist] = song.singer.singerName ?: @"";
    info[MPMediaItemPropertyPlaybackDuration] = @(self.duration);
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.currentTime);
    info[MPNowPlayingInfoPropertyPlaybackRate] = @(self.isPlaying ? 1.0 : 0.0);

    if (self.coverImage) {
        UIImage *cover = self.coverImage;
        info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithBoundsSize:cover.size
                                                                           requestHandler:^UIImage *(CGSize size) {
            return cover;
        }];
    }

    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
}

@end
