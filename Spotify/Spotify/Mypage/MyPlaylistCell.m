//
//  MyPlaylistCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import "MyPlaylistCell.h"
#import "SongListModel.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kCoverSide = 48.0;
static const CGFloat kRowHeight = 68.0;

@interface MyPlaylistCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation MyPlaylistCell

+ (CGFloat)rowHeight {
    return kRowHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 4.0;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self.contentView addSubview:self.coverImageView];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.nameLabel.textColor = [UIColor labelColor];

    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.font = [UIFont systemFontOfSize:13.0];
    self.infoLabel.textColor = [UIColor secondaryLabelColor];

    UIStackView *textStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.nameLabel, self.infoLabel]];
    textStack.axis = UILayoutConstraintAxisVertical;
    textStack.spacing = 4.0;
    [self.contentView addSubview:textStack];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16.0);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kCoverSide, kCoverSide));
    }];

    [textStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(12.0);
        make.right.equalTo(self.contentView).offset(-16.0);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configureWithPlaylist:(SongListModel *)playlist {
    [self.coverImageView sp_setImageWithSource:playlist.coverURL placeholder:nil];
    self.nameLabel.text = playlist.playlistName;

    // 系统默认歌单（我的喜欢）标记为不可删除
    NSString *prefix = playlist.isSystemPlaylist ? @"默认歌单 · 不可删除" : @"歌单";
    self.infoLabel.text = [NSString stringWithFormat:@"%@ · %lu 首歌曲",
                           prefix, (unsigned long)playlist.songs.count];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.nameLabel.text = nil;
    self.infoLabel.text = nil;
}

@end
