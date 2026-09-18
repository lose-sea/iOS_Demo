//
//  HomeView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Song.h"
#import "Singer.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 复用标识

/// Section 0：横向歌单卡片容器 cell
UIKIT_EXTERN NSString *const HomePlaylistCardsCellID;
/// Section 1：歌曲行（系统 UITableViewCell + Subtitle 样式 + 更多按钮）
UIKIT_EXTERN NSString *const HomeSongCellID;

#pragma mark - Section 0：横向滚动里的单张歌单卡片

/// 方形封面 + 歌单名 + 描述，两行文字
@interface HomePlaylistCardCell : UICollectionViewCell

+ (CGSize)cardSize;
/// dict: image(图片名) / title(歌单名) / desc(描述)
- (void)configureWithData:(NSDictionary *)data;

@end

#pragma mark - Section 0：内嵌横向 UICollectionView 的 tableViewCell

@class HomePlaylistCardsCell;

@protocol HomePlaylistCardsCellDelegate <NSObject>
@optional
- (void)playlistCardsCell:(HomePlaylistCardsCell *)cell didSelectCardAtIndex:(NSInteger)index;
@end

/// 自身充当内部 collectionView 的 dataSource/delegate
@interface HomePlaylistCardsCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak, nullable) id<HomePlaylistCardsCellDelegate> delegate;
@property (nonatomic, copy) NSArray<NSDictionary *> *cards;

+ (CGFloat)rowHeight;

@end

#pragma mark - HomeView

@interface HomeView : UIView

@property (nonatomic, strong) UITableView *tableView;

/// 底部 miniPlayer 悬浮条（64pt 高）
@property (nonatomic, strong) UIView *miniPlayerView;
@property (nonatomic, strong) UIImageView *playerCoverView;
@property (nonatomic, strong) UILabel *playerTitleLabel;
@property (nonatomic, strong) UILabel *playerArtistLabel;
@property (nonatomic, strong) UIButton *playerPlayButton;

/// 任何界面调这个方法，miniPlayer 自动按播放状态刷新
- (void)configureWithSong:(nullable Song *)song isPlaying:(BOOL)playing;

@end

NS_ASSUME_NONNULL_END
