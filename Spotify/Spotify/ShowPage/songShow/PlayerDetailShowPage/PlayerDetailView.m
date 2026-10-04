//
//  PlayerDetailView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "PlayerDetailView.h"
#import <Masonry/Masonry.h>

static NSString * const kCoverRotationKey = @"coverRotation";
/// 转一圈的时长（秒）
static const NSTimeInterval kCoverRotationDuration = 20.0;

@interface PlayerDetailView () {
    /// 封面当前停住的角度（弧度）。动画只改表现层，暂停后要把它写回模型层，否则会弹回 0°
    CGFloat _coverRotationAngle;
}

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
@property (nonatomic, strong, readwrite) UIButton *moreButton;

@end

@implementation PlayerDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

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
    // 系统图标创建按钮
    UIImage *closeIcon = [UIImage systemImageNamed:@"chevron.down"
                                  withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:20.0]]; // 创建符号配置,尺寸20
    [self.closeButton setImage:closeIcon forState:UIControlStateNormal];
    self.closeButton.tintColor = [UIColor labelColor];
    [self addSubview:self.closeButton];

//    // TODO: Masonry 1.1.0 没有 safeArea API，这里用固定值，真机刘海屏如需精确可改用 safeAreaLayoutGuide
//    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(56.0);
//        make.left.equalTo(self).offset(16.0);
//        make.size.mas_equalTo(CGSizeMake(36.0, 36.0));
//    }];
    
    // 预留安全区间距
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        // 顶部安全区
         make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(16.0);
        // 左边安全区
         make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(16.0);
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
    
    NSLog(@"%f", self.coverImageView.bounds.size.width);
}

- (void)setUpLyrics {
    // 当前行（后续接网络歌词后由播放进度驱动）
    self.currentLyricsLabel = [[UILabel alloc] init];
    self.currentLyricsLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    self.currentLyricsLabel.textColor = [UIColor labelColor];
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
    self.songNameLabel.textColor = [UIColor labelColor];
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
    // 一播放部分颜色
    self.progressSlider.minimumTrackTintColor = [UIColor systemGreenColor];
    // 未播放部分颜色
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
    UIImageSymbolConfiguration *big = [UIImageSymbolConfiguration configurationWithPointSize:40.0];
    

    self.favouriteButton = [self buttonWithImageName:@"heart" configuration:normal];
    self.commentButton = [self buttonWithImageName:@"ellipsis.bubble" configuration:normal];
    self.previousButton = [self buttonWithImageName:@"backward.end.fill" configuration:normal];
    self.nextButton = [self buttonWithImageName:@"forward.end.fill" configuration:normal];
    self.moreButton = [self buttonWithImageName:@"ellipsis" configuration:normal];

    // 大播放按钮：底色用 labelColor、图标用 systemBackgroundColor，两套主题下都不会和页面同色
    // 深色：白圆 + 黑图标；浅色：黑圆 + 白图标
 
    
//    UIImage *playImage = [UIImage systemImageNamed:@"play.fill"
//                                  withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:40.0]]; // 创建符号配置,尺寸20
//    
//    self.playButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    [self.playButton setImage: playImage forState: UIControlStateNormal];
    
    self.playButton = [self buttonWithImageName:@"play.fill" configuration:big];
    
    
//    self.playButton.backgroundColor = [UIColor labelColor];
    self.playButton.tintColor = [UIColor labelColor];
    // 圆角半径写死 32，必须给固定 64 尺寸，否则 intrinsic size 会被裁成奇怪的形状
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64.0, 64.0));
    }];
    self.playButton.layer.cornerRadius = 32.0;

    UIStackView *buttonRow = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.favouriteButton, self.commentButton, self.previousButton, self.playButton,
        self.nextButton, self.moreButton
    ]];
    buttonRow.axis = UILayoutConstraintAxisHorizontal;
    // 主轴空间分配: 中心点等距
    buttonRow.distribution = UIStackViewDistributionEqualCentering;
    // 垂直居中
    buttonRow.alignment = UIStackViewAlignmentCenter;
    [self addSubview:buttonRow];

    [buttonRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24.0);
        make.right.equalTo(self).offset(-24.0);
        make.bottom.equalTo(self).offset(-30.0);
        make.height.mas_equalTo(80.0);
    }];
}


// 设置 cover 为圆形
- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = self.coverImageView.bounds.size.width / 2.0; 
}


- (UIButton *)buttonWithImageName:(NSString *)imageName
                    configuration:(UIImageSymbolConfiguration *)configuration {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *icon = [UIImage systemImageNamed:imageName withConfiguration:configuration];
    [button setImage:icon forState:UIControlStateNormal];
    button.tintColor = [UIColor labelColor];
    return button;
}

#pragma mark - Public

- (void)setCoverRotating:(BOOL)rotating {
    if (rotating) {
        [self startCoverRotation];
    } else {
        [self stopCoverRotation];
    }
}

/// 从 _coverRotationAngle 接着转，而不是每次都从 0° 重新开始
- (void)startCoverRotation {
    // 已经在转了就不重复添加，否则动画会被重置
    if ([self.coverImageView.layer animationForKey:kCoverRotationKey]) {
        return;
    }
    // 创建动画
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; // 绕 z 轴旋转(垂直于屏幕)
    rotation.fromValue = @(_coverRotationAngle);
    rotation.toValue = @(_coverRotationAngle + M_PI * 2);
    // 一圈 20 秒
    rotation.duration = kCoverRotationDuration;
    // 无限循环
    // HUGE_VALF -> float无穷大
    rotation.repeatCount = HUGE_VALF;
    [self.coverImageView.layer addAnimation:rotation forKey:kCoverRotationKey];
}

/// 暂停：先记下当前角度，把角度写进模型层，最后才移除动画
/// 顺序不能反：removeAnimationForKey: 之后 presentationLayer 就被丢弃了，取不到角度
- (void)stopCoverRotation {
    CALayer *presentationLayer = self.coverImageView.layer.presentationLayer;
    if (presentationLayer) {
        CATransform3D transform = presentationLayer.transform;
        // 纯 Z 轴旋转：m11 = cos(θ)，m12 = sin(θ)，反解出当前角度
        _coverRotationAngle = atan2(transform.m12, transform.m11);
    }
    [self.coverImageView.layer removeAnimationForKey:kCoverRotationKey];
    // 动画只作用于表现层，移除后必须把角度落到模型层，否则封面会弹回 0°
    self.coverImageView.layer.transform = CATransform3DMakeRotation(_coverRotationAngle, 0.0, 0.0, 1.0);
}

@end
