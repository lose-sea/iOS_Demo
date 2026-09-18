//
//  PlayerView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : UIView
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *songerLabel;
@property (nonatomic, strong) UIButton *favouriteButton;
@property (nonatomic, strong) UIButton *playButton;
@end

NS_ASSUME_NONNULL_END
