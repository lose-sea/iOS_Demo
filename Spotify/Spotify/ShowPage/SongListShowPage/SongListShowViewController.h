//
//  SongListViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import <UIKit/UIKit.h>
#import "SongListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SongListShowViewController : UIViewController

/// 要展示的歌单（push 前赋值）
@property (nonatomic, strong, nullable) SongListModel *songList;

/// 歌曲是异步拉回来的（首页榜单/艺人/专辑/电台卡片）：拉到后回填并刷新列表
- (void)updateWithSongs:(NSArray<Song *> *)songs;

@end

NS_ASSUME_NONNULL_END
