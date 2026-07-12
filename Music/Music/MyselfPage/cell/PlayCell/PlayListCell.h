//
//  PlayListCell.h
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "SongList.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayListCell : UITableViewCell
@property (nonatomic, strong) SongList* songList;
@property (nonatomic, strong) UIImageView* coverView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* messageLabel;
- (void)configWithSongList: (SongList*) songList;
@end

NS_ASSUME_NONNULL_END
