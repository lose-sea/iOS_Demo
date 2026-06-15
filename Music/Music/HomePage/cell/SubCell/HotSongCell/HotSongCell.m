//
//  HotSongCell.m
//  Music
//
//  Created by lose_sea on 2026/6/13.
//

#import "HotSongCell.h"

@implementation HotSongCell


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setUpInterface];
    }
    return self;
}


- (void) setUpInterface {
    self.coverView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.artistLabel = [[UILabel alloc] init];
    self.playButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.likeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    
    [self.contentView addSubview: self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(60);
    }];
    self.coverView.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.coverView.backgroundColor = [UIColor systemRedColor];
    
    
    [self.contentView addSubview: self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverView.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(40);
    }];
    self.titleLabel.font = [UIFont boldSystemFontOfSize: 20]; 
    
    [self.contentView addSubview: self.artistLabel];
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    self.artistLabel.font = [UIFont systemFontOfSize: 14];
    
    [self.contentView addSubview: self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
//        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
    
    self.playButton.clipsToBounds = YES;
    self.playButton.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.playButton setImage: [UIImage systemImageNamed: @"play.fill"] forState: UIControlStateNormal];
}







- (void)configWithSong:(Song *)song {
    self.coverView.image = song.coverImage;
    self.titleLabel.text = song.name;
    self.artistLabel.text = song.artist; 
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
