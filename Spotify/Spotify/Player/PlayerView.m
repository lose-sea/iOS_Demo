//
//  PlayerView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "PlayerView.h"
#import <Masonry/Masonry.h>

@implementation PlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    // 封面图（居中偏上，方形圆角）
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 12;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self addSubview:self.coverImageView];

    // 歌名
    self.songNameLabel = [[UILabel alloc] init];
    self.songNameLabel.font = [UIFont boldSystemFontOfSize:22];
    self.songNameLabel.textColor = [UIColor labelColor];
    self.songNameLabel.numberOfLines = 2;
    [self addSubview:self.songNameLabel];

    // 歌手
    self.songerLabel = [[UILabel alloc] init];
    self.songerLabel.font = [UIFont systemFontOfSize:15];
    self.songerLabel.textColor = [UIColor secondaryLabelColor];
    self.songerLabel.numberOfLines = 1;
    [self addSubview:self.songerLabel];

    // 喜欢按钮（心形，左下）
    self.favouriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.favouriteButton setImage:[UIImage systemImageNamed:@"heart"]
                         forState:UIControlStateNormal];
    self.favouriteButton.tintColor = [UIColor labelColor];
    [self addSubview:self.favouriteButton];

    // 播放/暂停按钮（右下，圆形大按钮，灰色背景）
    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playButton setImage:[UIImage systemImageNamed:@"play.fill"]
                     forState:UIControlStateNormal];
    self.playButton.tintColor = [UIColor whiteColor];
    self.playButton.backgroundColor = [UIColor grayColor];
    self.playButton.layer.cornerRadius = 32; // 64pt 按钮 → 半径 32
    [self addSubview:self.playButton];

    // playPauseControl 用户声明但 playButton 已存在，这里保持不处理

    // Masonry 布局
    // 封面：居中偏上，300×300
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(40);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(300);
    }];

    // 歌名：封面下方
    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(24);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];

    // 歌手：歌名下方
    [self.songerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.songNameLabel);
    }];

    // 喜欢按钮：左下，在歌手下方
    [self.favouriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-40);
        make.left.equalTo(self).offset(24);
        make.width.height.mas_equalTo(44);
    }];

    // 播放/暂停按钮：右下，64×64 圆形
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.favouriteButton);
        make.right.equalTo(self).offset(-24);
        make.width.height.mas_equalTo(64);
    }];
}

@end
