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
        self.backgroundColor = [UIColor systemBackgroundColor];
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

//- (instancetype) init {
//    self = [super init];
//    if (self) {
//        self.backgroundColor = [UIColor systemRedColor]; 
//        [self setUpInterface];
//    }
//    return self;
//}


- (void)setUpInterface {
    self.backgroundColor = [UIColor systemRedColor]; 
    self.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;

    // 封面（左，48×48）
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 6;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self addSubview:self.coverImageView];

    // 歌名
    self.songNameLabel = [[UILabel alloc] init];
    self.songNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.songNameLabel.textColor = [UIColor labelColor];
    [self addSubview:self.songNameLabel];

    // 歌手
    self.singer = [[UILabel alloc] init];
    self.singer.font = [UIFont systemFontOfSize:12];
    self.singer.textColor = [UIColor secondaryLabelColor];
    [self addSubview:self.singer];

    // 上一首
    self.previousButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.previousButton setImage:[UIImage systemImageNamed:@"backward.end.fill"]
                         forState:UIControlStateNormal];
    self.previousButton.tintColor = [UIColor labelColor];
    [self addSubview:self.previousButton];

    // 播放/暂停
    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playButton setImage:[UIImage systemImageNamed:@"play.fill"]
                     forState:UIControlStateNormal];
    self.playButton.tintColor = [UIColor labelColor];
    [self addSubview:self.playButton];

    // 下一首
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextButton setImage:[UIImage systemImageNamed:@"forward.end.fill"]
                     forState:UIControlStateNormal];
    self.nextButton.tintColor = [UIColor labelColor];
    [self addSubview:self.nextButton];

    // ---- 布局 ----
    // 封面
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(48);
    }];

    // 下一首（最右）
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(36);
    }];

    // 播放（下一首左边）
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextButton.mas_left).offset(-8);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(36);
    }];

    // 上一首（播放左边）
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playButton.mas_left).offset(-8);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(36);
    }];

    // 歌名：封面右边 → 上一首左边
    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(8);
        make.right.equalTo(self.previousButton.mas_left).offset(-8);
        make.top.equalTo(self.coverImageView);
    }];

    // 歌手：歌名下方
    [self.singer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.songNameLabel);
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(2);
    }];
}


@end
