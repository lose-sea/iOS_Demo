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

@end

NS_ASSUME_NONNULL_END
