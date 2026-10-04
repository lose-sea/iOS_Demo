//
//  Track.h
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (nonatomic, retain) NSString *trackId;     // 服务端曲目ID（主键）
@property (nonatomic, retain) NSString *title;        // 歌名
@property (nonatomic, retain) NSString *artist;       // 歌手
@property (nonatomic, retain) NSString *album;        // 专辑
@property (nonatomic, assign) NSInteger duration;     // 时长（秒）
@property (nonatomic, retain) NSString *coverURL;     // 封面远程地址
@property (nonatomic, retain) NSString *audioURL;     // 音频远程地址
@property (nonatomic, retain) NSString *localPath;    // 本地音频缓存路径（未下载为 nil）
@property (nonatomic, assign) BOOL isLiked;            // 是否喜欢
@property (nonatomic, assign) NSInteger updatedAt;    // 缓存更新时间戳

@end
