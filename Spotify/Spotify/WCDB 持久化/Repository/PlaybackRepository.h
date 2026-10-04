//
//  PlaybackRepository.h
//  Spotify
//

#import <Foundation/Foundation.h>
#import "PlaybackState.h"

@interface PlaybackRepository : NSObject

/// 保存当前播放进度/状态（固定单行，key=0，跨启动续播）
+ (void)savePlaybackState:(PlaybackState *)state;
/// 读取上次的播放状态，没有则返回 nil
+ (nullable PlaybackState *)currentPlaybackState;

@end
