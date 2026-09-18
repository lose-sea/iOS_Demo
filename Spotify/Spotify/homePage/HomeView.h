//
//  HomeView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 复用标识

/// Section 0：横向歌单卡片容器 cell
UIKIT_EXTERN NSString *const HomePlaylistCardsCellID;
/// Section 1：歌曲行（系统 UITableViewCell，Subtitle 样式）
UIKIT_EXTERN NSString *const HomeSongCellID;

#pragma mark - Section 0：横向滚动里的单张歌单卡片

/// 方形封面 + 歌单名 + 描述，两行文字
@interface HomePlaylistCardCell : UICollectionViewCell

/// 卡片固定尺寸（宽度 = 封面边长，高度含两行文字）
+ (CGSize)cardSize;

/// dict 字段：image(图片名) / title(歌单名) / desc(描述)
- (void)configureWithData:(NSDictionary *)data;

@end

#pragma mark - Section 0：内嵌横向 UICollectionView 的 tableViewCell

@class HomePlaylistCardsCell;

@protocol HomePlaylistCardsCellDelegate <NSObject>
@optional
/// 点击了某张横向卡片
- (void)playlistCardsCell:(HomePlaylistCardsCell *)cell didSelectCardAtIndex:(NSInteger)index;
@end

/// 自身充当内部 collectionView 的 dataSource/delegate，
/// 由 HomeViewController 传入 cards 数据、设置 delegate 接收点击
@interface HomePlaylistCardsCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak, nullable) id<HomePlaylistCardsCellDelegate> delegate;

/// 卡片数据，元素为 NSDictionary（image / title / desc）
@property (nonatomic, copy) NSArray<NSDictionary *> *cards;

/// Section 0 的固定行高
+ (CGFloat)rowHeight;

@end

#pragma mark - HomeView

@interface HomeView : UIView
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *miniPlayerView; // 底部小播放器容器（UI）
@property (nonatomic, strong) UIImageView *playerCoverView;
@property (nonatomic, strong) UILabel *playerTitleLabel;
@property (nonatomic, strong) UILabel *playerArtistLabel;
@property (nonatomic, strong) UIButton *playerPlayButton;
@end

NS_ASSUME_NONNULL_END
