//
//  HomeArtistCardCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "HomeArtistCardCell.h"
#import "HomeCard.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kArtistCoverSide = 150.0;
static const CGFloat kArtistBannerHeight = 28.0;
static const CGFloat kArtistDescHeight = 34.0;
static const CGFloat kArtistCardHeight = kArtistCoverSide + 6.0 + kArtistDescHeight;

@interface HomeArtistCardCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) UILabel *bannerLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation HomeArtistCardCell

+ (CGSize)cardSize {
    return CGSizeMake(kArtistCoverSide, kArtistCardHeight);
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

    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 8.0;
    [self.contentView addSubview:self.coverImageView];

    // 压在封面中间的半透明横幅
    self.bannerView = [[UIView alloc] init];
    self.bannerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    [self.coverImageView addSubview:self.bannerView];

    self.bannerLabel = [[UILabel alloc] init];
    self.bannerLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    self.bannerLabel.textColor = [UIColor whiteColor];
    self.bannerLabel.textAlignment = NSTextAlignmentCenter;
    [self.bannerView addSubview:self.bannerLabel];

    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:13.0];
    self.descLabel.textColor = [UIColor secondaryLabelColor];
    self.descLabel.numberOfLines = 2;
    [self.contentView addSubview:self.descLabel];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kArtistCoverSide);
    }];

    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.coverImageView);
        make.centerY.equalTo(self.coverImageView);
        make.height.mas_equalTo(kArtistBannerHeight);
    }];

    [self.bannerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bannerView).offset(8.0);
        make.right.equalTo(self.bannerView).offset(-8.0);
        make.centerY.equalTo(self.bannerView);
    }];

    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(6.0);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kArtistDescHeight);
    }];
}

- (void)configureWithCard:(HomeCard *)card {
    [self.coverImageView sp_setImageWithSource:card.imageURL placeholder:nil];
    self.bannerLabel.text = card.title;
    self.descLabel.text = card.subtitle;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.bannerLabel.text = nil;
    self.descLabel.text = nil;
}

@end
