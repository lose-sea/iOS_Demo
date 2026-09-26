//
//  HomeViewTableViewCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Song;
@class SongRowCell;

@protocol HomeViewTableViewCellDelegate <NSObject>

/// 点击行内的收藏（爱心）按钮
- (void)songCellDidTapFavourite:(SongRowCell *)cell;
/// 点击行内的播放按钮
- (void)songCellDidTapPlay:(SongRowCell *)cell;

@end

/// 歌曲行：封面 + 歌名 + 歌手 + 收藏 + 播放
@interface SongRowCell : UITableViewCell

@property (nonatomic, weak, nullable) id<HomeViewTableViewCellDelegate> delegate;

/// 行高
+ (CGFloat)rowHeight;

@property (nonatomic, strong, readonly) UIButton *favouriteButton;
@property (nonatomic, strong, readonly) UIButton *playButton;

/// isPlaying：这首歌是否正在播放（是则显示暂停图标）
- (void)configureWithSong:(Song *)song isPlaying:(BOOL)isPlaying;

@end

NS_ASSUME_NONNULL_END
