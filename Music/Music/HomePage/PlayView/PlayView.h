//
//  PlayView.h
//  Music
//
//  Created by lose_sea on 2026/6/14.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface PlayView : UIView
@property (nonatomic, strong) UIImageView* coverView;
@property (nonatomic, strong) UILabel* NameLabel;
@property (nonatomic, strong) UILabel* artistLabel;
@property (nonatomic, strong) UIButton* playButton;
@property (nonatomic, strong) UIButton* likeButton;
@property (nonatomic, strong) UIButton* menuButton;

@property (nonatomic, strong) Song* song;

- (void)configWithSong: (Song*) song;
@end

NS_ASSUME_NONNULL_END
