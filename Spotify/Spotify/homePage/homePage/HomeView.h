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
#import <Masonry/Masonry.h> 

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 复用标识

///横向歌单卡片容器 cell
UIKIT_EXTERN NSString *const HomePlaylistCardsCellID;
///歌曲行（系统 UITableViewCell + Subtitle 样式 + 更多按钮）
UIKIT_EXTERN NSString *const HomeSongCellID;



#pragma mark - HomeView

@interface HomeView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *playerCoverView;
@property (nonatomic, strong) UILabel *playerTitleLabel;
@property (nonatomic, strong) UILabel *playerArtistLabel;
@property (nonatomic, strong) UIButton *playerPlayButton;


@end
NS_ASSUME_NONNULL_END
