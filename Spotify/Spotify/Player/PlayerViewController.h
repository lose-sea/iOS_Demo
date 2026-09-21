//
//  PlayerViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <UIKit/UIKit.h>
#import "PlayerModel.h"
#import "PlayerView.h"
#import "Song.h"
#import "Masonry.h"
#import "Singer.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayerViewController : UIViewController

+ (instancetype)sharedInstance;

/// 播放一首新歌曲：更新 PlayerModel 并开始播放
- (void)playSong:(Song *)song;

/// 暂停/继续（翻转 isPlay）
- (void)pressPlayButton;

- (Song *)currentSong;
- (BOOL)isPlaying;

@property (nonatomic, strong, readonly) PlayerModel *playerModel;
@property (nonatomic, strong, readonly) PlayerView *playerView;

@end

NS_ASSUME_NONNULL_END
