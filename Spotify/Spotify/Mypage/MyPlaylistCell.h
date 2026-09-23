//
//  MyPlaylistCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SongListModel;

/// “我的”页面歌单行：封面 + 歌单名 + 副信息
@interface MyPlaylistCell : UITableViewCell

/// 行高
+ (CGFloat)rowHeight;

- (void)configureWithPlaylist:(SongListModel *)playlist;

@end

NS_ASSUME_NONNULL_END
