//
//  MyView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyModel;

@interface MyView : UIView

/// 歌单列表
@property (nonatomic, strong, readonly) UITableView *tableView;

/// 歌单切换条当前是否选中“收藏的歌单”
@property (nonatomic, assign, readonly) BOOL showingCollected;

/// 切换“创建的歌单 / 收藏的歌单”后回调（参数与 showingCollected 一致）
@property (nonatomic, copy, nullable) void (^onPlaylistTypeChanged)(BOOL showingCollected);
/// 点击 ＋ 创建歌单
@property (nonatomic, copy, nullable) void (^onCreatePlaylist)(void);

- (void)configureWithModel:(MyModel *)model;

/// 切换选中的分组（只更新样式，不触发 onPlaylistTypeChanged）
- (void)setTabShowingCollected:(BOOL)showingCollected;

/// 歌单切换条，用作 tableView 第 1 个分区的 section header
- (UIView *)playlistTabHeader;

@end

NS_ASSUME_NONNULL_END
