//
//  PlayerDetailView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 全屏播放页布局：关闭 + 旋转封面 + 歌词占位 + 歌曲信息 + 进度条 + 按钮行
@interface PlayerDetailView : UIView

/// 顶部关闭
@property (nonatomic, strong, readonly) UIButton *closeButton;

/// 中部封面（播放时旋转）
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

/// 歌词区（当前行 + 下一行，接网络后由歌词数据驱动滚动）
@property (nonatomic, strong, readonly) UILabel *currentLyricsLabel;
@property (nonatomic, strong, readonly) UILabel *nextLyricsLabel;

/// 歌曲信息
@property (nonatomic, strong, readonly) UILabel *songNameLabel;
@property (nonatomic, strong, readonly) UILabel *singerLabel;

/// 进度
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;
@property (nonatomic, strong, readonly) UILabel *durationLabel;

/// 按钮行
@property (nonatomic, strong, readonly) UIButton *favouriteButton;
@property (nonatomic, strong, readonly) UIButton *commentButton;
@property (nonatomic, strong, readonly) UIButton *previousButton;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *nextButton;

/// 封面旋转开关：播放时旋转，暂停时停住
- (void)setCoverRotating:(BOOL)rotating;

@end

NS_ASSUME_NONNULL_END
