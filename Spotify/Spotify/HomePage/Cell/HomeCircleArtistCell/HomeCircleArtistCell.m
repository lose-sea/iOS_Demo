//
//  HomeCircleArtistCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "HomeCircleArtistCell.h"
#import "HomeCard.h"
#import <Masonry/Masonry.h>

static const CGFloat kCircleSide = 110.0;
static const CGFloat kCircleNameHeight = 22.0;
static const CGFloat kCircleCardHeight = kCircleSide + 6.0 + kCircleNameHeight;

@interface HomeCircleArtistCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation HomeCircleArtistCell

+ (CGSize)cardSize {
    return CGSizeMake(kCircleSide, kCircleCardHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = kCircleSide / 2.0;
    [self.contentView addSubview:self.avatarImageView];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    self.nameLabel.textColor = [UIColor labelColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kCircleSide);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(6.0);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kCircleNameHeight);
    }];
}

- (void)configureWithCard:(HomeCard *)card {
    self.avatarImageView.image = [UIImage imageNamed:card.imageName];
    self.nameLabel.text = card.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarImageView.image = nil;
    self.nameLabel.text = nil;
}

@end
