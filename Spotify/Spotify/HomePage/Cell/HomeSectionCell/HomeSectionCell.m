//
//  HomeSectionCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "HomeSectionCell.h"
#import "HomeCard.h"
#import "HomePlayListCardCell.h"
#import "HomeShortcutCardCell.h"
#import "HomeArtistCardCell.h"
#import "HomeCircleArtistCell.h"
#import "HomeRadioCardCell.h"
#import <Masonry/Masonry.h>

NSString *const HomeSectionCellID = @"HomeSectionCell";

static const CGFloat kSectionTitleHeight = 44.0;
static const CGFloat kSectionBottomSpacing = 8.0;
static const CGFloat kHorizontalInset = 16.0;
static const CGFloat kCardSpacing = 12.0;

@interface HomeSectionCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) HomeSection *section;

@end

@implementation HomeSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor labelColor];
    [self.contentView addSubview:self.titleLabel];

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumLineSpacing = kCardSpacing;
    self.layout.minimumInteritemSpacing = kCardSpacing;
    self.layout.sectionInset = UIEdgeInsetsMake(0, kHorizontalInset, 0, kHorizontalInset);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HomeShortcutCardCell class] forCellWithReuseIdentifier:@"HomeShortcutCardCell"];
    [self.collectionView registerClass:[HomePlayListCardCell class] forCellWithReuseIdentifier:@"HomePlayListCardCell"];
    [self.collectionView registerClass:[HomeArtistCardCell class] forCellWithReuseIdentifier:@"HomeArtistCardCell"];
    [self.collectionView registerClass:[HomeCircleArtistCell class] forCellWithReuseIdentifier:@"HomeCircleArtistCell"];
    [self.collectionView registerClass:[HomeRadioCardCell class] forCellWithReuseIdentifier:@"HomeRadioCardCell"];
    [self.contentView addSubview:self.collectionView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(kHorizontalInset);
        make.right.equalTo(self.contentView).offset(-kHorizontalInset);
        make.height.mas_equalTo(kSectionTitleHeight);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - Public

+ (CGFloat)heightForSection:(HomeSection *)section {
    CGFloat titleHeight = (section.title.length > 0) ? kSectionTitleHeight : 0;
    return titleHeight + [self cardSizeForType:section.type].height + kSectionBottomSpacing;
}

- (void)configureWithSection:(HomeSection *)section {
    self.section = section;
    self.titleLabel.text = section.title;

    // 无标题分区（顶部快捷入口）把标题高度收成 0
    CGFloat titleHeight = (section.title.length > 0) ? kSectionTitleHeight : 0;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleHeight);
    }];

    self.layout.itemSize = [HomeSectionCell cardSizeForType:section.type];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.section.cards.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCard *card = self.section.cards[indexPath.item];
    NSString *identifier = [HomeSectionCell cellIdentifierForType:self.section.type];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(configureWithCard:)]) {
        [(id)cell configureWithCard:card];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HomeCard *card = self.section.cards[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(homeSectionCell:didSelectCard:atIndex:)]) {
        [self.delegate homeSectionCell:self didSelectCard:card atIndex:indexPath.item];
    }
}

#pragma mark - Private

+ (CGSize)cardSizeForType:(HomeSectionType)type {
    switch (type) {
        // 快捷入口宽度要按分区实际宽度算，这里只给个占位值，真实宽度在 layoutSubviews 里修正
        case HomeSectionTypeShortcut:
            return CGSizeMake(150.0, [HomeShortcutCardCell cardSize].height);
        case HomeSectionTypePlaylist:
            return [HomePlayListCardCell cardSize];
        case HomeSectionTypeArtist:
            return [HomeArtistCardCell cardSize];
        case HomeSectionTypeCircle:
            return [HomeCircleArtistCell cardSize];
        case HomeSectionTypeRadio:
            return [HomeRadioCardCell cardSize];
    }
}

+ (NSString *)cellIdentifierForType:(HomeSectionType)type {
    switch (type) {
        case HomeSectionTypeShortcut: return @"HomeShortcutCardCell";
        case HomeSectionTypePlaylist: return @"HomePlayListCardCell";
        case HomeSectionTypeArtist:   return @"HomeArtistCardCell";
        case HomeSectionTypeCircle:   return @"HomeCircleArtistCell";
        case HomeSectionTypeRadio:    return @"HomeRadioCardCell";
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.section = nil;
    self.titleLabel.text = nil;
}

/// 快捷入口一屏放两张，宽度要等分区宽度确定后再算
- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.section.type != HomeSectionTypeShortcut) return;

    CGFloat width = CGRectGetWidth(self.bounds);
    if (width <= 0) return;

    CGFloat cardWidth = (width - kHorizontalInset * 2 - kCardSpacing) / 2.0;
    if (fabs(cardWidth - self.layout.itemSize.width) < 0.5) return;
    self.layout.itemSize = CGSizeMake(cardWidth, [HomeShortcutCardCell cardSize].height);
}

@end
