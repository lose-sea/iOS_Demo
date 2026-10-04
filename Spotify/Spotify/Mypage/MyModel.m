//
//  MyModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import "MyModel.h"
#import "PlaylistRepository.h"

@implementation MyModel

// 全部转发给 UserModel 单例，页面数据变了其他页面立刻可见
- (UserModel *)user {
    return [UserModel sharedInstance];
}

- (NSString *)level {
    return self.user.level;
}

- (NSInteger)recentCount {
    return [PlaylistRepository recentCount];   // 实际播放历史（LRU，最多 100 首）
}

- (NSInteger)favouriteSongCount {
    return self.user.favoriteSongs.count;
}

- (NSInteger)favouritePlaylistCount {
    return self.user.favouriteSongLists.count;
}

- (NSArray<SongListModel *> *)createdPlaylists {
    return self.user.createSongLists;
}

- (NSArray<SongListModel *> *)collectedPlaylists {
    return self.user.favouriteSongLists;
}

- (SongListModel *)favouritePlaylist {
    return [self.user favouritePlaylist];
}

@end
