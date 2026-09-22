//
//  HomeRadioCardCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "HomeRadioCardCell.h"
#import "HomeCard.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kRadioCardSide = 150.0;

@interface HomeRadioCardCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HomeRadioCardCell

+ (CGSize)cardSize {
    return CGSizeMake(kRadioCardSide, kRadioCardSide);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];

    self.contentView.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    self.contentView.layer.cornerRadius = 8.0;
    self.contentView.clipsToBounds = YES;

    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];

    // 压暗一层，保证白字可读
    self.dimView = [[UIView alloc] init];
    self.dimView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    [self.contentView addSubview:self.dimView];

    self.badgeLabel = [[UILabel alloc] init];
    self.badgeLabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightSemibold];
    self.badgeLabel.textColor = [UIColor whiteColor];
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    self.badgeLabel.layer.cornerRadius = 8.0;
    self.badgeLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.badgeLabel];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.dimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(8.0);
        make.height.mas_equalTo(16.0);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8.0);
        make.right.equalTo(self.contentView).offset(-8.0);
        make.bottom.equalTo(self.contentView).offset(-8.0);
    }];
}

- (void)configureWithCard:(HomeCard *)card {
    [self.coverImageView sp_setImageWithSource:card.imageURL placeholder:nil];
    self.badgeLabel.text = card.badge;
    self.badgeLabel.hidden = (card.badge.length == 0);
    self.titleLabel.text = card.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.badgeLabel.text = nil;
    self.titleLabel.text = nil;
}

@end
