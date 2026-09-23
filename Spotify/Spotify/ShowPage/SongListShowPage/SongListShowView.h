//
//  SongListView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

NS_ASSUME_NONNULL_BEGIN

/// 歌曲行复用标识
UIKIT_EXTERN NSString *const SongListSongCellID;

@class SongListModel;

@interface SongListShowView : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;

/// 头部：封面 + 跑马灯歌单名 + 歌曲数 + 操作按钮
@property (nonatomic, strong, readonly) UIImageView *coverImageView;
@property (nonatomic, strong, readonly) MarqueeLabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *infoLabel;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *favouriteButton;
@property (nonatomic, strong, readonly) UIButton *moreButton;

+ (CGFloat)headerHeightForWidth:(CGFloat)width;

- (void)configureWithSongList:(SongListModel *)songList;

/// 歌单名在 tableHeaderView 内的底部 y，供控制器判断吸顶时机
- (CGFloat)nameLabelBottomInHeader;

@end

NS_ASSUME_NONNULL_END
