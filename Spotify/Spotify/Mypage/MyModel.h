//
//  MyModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

/// “我的”页面数据：包装全局 UserModel 单例，对外提供页面用的只读视图
@interface MyModel : NSObject

@property (nonatomic, strong, readonly) UserModel *user;

@property (nonatomic, copy, readonly) NSString *level;
@property (nonatomic, assign, readonly) NSInteger recentCount;
@property (nonatomic, assign, readonly) NSInteger favouriteSongCount;
@property (nonatomic, assign, readonly) NSInteger favouritePlaylistCount;
@property (nonatomic, copy, readonly) NSArray<SongListModel *> *createdPlaylists;
@property (nonatomic, copy, readonly) NSArray<SongListModel *> *collectedPlaylists;
/// “我的喜欢”歌单：默认存在、不可删除
@property (nonatomic, strong, readonly) SongListModel *favouritePlaylist;

@end

NS_ASSUME_NONNULL_END
