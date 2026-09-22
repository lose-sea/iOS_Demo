//
//  PlayerDetailView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "PlayerDetailView.h"
#import <Masonry/Masonry.h>

static NSString * const kCoverRotationKey = @"coverRotation";

@interface PlayerDetailView ()

@property (nonatomic, strong, readwrite) UIButton *closeButton;
@property (nonatomic, strong, readwrite) UIImageView *coverImageView;
@property (nonatomic, strong, readwrite) UILabel *currentLyricsLabel;
@property (nonatomic, strong, readwrite) UILabel *nextLyricsLabel;
@property (nonatomic, strong, readwrite) UILabel *songNameLabel;
@property (nonatomic, strong, readwrite) UILabel *singerLabel;
@property (nonatomic, strong, readwrite) UISlider *progressSlider;
@property (nonatomic, strong, readwrite) UILabel *currentTimeLabel;
@property (nonatomic, strong, readwrite) UILabel *durationLabel;
@property (nonatomic, strong, readwrite) UIButton *favouriteButton;
@property (nonatomic, strong, readwrite) UIButton *commentButton;
@property (nonatomic, strong, readwrite) UIButton *previousButton;
@property (nonatomic, strong, readwrite) UIButton *playButton;
@property (nonatomic, strong, readwrite) UIButton *nextButton;

@end

@implementation PlayerDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor blackColor];

    [self setUpCloseButton];
    [self setUpCover];
    [self setUpLyrics];
    [self setUpSongInfo];
    [self setUpProgress];
    [self setUpButtonRow];
}

#pragma mark - 子视图

- (void)setUpCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeIcon = [UIImage systemImageNamed:@"chevron.down"
                                  withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:20.0]];
    [self.closeButton setImage:closeIcon forState:UIControlStateNormal];
    self.closeButton.tintColor = [UIColor whiteColor];
    [self addSubview:self.closeButton];

    // TODO: Masonry 1.1.0 没有 safeArea API，这里用固定值，真机刘海屏如需精确可改用 safeAreaLayoutGuide
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(56.0);
        make.left.equalTo(self).offset(16.0);
        make.size.mas_equalTo(CGSizeMake(36.0, 36.0));
    }];
}

- (void)setUpCover {
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 12.0;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    [self addSubview:self.coverImageView];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeButton.mas_bottom).offset(24.0);
        make.left.equalTo(self).offset(24.0);
        make.right.equalTo(self).offset(-24.0);
        // 正方形 = 宽度；空间不够时允许压缩（小屏优先保住下方控件）
        make.height.equalTo(self.mas_width).offset(-48.0).priorityHigh();
    }];
}

- (void)setUpLyrics {
    // 当前行（后续接网络歌词后由播放进度驱动）
    self.currentLyricsLabel = [[UILabel alloc] init];
    self.currentLyricsLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    self.currentLyricsLabel.textColor = [UIColor whiteColor];
    self.currentLyricsLabel.text = @"暂无歌词";
    [self addSubview:self.currentLyricsLabel];

    self.nextLyricsLabel = [[UILabel alloc] init];
    self.nextLyricsLabel.font = [UIFont systemFontOfSize:16.0];
    self.nextLyricsLabel.textColor = [UIColor secondaryLabelColor];
    [self addSubview:self.nextLyricsLabel];

    [self.currentLyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(24.0);
        make.left.equalTo(self).offset(24.0);
        make.right.equalTo(self).offset(-24.0);
        make.height.mas_equalTo(28.0);
    }];

    [self.nextLyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentLyricsLabel.mas_bottom).offset(4.0);
        make.left.right.equalTo(self.currentLyricsLabel);
        make.height.mas_equalTo(22.0);
    }];
}

- (void)setUpSongInfo {
    self.songNameLabel = [[UILabel alloc] init];
    self.songNameLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
    self.songNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.songNameLabel];

    self.singerLabel = [[UILabel alloc] init];
    self.singerLabel.font = [UIFont systemFontOfSize:15.0];
    self.singerLabel.textColor = [UIColor secondaryLabelColor];
    [self addSubview:self.singerLabel];

    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nextLyricsLabel.mas_bottom).offset(20.0);
        make.left.right.equalTo(self.currentLyricsLabel);
        make.height.mas_equalTo(30.0);
    }];

    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(4.0);
        make.left.right.equalTo(self.currentLyricsLabel);
        make.height.mas_equalTo(22.0);
    }];
}

