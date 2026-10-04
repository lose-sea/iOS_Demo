//
//  PlaybackState.h
//  Spotify
//

#import <Foundation/Foundation.h>

@interface PlaybackState : NSObject

@property (nonatomic, assign) NSInteger key;          // 固定写 0，单行表
@property (nonatomic, retain) NSString *currentTrackId; // 当前播放曲目ID
@property (nonatomic, assign) NSInteger position;     // 播放进度（秒）
@property (nonatomic, retain) NSString *playlistId;   // 所在歌单ID
@property (nonatomic, assign) BOOL shuffle;            // 是否随机
@property (nonatomic, assign) NSInteger repeatMode;   // 0 顺序 1 单曲循环 2 列表循环
@property (nonatomic, assign) NSInteger updatedAt;    // 更新时间戳

@end
