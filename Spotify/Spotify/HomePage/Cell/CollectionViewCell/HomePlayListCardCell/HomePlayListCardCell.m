//
//  HomePlayListCardCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import "HomePlayListCardCell.h"
#import "HomeCard.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kCardCoverSide = 150.0;
static const CGFloat kCardTitleHeight = 20.0;
static const CGFloat kCardDescHeight = 34.0; // 描述最多两行
static const CGFloat kCardHeight = kCardCoverSide + 6.0 + kCardTitleHeight + 2.0 + kCardDescHeight;

@interface HomePlayListCardCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation HomePlayListCardCell

+ (CGSize)cardSize {
    return CGSizeMake(kCardCoverSide, kCardHeight);
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

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];
    self.nameLabel.textColor = [UIColor labelColor];
    [self.contentView addSubview:self.nameLabel];

    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:13.0];
    self.descLabel.textColor = [UIColor secondaryLabelColor];
    self.descLabel.numberOfLines = 2;
    [self.contentView addSubview:self.descLabel];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kCardCoverSide);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(6.0);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kCardTitleHeight);
    }];

    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2.0);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kCardDescHeight);
    }];
}

- (void)configureWithCard:(HomeCard *)card {
    [self.coverImageView sp_setImageWithSource:card.imageURL placeholder:nil];
    self.nameLabel.text = card.title;
    self.descLabel.text = card.subtitle;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.nameLabel.text = nil;
    self.descLabel.text = nil;
}

@end
