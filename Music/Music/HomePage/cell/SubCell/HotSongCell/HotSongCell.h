//
//  HotSongCell.h
//  Music
//
//  Created by lose_sea on 2026/6/13.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface HotSongCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UIButton* playButton;
@property (nonatomic, strong) UIButton* likeButton; 

@property (nonatomic, strong) Song* song;

- (void) configWithSong: (Song*) song; 
@end

NS_ASSUME_NONNULL_END
