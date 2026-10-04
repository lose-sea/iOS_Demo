//
//  Playlist.h
//  Spotify
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject

@property (nonatomic, retain) NSString *playlistId;   // 歌单ID（主键）
@property (nonatomic, retain) NSString *name;          // 歌单名
@property (nonatomic, retain) NSString *coverURL;      // 封面远程地址
@property (nonatomic, retain) NSString *desc;          // 简介
@property (nonatomic, assign) NSInteger sort;          // 首页排序
@property (nonatomic, assign) NSInteger updatedAt;     // 缓存更新时间戳

@end
