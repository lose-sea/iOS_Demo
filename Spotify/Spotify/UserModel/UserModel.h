//
//  UserModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Song.h"
#import "Singer.h"
#import "SongListModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 某首歌的喜欢状态变了（userInfo: song / isFavourite），播放器、「我的」页面都要监听
UIKIT_EXTERN NSString *const UserModelFavouriteDidChangeNotification;

/// 全局当前用户（单例）：各页面统一通过 shareInstance 读写同一份数据
@interface UserModel : NSObject

@property (nonatomic, copy) NSString *user_name;
/// 头像地址：网络 URL 或本地资源名
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *email;
/// 账号等级，如 @"Lv.5"
@property (nonatomic, copy) NSString *level;

/// 最近播放的音乐
@property (nonatomic, copy) NSArray<Song *> *recentlySongs;
/// 我喜欢的歌曲
@property (nonatomic, copy) NSArray<Song *> *favoriteSongs;
@property (nonatomic, copy) NSArray<Singer *> *favouriteSingers;
/// 我创建的歌单
@property (nonatomic, copy) NSArray<SongListModel *> *createSongLists;
/// 我收藏的歌单
@property (nonatomic, copy) NSArray<SongListModel *> *favouriteSongLists;

/// “我的喜欢”歌单：由 favoriteSongs 生成，默认存在、不可删除（isSystemPlaylist = YES）
- (SongListModel *)favouritePlaylist;

#pragma mark - 喜欢 / 取消喜欢

/// 统一的收藏入口：改歌曲状态 + 同步「我的喜欢」歌单 + 发通知
/// 喜欢 → 加入歌单；取消喜欢 → 从歌单里移除。别的地方不要再直接改 song.isFavourite
- (void)setSong:(Song *)song favourite:(BOOL)favourite;
/// 取反
- (void)toggleFavouriteForSong:(Song *)song;
/// 这首歌是否已收藏
- (BOOL)isFavouriteSong:(Song *)song;

/// 全局唯一实例
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
