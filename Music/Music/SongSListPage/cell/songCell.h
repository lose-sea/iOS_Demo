//
//  songCell.h
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface songCell : UITableViewCell
@property (nonatomic, strong) UIImageView* coverView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* authorLabel;

- (void) configWithSong: (Song*) song; 
@end

NS_ASSUME_NONNULL_END
