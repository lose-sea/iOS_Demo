//
//  SearchRankCardCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "SearchRankCardCell.h"
#import <Masonry/Masonry.h>

static const NSInteger kMaxVisibleRows = 8;
static const CGFloat kRowHeight = 40.0;
static const CGFloat kCardTitleHeight = 48.0;
static const CGFloat kCardPadding = 12.0;

@implementation SearchRankItem
@end

@implementation SearchRankCard

+ (instancetype)cardWithTitle:(NSString *)title items:(NSArray<SearchRankItem *> *)items {
    SearchRankCard *card = [[SearchRankCard alloc] init];
    card.title = title;
    card.items = items;
    return card;
}

@end

@interface SearchRankCardCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIStackView *rowsStackView;
@property (nonatomic, copy) NSArray<SearchRankItem *> *items;

@end

@implementation SearchRankCardCell

+ (CGFloat)cardHeight {
    return kCardPadding + kCardTitleHeight + kMaxVisibleRows * kRowHeight + kCardPadding;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.contentView.layer.cornerRadius = 12.0;
    self.contentView.clipsToBounds = YES;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor labelColor];
    [self.contentView addSubview:self.titleLabel];

    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage systemImageNamed:@"play.fill"] forState:UIControlStateNormal];
    self.playButton.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
    self.playButton.tintColor = [UIColor labelColor];
    [self.playButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    self.playButton.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    self.playButton.layer.cornerRadius = 14.0;
    [self.contentView addSubview:self.playButton];

    self.rowsStackView = [[UIStackView alloc] init];
    self.rowsStackView.axis = UILayoutConstraintAxisVertical;
    self.rowsStackView.spacing = 0.0;
    [self.contentView addSubview:self.rowsStackView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kCardPadding);
        make.left.equalTo(self.contentView).offset(16.0);
        make.height.mas_equalTo(kCardTitleHeight);
    }];

    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(12.0);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(76.0, 28.0));
    }];

    [self.rowsStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(16.0);
        make.right.equalTo(self.contentView).offset(-12.0);
        make.bottom.equalTo(self.contentView).offset(-kCardPadding);
    }];
}

#pragma mark - Public

- (void)configureWithCard:(SearchRankCard *)card {
    self.titleLabel.text = card.title;
    self.items = card.items;

    // 行数固定，重建代价可忽略
    [self.rowsStackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSArray<SearchRankItem *> *visibleItems = card.items;
    if (visibleItems.count > kMaxVisibleRows) {
        visibleItems = [visibleItems subarrayWithRange:NSMakeRange(0, kMaxVisibleRows)];
    }

    for (SearchRankItem *item in visibleItems) {
        [self.rowsStackView addArrangedSubview:[self rowForItem:item]];
    }
}

- (UIView *)rowForItem:(SearchRankItem *)item {
    UIButton *wordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    wordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    [text appendAttributedString:[[NSAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%2ld  ", (long)item.rank]
            attributes:@{NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:15.0 weight:UIFontWeightBold],
                         NSForegroundColorAttributeName: (item.rank <= 3 ? [UIColor systemRedColor] : [UIColor secondaryLabelColor])}]];
    [text appendAttributedString:[[NSAttributedString alloc]
        initWithString:item.title ?: @""
            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                         NSForegroundColorAttributeName: [UIColor labelColor]}]];
    [wordButton setAttributedTitle:text forState:UIControlStateNormal];
    wordButton.tag = item.rank - 1;   // 回调用
    [wordButton addTarget:self action:@selector(pressWord:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightBold];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.layer.cornerRadius = 4.0;
    tagLabel.clipsToBounds = YES;
    if (item.tag.length > 0) {
        tagLabel.text = item.tag;
        tagLabel.textColor = item.tagHighlighted ? [UIColor whiteColor] : [UIColor systemGreenColor];
        tagLabel.backgroundColor = item.tagHighlighted
            ? [UIColor systemRedColor]
            : [[UIColor systemGreenColor] colorWithAlphaComponent:0.15];
    } else {
        tagLabel.backgroundColor = [UIColor clearColor];
    }

    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[wordButton, tagLabel]];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.alignment = UIStackViewAlignmentCenter;
    [row mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRowHeight);
    }];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24.0);
        make.height.mas_equalTo(16.0);
    }];
    return row;
}

- (void)pressWord:(UIButton *)sender {
    NSUInteger index = sender.tag;
    if (index >= self.items.count) return;
    if (self.onSelectWord) {
        self.onSelectWord(self.items[index].title);
    }
}

@end
