//
//  PlayerView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PlayerView;

@protocol PlayerViewDelegate <NSObject>

/// 点击了 mini player 非按钮区域，由控制器决定跳转
- (void)playerViewDidTapPlayer:(PlayerView *)playerView;

@end

@interface PlayerView : UIView

@property (nonatomic, weak, nullable) id<PlayerViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *singerLabel;


@property (nonatomic, strong) UIButton *favouriteButton;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIButton* nextButton;
@end

NS_ASSUME_NONNULL_END
