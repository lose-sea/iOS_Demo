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

/// 全局当前用户（单例）：各页面统一通过 sharedInstance 读写同一份数据
/// 只存数据；收藏 / 取消收藏请走 FavouriteManager
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

#pragma mark - 歌单增删（收藏 / 取消收藏歌单走 FavouriteManager）

/// 把歌曲加进一个「我创建的歌单」（已存在则不重复添加）
/// createSongLists 里存的就是这批 SongListModel 实例，改它的 songs 即生效
- (void)addSong:(Song *)song toPlaylist:(SongListModel *)playlist;

/// 删除一个「我创建的歌单」（系统歌单如“我的喜欢”不在 createSongLists 里，删不掉）
- (void)removeCreatedPlaylist:(SongListModel *)playlist;

/// 全局唯一实例
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
