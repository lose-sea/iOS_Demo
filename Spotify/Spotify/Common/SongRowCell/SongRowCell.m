//
//  HomeViewTableViewCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "SongRowCell.h"
#import "Song.h"
#import "Singer.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kSongCoverSide = 56.0;
static const CGFloat kSongRowHeight = 72.0;
static const CGFloat kButtonSide = 44.0;

@interface SongRowCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *singerNameLabel;
@property (nonatomic, strong, readwrite) UIButton *favouriteButton;
@property (nonatomic, strong, readwrite) UIButton *playButton;

@end

@implementation SongRowCell

+ (CGFloat)rowHeight {
    return kSongRowHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 6.0;
    [self.contentView addSubview:self.coverImageView];

    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:18.0];

    self.favouriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.favouriteButton setImage:[UIImage systemImageNamed:@"heart" withConfiguration:config]
                          forState:UIControlStateNormal];
    self.favouriteButton.tintColor = [UIColor secondaryLabelColor];
    [self.favouriteButton addTarget:self
                             action:@selector(pressFavouriteButton)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favouriteButton];

    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playButton setImage:[UIImage systemImageNamed:@"play.fill" withConfiguration:config]
                     forState:UIControlStateNormal];
    self.playButton.tintColor = [UIColor labelColor];
    [self.playButton addTarget:self
                        action:@selector(pressPlayButton)
              forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.playButton];

    self.songNameLabel = [[UILabel alloc] init];
    self.songNameLabel.font = [UIFont systemFontOfSize:16.0];
    self.songNameLabel.textColor = [UIColor labelColor];

    self.singerNameLabel = [[UILabel alloc] init];
    self.singerNameLabel.font = [UIFont systemFontOfSize:13.0];
    self.singerNameLabel.textColor = [UIColor secondaryLabelColor];

    UIStackView *textStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.songNameLabel, self.singerNameLabel]];
    textStack.axis = UILayoutConstraintAxisVertical;
    textStack.spacing = 4.0;
    textStack.alignment = UIStackViewAlignmentFill;
    [self.contentView addSubview:textStack];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16.0);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kSongCoverSide, kSongCoverSide));
    }];

    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8.0);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kButtonSide, kButtonSide));
    }];

    [self.favouriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playButton.mas_left).offset(-4.0);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kButtonSide, kButtonSide));
    }];

    [textStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(12.0);
        make.right.equalTo(self.favouriteButton.mas_left).offset(-4.0);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configureWithSong:(Song *)song isPlaying:(BOOL)isPlaying {
    [self.coverImageView sp_setImageWithSource:song.coverURL placeholder:nil];
    self.songNameLabel.text = song.songName;
    self.singerNameLabel.text = song.singer.singerName;

    // 正在播放 → 暂停图标 + 绿色；否则播放图标
    NSString *playIcon = isPlaying ? @"pause.fill" : @"play.fill";
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:18.0];
    [self.playButton setImage:[UIImage systemImageNamed:playIcon withConfiguration:config]
                     forState:UIControlStateNormal];
    self.playButton.tintColor = isPlaying ? [UIColor systemGreenColor] : [UIColor labelColor];

    // 收藏状态：实心红心 + 粉色
    NSString *favIcon = song.isFavourite ? @"heart.fill" : @"heart";
    [self.favouriteButton setImage:[UIImage systemImageNamed:favIcon withConfiguration:config]
                          forState:UIControlStateNormal];
    self.favouriteButton.tintColor = song.isFavourite
        ? [UIColor systemPinkColor]
        : [UIColor secondaryLabelColor];
}

#pragma mark - 事件

- (void)pressFavouriteButton {
    if ([self.delegate respondsToSelector:@selector(songCellDidTapFavourite:)]) {
        [self.delegate songCellDidTapFavourite:self];
    }
}

- (void)pressPlayButton {
    if ([self.delegate respondsToSelector:@selector(songCellDidTapPlay:)]) {
        [self.delegate songCellDidTapPlay:self];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.delegate = nil;
    self.coverImageView.image = nil;
    self.songNameLabel.text = nil;
    self.singerNameLabel.text = nil;
}

@end
