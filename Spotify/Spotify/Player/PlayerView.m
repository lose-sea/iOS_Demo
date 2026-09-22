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


- (void)setUpInterface {
    self.backgroundColor = [UIColor systemRedColor];
    self.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;

    // 点击 mini player 整体（按钮区域会被 UIControl 拦截，无需排除）
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didTapPlayer)];
    [self addGestureRecognizer:tap];

    // 封面（左，48×48）
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 24;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self addSubview:self.coverImageView];

    
    // 歌名
    self.songNameLabel = [[UILabel alloc] init];
    self.songNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.songNameLabel.textColor = [UIColor labelColor];
    [self addSubview:self.songNameLabel];


    // 歌手
    self.singerLabel = [[UILabel alloc] init];
    self.singerLabel.font = [UIFont systemFontOfSize:12];
    self.singerLabel.textColor = [UIColor secondaryLabelColor];
    [self addSubview:self.singerLabel];
    
    // 播放/暂停
    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playButton setImage:[UIImage systemImageNamed:@"play.fill"]
                     forState:UIControlStateNormal];
    self.playButton.tintColor = [UIColor labelColor];
    [self addSubview:self.playButton];
    
    
    // 喜欢
    self.favouriteButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.favouriteButton setImage:[UIImage systemImageNamed:@"heart"]
                                forState:UIControlStateNormal];
    self.favouriteButton.tintColor = [UIColor labelColor];
    [self addSubview: self.favouriteButton];
    

    // 下一首
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextButton setImage:[UIImage systemImageNamed:@"forward.end.fill"]
                     forState:UIControlStateNormal];
    self.nextButton.tintColor = [UIColor labelColor];
    [self addSubview:self.nextButton];
    


    
    // 封面
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(48);
    }];
    
    
    // 歌名：封面右边 → 上一首左边
    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(8);
        make.right.mas_equalTo(self.favouriteButton.mas_left).offset(-8);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.coverImageView);
    }];
    
    
    // 歌手：歌名下方
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.songNameLabel);
        make.top.equalTo(self.songNameLabel.mas_bottom);
        make.height.mas_equalTo(20);
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
    
        // 喜欢
        [self.favouriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.playButton.mas_left);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(36);
        }];



}


#pragma mark - Private

- (void)didTapPlayer {
    if ([self.delegate respondsToSelector:@selector(playerViewDidTapPlayer:)]) {
        [self.delegate playerViewDidTapPlayer:self];
    }
}

@end
