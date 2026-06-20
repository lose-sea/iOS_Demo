//
//  PlayListCell.h
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface PlayListCell : UITableViewCell
@property (nonatomic, strong) Song* song;
@property (nonatomic, strong) UIImageView* coverView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* messageLabel;
- (void)configWithSong: (Song*) song;
@end

NS_ASSUME_NONNULL_END
