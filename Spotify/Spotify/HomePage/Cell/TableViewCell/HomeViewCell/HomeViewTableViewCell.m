//
//  HomeViewTableViewCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "HomeViewTableViewCell.h"
#import "Song.h"
#import "Singer.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kSongCoverSide = 56.0;
static const CGFloat kSongRowHeight = 72.0;

@interface HomeViewTableViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *singerNameLabel;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation HomeViewTableViewCell

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

    self.moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.moreButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    self.moreButton.tintColor = [UIColor secondaryLabelColor];
    [self.contentView addSubview:self.moreButton];

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

    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8.0);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(44.0, 44.0));
    }];

    [textStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(12.0);
        make.right.equalTo(self.moreButton.mas_left).offset(-4.0);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configureWithSong:(Song *)song {
    [self.coverImageView sp_setImageWithSource:song.coverURL placeholder:nil];
    self.songNameLabel.text = song.songName;
    self.singerNameLabel.text = song.singer.singerName;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.songNameLabel.text = nil;
    self.singerNameLabel.text = nil;
}

@end