- (void)setUpProgress {
    self.progressSlider = [[UISlider alloc] init];
    self.progressSlider.minimumValue = 0.0;
    self.progressSlider.maximumValue = 1.0;
    self.progressSlider.value = 0.0;
    self.progressSlider.minimumTrackTintColor = [UIColor systemGreenColor];
    self.progressSlider.maximumTrackTintColor = [UIColor tertiaryLabelColor];
    [self addSubview:self.progressSlider];

    self.currentTimeLabel = [[UILabel alloc] init];
    self.currentTimeLabel.font = [UIFont monospacedDigitSystemFontOfSize:12.0 weight:UIFontWeightRegular];
    self.currentTimeLabel.textColor = [UIColor secondaryLabelColor];
    self.currentTimeLabel.text = @"00:00";
    [self addSubview:self.currentTimeLabel];

    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.font = [UIFont monospacedDigitSystemFontOfSize:12.0 weight:UIFontWeightRegular];
    self.durationLabel.textColor = [UIColor secondaryLabelColor];
    self.durationLabel.text = @"00:00";
    [self addSubview:self.durationLabel];

    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.singerLabel.mas_bottom).offset(24.0);
        make.left.equalTo(self).offset(24.0);
        make.right.equalTo(self).offset(-24.0);
        make.height.mas_equalTo(30.0);
    }];

    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressSlider.mas_bottom).offset(2.0);
        make.left.equalTo(self.progressSlider);
        make.height.mas_equalTo(16.0);
    }];

    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressSlider.mas_bottom).offset(2.0);
        make.right.equalTo(self.progressSlider);
        make.height.mas_equalTo(16.0);
    }];
}

- (void)setUpButtonRow {
    UIImageSymbolConfiguration *normal = [UIImageSymbolConfiguration configurationWithPointSize:24.0];
    UIImageSymbolConfiguration *big = [UIImageSymbolConfiguration configurationWithPointSize:28.0];

    self.favouriteButton = [self buttonWithImageName:@"heart" configuration:normal];
    self.commentButton = [self buttonWithImageName:@"ellipsis.bubble" configuration:normal];
    self.previousButton = [self buttonWithImageName:@"backward.end.fill" configuration:normal];
    self.nextButton = [self buttonWithImageName:@"forward.end.fill" configuration:normal];

    // 大播放按钮：白圆底 + 黑色图标
    self.playButton = [self buttonWithImageName:@"play.fill" configuration:big];
    self.playButton.backgroundColor = [UIColor systemBackgroundColor];
    self.playButton.layer.cornerRadius = 32.0;
    self.playButton.tintColor = [UIColor labelColor];

    UIStackView *buttonRow = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.favouriteButton, self.commentButton, self.previousButton, self.playButton, self.nextButton
    ]];
    buttonRow.axis = UILayoutConstraintAxisHorizontal;
    buttonRow.distribution = UIStackViewDistributionEqualCentering;
    buttonRow.alignment = UIStackViewAlignmentCenter;
    [self addSubview:buttonRow];

    [buttonRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24.0);
        make.right.equalTo(self).offset(-24.0);
        make.bottom.equalTo(self).offset(-30.0);
        make.height.mas_equalTo(80.0);
    }];
}

- (UIButton *)buttonWithImageName:(NSString *)imageName
                    configuration:(UIImageSymbolConfiguration *)configuration {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *icon = [UIImage systemImageNamed:imageName withConfiguration:configuration];
    [button setImage:icon forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    return button;
}

#pragma mark - Public

- (void)setCoverRotating:(BOOL)rotating {
    if (rotating) {
        if ([self.coverImageView.layer animationForKey:kCoverRotationKey]) return;
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotation.fromValue = @0;
        rotation.toValue = @(M_PI * 2);
        rotation.duration = 20.0;
        rotation.repeatCount = HUGE_VALF;
        [self.coverImageView.layer addAnimation:rotation forKey:kCoverRotationKey];
    } else {
        [self.coverImageView.layer removeAnimationForKey:kCoverRotationKey];
    }
}

@end
