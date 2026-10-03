//
//  FavouriteManager.h
//  Spotify
//
//  Created by lose_sea on 2026/10/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Song.h"
#import "SongListModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 收藏状态变了（userInfo: song 或 playlist + isFavourite）
/// 播放器、「我的」页面、歌单详情页都监听它来刷新红心 / 数量
UIKIT_EXTERN NSString *const FavouriteDidChangeNotification;

/// 收藏统一管理：歌曲的喜欢 / 歌单的收藏，以及对应的状态判断
/// 数据仍然存在 UserModel 里，这里只负责「改 + 判断 + 发通知」；
/// 别的地方不要绕过它直接改 song.isFavourite 或 favoriteSongs
@interface FavouriteManager : NSObject

/// 全局唯一实例
+ (instancetype)sharedInstance;

#pragma mark - 收藏歌曲

/// 统一入口：改歌曲状态 + 同步「我的喜欢」歌单 + 发通知
/// 喜欢 → 加入歌单；取消喜欢 → 从歌单里移除
- (void)setSong:(Song *)song favourite:(BOOL)favourite;
/// 取反
- (void)toggleFavouriteForSong:(Song *)song;
/// 这首歌是否已收藏：优先按 songId 匹配，同一首歌的不同实例结果一致
- (BOOL)isFavouriteSong:(Song *)song;

#pragma mark - 收藏歌单

/// 收藏 / 取消收藏歌单：加入 / 移出 favouriteSongLists
/// 首页卡片每次都是新建的 SongListModel，所以按 playlistId → 歌单名匹配，不会重复添加
- (void)setPlaylist:(SongListModel *)playlist favourite:(BOOL)favourite;
/// 这个歌单是否已收藏
- (BOOL)isFavouritePlaylist:(SongListModel *)playlist;

@end

NS_ASSUME_NONNULL_END
