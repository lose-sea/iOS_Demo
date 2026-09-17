////
////  HomeView.h
////  Spotify
////
////  Created by lose_sea on 2026/9/2.
////
//
//#import <UIKit/UIKit.h>
//#import <Masonry/Masonry.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface HomeView : UIView
//@property (nonatomic, strong) UITableView* tableView;
//@end
//
//NS_ASSUME_NONNULL_END//
//  HomeView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//







#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeView : UIView
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* miniPlayerView; // 底部小播放器容器（UI）
@property (nonatomic, strong) UIImageView* playerCoverView;
@property (nonatomic, strong) UILabel* playerTitleLabel;
@property (nonatomic, strong) UILabel* playerArtistLabel;
@property (nonatomic, strong) UIButton* playerPlayButton;
@end

NS_ASSUME_NONNULL_END





