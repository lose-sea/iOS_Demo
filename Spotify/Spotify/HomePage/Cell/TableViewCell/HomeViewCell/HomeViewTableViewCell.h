//
//  HomeViewTableViewCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <UIKit/UIKit.h>

@class Song;

NS_ASSUME_NONNULL_BEGIN

/// 首页歌曲行：封面 + 歌名 + 歌手 + 更多按钮
@interface HomeViewTableViewCell : UITableViewCell

/// 行高
+ (CGFloat)rowHeight;

- (void)configureWithSong:(Song *)song;

@end

NS_ASSUME_NONNULL_END
