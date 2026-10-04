//
//  CommentViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 歌曲评论页（抖音评论区风格）：展示评论 + 楼中楼、点赞、回复、评论数。
/// 由播放详情页以 page sheet 形式弹出。
@interface CommentViewController : UIViewController

- (instancetype)initWithSongId:(NSString *)songId songName:(NSString *)songName;

@end

NS_ASSUME_NONNULL_END
