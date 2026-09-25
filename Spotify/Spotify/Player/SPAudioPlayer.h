//
//  SPAudioPlayer.h
//  Spotify
//
//  全局唯一的音频引擎：封装 AVPlayer，对外只暴露「播 / 停 / 切 / seek」和几个通知。
//  音频源（Song.audioURL）既可以是网络地址，也可以是本地文件名：
//    - 以 http/https 开头  -> 直接当远程 URL 播（边下边播）
//    - 其他               -> 先在 mainBundle 里找，找不到再去沙盒 Documents 里找
//

#import <Foundation/Foundation.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

/// 切歌了（userInfo: song）
extern NSString *const SPAudioPlayerDidChangeSongNotification;
/// 播放状态变了（userInfo: playing）
extern NSString *const SPAudioPlayerPlaybackStateDidChangeNotification;
/// 播放进度回调，约每 0.5 秒一次（userInfo: currentTime / duration）
extern NSString *const SPAudioPlayerProgressNotification;
/// 一首歌自然播完（用于自动切下一首）
extern NSString *const SPAudioPlayerDidPlayToEndNotification;

@interface SPAudioPlayer : NSObject

+ (instancetype)sharedPlayer;

@property (nonatomic, strong, readonly, nullable) Song *currentSong;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;

/// 锁屏 / 控制中心点上一首、下一首时的回调，由 PlayerModel 赋值（避免播放器反向依赖业务层）
@property (nonatomic, copy, nullable) void (^nextTrackHandler)(void);
@property (nonatomic, copy, nullable) void (^previousTrackHandler)(void);

/// 换歌并立即播放
- (void)playSong:(Song *)song;
/// 只加载不播放（预置当前歌曲，等用户点播放再出声）
- (void)prepareSong:(Song *)song;
- (void)play;
- (void)pause;
/// 停止播放并丢弃当前资源
- (void)stop;

/// 按秒 seek
- (void)seekToTime:(NSTimeInterval)time;
/// 按 0~1 进度 seek
- (void)seekToProgress:(float)progress;

/// 把秒格式化成 m:ss
+ (NSString *)timeStringFromSeconds:(NSTimeInterval)seconds;

@end

NS_ASSUME_NONNULL_END
