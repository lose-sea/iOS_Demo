//
//  HomeShortcutCardCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "HomeShortcutCardCell.h"
#import "HomeCard.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kShortcutCardWidth = 150.0;
static const CGFloat kShortcutCardHeight = 60.0;
static const CGFloat kShortcutCoverSide = 60.0;

@interface HomeShortcutCardCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation HomeShortcutCardCell

+ (CGSize)cardSize {
    return CGSizeMake(kShortcutCardWidth, kShortcutCardHeight);
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
    self.contentView.layer.cornerRadius = 4.0;
    self.contentView.clipsToBounds = YES;

    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    self.nameLabel.textColor = [UIColor labelColor];
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.height.mas_equalTo(kShortcutCoverSide);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(8.0);
        make.right.equalTo(self.contentView).offset(-8.0);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configureWithCard:(HomeCard *)card {
    [self.coverImageView sp_setImageWithSource:card.imageURL placeholder:nil];
    self.nameLabel.text = card.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.nameLabel.text = nil;
}

@end
