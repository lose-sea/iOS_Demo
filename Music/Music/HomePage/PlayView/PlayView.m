//
//  PlayView.m
//  Music
//
//  Created by lose_sea on 2026/6/14.
//


#import "PlayView.h"

@implementation PlayView
- (instancetype) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.coverView = [[UIImageView alloc] init];
    self.NameLabel = [[UILabel alloc] init];
    self.artistLabel = [[UILabel alloc] init];
    self.likeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.playButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.menuButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.likeButton setImage: [UIImage systemImageNamed: @"heart"] forState: UIControlStateNormal];
    [self.playButton setImage: [UIImage systemImageNamed: @"play.circle"] forState: UIControlStateNormal];
    [self.menuButton setImage: [UIImage systemImageNamed: @"ellipsis.circle"] forState: UIControlStateNormal];
    
    [self addSubview: self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(50);
    }];
    self.coverView.clipsToBounds = YES;
    self.coverView.layer.cornerRadius = 25;
    
    [self addSubview: self.NameLabel];
    [self.NameLabel sizeToFit];
    [self.NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverView.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(40);
        make.width.lessThanOrEqualTo(@120);
    }];
//    [self.NameLabel adjustsFontSizeToFitWidth];
    self.NameLabel.font = [UIFont boldSystemFontOfSize: 17];
    
    [self addSubview: self.artistLabel];
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.NameLabel.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    self.artistLabel.font = [UIFont systemFontOfSize: 15];
    
    [self addSubview: self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-100);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
    [self addSubview: self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.likeButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
   
    [self addSubview: self.menuButton];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
    self.coverView.image = [UIImage imageNamed: @"43.jpg"];
    self.NameLabel.text = @"待播放   ";
    self.artistLabel.text = @"   ";
    
    [self.likeButton addTarget: self action: @selector(pressLikeButton) forControlEvents: UIControlEventTouchUpInside];
    [self.playButton addTarget: self action: @selector(pressPlayButton) forControlEvents: UIControlEventTouchUpInside];
}

- (void) pressLikeButton {
    self.song.isLike = !self.song.isLike;
    [self configWithSong: self.song];
}

- (void) pressPlayButton {
    self.song.isPlay = !self.song.isPlay;
    [self configWithSong: self.song]; 
}

- (void) configWithSong:(Song *)song {
    self.coverView.image = song.coverImage;
    self.NameLabel.text = song.name;
    self.artistLabel.text = song.artist;
    if (song.isLike == NO) {
        [self.likeButton setImage: [UIImage systemImageNamed: @"heart"] forState: UIControlStateNormal];
        self.likeButton.tintColor = [UIColor systemBlueColor]; 
    } else {
        [self.likeButton setImage: [UIImage systemImageNamed: @"heart.fill"] forState: UIControlStateNormal];
        self.likeButton.tintColor = [UIColor systemRedColor];
    }
    if (song.isPlay == NO) {
        [self.playButton setImage: [UIImage systemImageNamed: @"play.circle"] forState: UIControlStateNormal];
    } else {
        [self.playButton setImage: [UIImage systemImageNamed: @"pause.circle"] forState: UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
